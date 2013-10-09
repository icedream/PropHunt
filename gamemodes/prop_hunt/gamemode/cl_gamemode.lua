function GM:UpdateHUD_Dead( bWaitingToSpawn, InRound )
	if (!InRound && GAMEMODE.RoundBased) then
	
		local RespawnText = vgui.Create( "DHudElement" );
		RespawnText:SizeToContents()
		RespawnText:SetText( "Waiting for round start" )
		GAMEMODE:AddHUDItem( RespawnText, 8 )
		return
	end

	if (bWaitingToSpawn) then
		local RespawnTimer = vgui.Create( "DHudCountdown" );
		RespawnTimer:SizeToContents()
		RespawnTimer:SetValueFunction( function() return LocalPlayer():GetNWFloat( "RespawnTime", 0 ) end )
		RespawnTimer:SetLabel("SPAWN IN")
		GAMEMODE:AddHUDItem(RespawnTimer, 8)
		return
	end
	
	if (InRound) then
		local RoundTimer = vgui.Create( "DHudCountdown" )
		RoundTimer:SizeToContents()
		RoundTimer:SetValueFunction( function() 
			if ( GetGlobalFloat( "RoundStartTime", 0 ) > CurTime() ) then return GetGlobalFloat( "RoundStartTime", 0 )  end 
			return GetGlobalFloat( "RoundEndTime" )
		end )
		RoundTimer:SetLabel("TIME")
		GAMEMODE:AddHUDItem(RoundTimer, 8)

		-- Hunters will be unlocked and unblinded in...
		local blindlock_time_left = (GetConVar("HUNTER_BLINDLOCK_TIME"):GetInt() - (CurTime() - GetGlobalFloat("RoundStartTime", 0))) + 1
		if blindlock_time_left >=1 then
			PropHunt.GUI.ReleaseTimer = vgui.Create( "DHudCountdown" );
			PropHunt.GUI.ReleaseTimer:SizeToContents()
			PropHunt.GUI.ReleaseTimer:SetValueFunction( function()
				local blindlock_time_left = (GetConVar("HUNTER_BLINDLOCK_TIME"):GetInt() - (CurTime() - GetGlobalFloat("RoundStartTime", 0))) + 1
				if blindlock_time_left < 1 && PropHunt.GUI.ReleaseTimer != nil then
					GAMEMODE:RemoveHUDItem(PropHunt.GUI.ReleaseTimer)
					PropHunt.GUI.ReleaseTimer = nil
					--surface.PlaySound("ui/hint.wav")
					surface.PlaySound("buttons/bell1.wav")
					GAMEMODE:AddPlayerAction("Hunters have been released and unblinded.")
				else
					return blindlock_time_left + CurTime() - 1
				end
				return nil
			end )
			PropHunt.GUI.ReleaseTimer:SetLabel("HUNTER RELEASE")
			GAMEMODE:AddHUDItem(PropHunt.GUI.ReleaseTimer, 9) -- TODO: Decide if top-left or leave current top-right as it's overlaying death messages
		end
		return
	end

	-- TODO: Do we need the "Press Fire to Spawn" even?	
/*
	if ( Team != TEAM_SPECTATOR && !Alive ) then
	
		local RespawnText = vgui.Create( "DHudElement" );
		RespawnText:SizeToContents()
		RespawnText:SetText( "Press Fire to Spawn" )
		GAMEMODE:AddHUDItem( RespawnText, 8 )
		
	end
*/

end

function GM:UpdateHUD_Alive( InRound )

	PropHunt.GUI.HUDBar = vgui.Create( "DHudBar" )
	GAMEMODE:AddHUDItem( PropHunt.GUI.HUDBar, 2 )

	local RoundNumber = vgui.Create( "DHudUpdater" );
	RoundNumber:SizeToContents()
	RoundNumber:SetValueFunction( function() return GetGlobalInt( "RoundNumber", 0 ) end )
	RoundNumber:SetLabel( "ROUND" )
	PropHunt.GUI.HUDBar:AddItem( RoundNumber )
			
	local RoundTimer = vgui.Create( "DHudCountdown" );
	RoundTimer:SizeToContents()
	RoundTimer:SetValueFunction( function() 
		if ( GetGlobalFloat( "RoundStartTime", 0 ) > CurTime() ) then return GetGlobalFloat( "RoundStartTime", 0 ) end 
		return GetGlobalFloat( "RoundEndTime" )
	end )
	RoundTimer:SetLabel( "TIME" )
	PropHunt.GUI.HUDBar:AddItem( RoundTimer )

	-- Hunters will be unlocked and unblinded in...
	local blindlock_time_left = (GetConVar("HUNTER_BLINDLOCK_TIME"):GetInt() - (CurTime() - GetGlobalFloat("RoundStartTime", 0))) + 1
	if blindlock_time_left >=1 then
		PropHunt.GUI.ReleaseTimer = vgui.Create( "DHudCountdown" );
		PropHunt.GUI.ReleaseTimer:SizeToContents()
		PropHunt.GUI.ReleaseTimer:SetValueFunction( function()
			local blindlock_time_left = (GetConVar("HUNTER_BLINDLOCK_TIME"):GetInt() - (CurTime() - GetGlobalFloat("RoundStartTime", 0))) + 1
			if blindlock_time_left < 1 && PropHunt.GUI.ReleaseTimer != nil then
				GAMEMODE:AddPlayerAction("Hunters have been released and unblinded.")
				--surface.PlaySound("ui/hint.wav")
				surface.PlaySound("buttons/bell1.wav")
				PropHunt.GUI.HUDBar:RemoveItem(PropHunt.GUI.ReleaseTimer)
				PropHunt.GUI.ReleaseTimer = nil
				PropHunt.GUI.ReleaseTimerB = vgui.Create( "DHudUpdater" );
				PropHunt.GUI.ReleaseTimerB:SizeToContents()
				PropHunt.GUI.ReleaseTimerB:SetValueFunction( function()
					local blindlock_time_left = (GetConVar("HUNTER_BLINDLOCK_TIME"):GetInt() - (CurTime() - GetGlobalFloat("RoundStartTime", 0))) + 1
					if blindlock_time_left < -5 then
						GAMEMODE:RemoveHUDItem( PropHunt.GUI.ReleaseTimerB )
						PropHunt.GUI.ReleaseTimerB = nil
					end
					return "Hunting started"
				end )
				PropHunt.GUI.ReleaseTimerB:SetLabel( "" )
				PropHunt.GUI.HUDBar:AddItem( PropHunt.GUI.ReleaseTimerB )
			else
				return blindlock_time_left + CurTime() - 1
			end
			return nil
		end )
		PropHunt.GUI.ReleaseTimer:SetLabel( "HUNTERS WILL BE RELEASED IN" )
		PropHunt.GUI.HUDBar:AddItem( PropHunt.GUI.ReleaseTimer )
	end
end

// Decides where the player view should be (forces third person for props)
function GM:CalcView(pl, origin, angles, fov)
	local view = {} 
	
	if blind then
		-- Blind method #1
		view.origin = Vector(20000, 0, 0)
		view.angles = Angle(0, 0, 0)
		view.fov = fov

		-- Blind method #2
                surface.SetDrawColor( 0, 0, 0, 255 )
                surface.DrawRect( 0, 0, ScrW(), ScrH() )

		return view
	end
	
 	view.origin = origin 
 	view.angles = angles 
 	view.fov = fov 
 	
 	// Give the active weapon a go at changing the viewmodel position 
	if pl:Team() == PropHunt.TeamIDs.Props && pl:Alive() then
		view.origin = origin + Vector(0, 0, hullz - 60) + (angles:Forward() * -80)
	else
	 	local wep = pl:GetActiveWeapon() 
	 	if wep && wep != NULL then 
	 		local func = wep.GetViewModelPosition 
	 		if func then 
	 			view.vm_origin, view.vm_angles = func(wep, origin*1, angles*1) // Note: *1 to copy the object so the child function can't edit it. 
	 		end
	 		 
	 		local func = wep.CalcView 
	 		if func then 
	 			view.origin, view.angles, view.fov = func(wep, pl, origin*1, angles*1, fov) // Note: *1 to copy the object so the child function can't edit it. 
	 		end 
	 	end
	end
 	
 	return view 
end

function GM:PostDrawViewModel( vm, ply, weapon )

	if ( weapon.UseHands || !weapon:IsScripted() ) then

		local hands = LocalPlayer():GetHands()
		if ( IsValid( hands ) ) then hands:DrawModel() end

	end

end
