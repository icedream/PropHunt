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
		local blindlock_time_left = (PropHunt.CVars.HunterBlindLockTime:GetInt() - (CurTime() - GetGlobalFloat("RoundStartTime", 0))) + 1
		if blindlock_time_left >=1 then
			PropHunt.GUI.ReleaseTimer = vgui.Create( "DHudCountdown" );
			PropHunt.GUI.ReleaseTimer:SizeToContents()
			PropHunt.GUI.ReleaseTimer:SetValueFunction( function()
				local blindlock_time_left = (PropHunt.CVars.HunterBlindLockTime:GetInt() - (CurTime() - GetGlobalFloat("RoundStartTime", 0))) + 1
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
	local blindlock_time_left = (PropHunt.CVars.HunterBlindLockTime:GetInt() - (CurTime() - GetGlobalFloat("RoundStartTime", 0))) + 1
	if blindlock_time_left >=1 then
		PropHunt.GUI.ReleaseTimer = vgui.Create( "DHudCountdown" );
		PropHunt.GUI.ReleaseTimer:SizeToContents()
		PropHunt.GUI.ReleaseTimer:SetValueFunction( function()
			local blindlock_time_left = (PropHunt.CVars.HunterBlindLockTime:GetInt() - (CurTime() - GetGlobalFloat("RoundStartTime", 0))) + 1
			if blindlock_time_left < 1 && PropHunt.GUI.ReleaseTimer != nil then
				GAMEMODE:AddPlayerAction("Hunters have been released and unblinded.")
				--surface.PlaySound("ui/hint.wav")
				surface.PlaySound("buttons/bell1.wav")
				PropHunt.GUI.HUDBar:RemoveItem(PropHunt.GUI.ReleaseTimer)
				PropHunt.GUI.ReleaseTimer = nil
				PropHunt.GUI.ReleaseTimerB = vgui.Create( "DHudUpdater" );
				PropHunt.GUI.ReleaseTimerB:SizeToContents()
				PropHunt.GUI.ReleaseTimerB:SetValueFunction( function()
					local blindlock_time_left = (PropHunt.CVars.HunterBlindLockTime:GetInt() - (CurTime() - GetGlobalFloat("RoundStartTime", 0))) + 1
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
