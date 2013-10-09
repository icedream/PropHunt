// Called when the game needs to check how the round ends
function GM:CheckPlayerDeathRoundEnd()
	if !GAMEMODE.RoundBased || !GAMEMODE:InRound() then 
		return
	end

	local Teams = GAMEMODE:GetTeamAliveCounts()

	if table.Count(Teams) < 1 then
		GAMEMODE:RoundEndWithResult(1001, "Draw, everyone loses!")
	elseif table.Count(Teams) == 1 then
		local teamID = table.GetFirstKey(Teams)
		GAMEMODE:RoundEndWithResult(teamID, team.GetName(teamID).." win!")
	end
end

// Called when player tries to pickup a weapon
function GM:PlayerCanPickupWeapon(pl, ent)
 	if pl:Team() != PropHunt.TeamIDs.Hunters then
		return false
	end
	
	return true
end

// Called when player needs a model
function GM:PlayerSetModel(pl)
	local player_model = "models/Gibs/Antlion_gib_small_3.mdl"
	
	if pl:Team() == PropHunt.TeamIDs.Hunters then
		player_model = PropHunt.HunterModel
	end
	
	GAMEMODE:LogO("Precaching and loading model "..player_model, "GM:PlayerSetModel", pl)
	util.PrecacheModel(player_model)
	pl:SetModel(player_model)
end

// Called when a player tries to use an object
function GM:PlayerUse(pl, ent)
	if !pl:Alive() || pl:Team() == TEAM_SPECTATOR then return false end
	if pl:Team() == PropHunt.TeamIDs.Props && pl:IsOnGround() && !pl:Crouching() && table.HasValue(PropHunt.UsablePropEntities, ent:GetClass()) && ent:GetModel() then
		if table.HasValue(PropHunt.BannedPropModels, ent:GetModel()) then
			if pl.lastBannedPropModel != ent:GetModel() || pl.lastBannedPropTime == nil || pl.lastBannedPropTime + 2 < CurTime() then
				pl.lastBannedPropTime = CurTime()
				pl.lastBannedPropModel = ent:GetModel()
				umsg.Start("PlayerUseBannedProp", pl)
				umsg.End()
			end
		elseif ent:GetPhysicsObject():IsValid() && pl.ph_prop:GetModel() != ent:GetModel() then
			local ent_health = math.Clamp(ent:GetPhysicsObject():GetVolume() / 250, 1, 200)
			local new_health = math.Clamp((pl.ph_prop.health / pl.ph_prop.max_health) * ent_health, 1, 200)
			local per = pl.ph_prop.health / pl.ph_prop.max_health
			pl.ph_prop.health = new_health
			
			pl.ph_prop.max_health = ent_health
			pl.ph_prop:SetModel(ent:GetModel())
			pl.ph_prop:SetSkin(ent:GetSkin())
			pl.ph_prop:SetSolid(SOLID_BSP) -- TODO: What would happen if we remove this??
			pl.ph_prop:SetPos(pl:GetPos() - Vector(0, 0, ent:OBBMins().z - 1))
			pl.ph_prop:SetAngles(pl:GetAngles())
			
			local hullxymax = math.Round(math.Max(ent:OBBMaxs().x, ent:OBBMaxs().y))
			local hullxymin = hullxymax * -1
			local hullz = math.Round(ent:OBBMaxs().z)
			
			pl:SetHull(Vector(hullxymin, hullxymin, 0), Vector(hullxymax, hullxymax, hullz))
			pl:SetHullDuck(Vector(hullxymin, hullxymin, 0), Vector(hullxymax, hullxymax, hullz))
			pl:SetHealth(new_health)
			
			umsg.Start("SetHull", pl)
			umsg.Long(hullxymax)
			umsg.Long(hullz)
			umsg.Short(new_health)
			umsg.End()
		end
	end
	
	// Prevent the door exploit
	if table.HasValue(PropHunt.ExploitableDoors, ent:GetClass()) && pl.last_door_time && pl.last_door_time + 1 > CurTime() then
		return false
	end
	
	pl.last_door_time = CurTime()
	return true
end

// Called when player presses [F3]. Plays a taunt for their team
function GM:ShowSpare1(pl)
	if
		GAMEMODE:InRound()
		&& pl:Alive()
		&& pl.last_taunt_time + PropHunt.TauntDelay <= CurTime()
	then
		local t = pl:GetPlayerClass()

		if t != nil then
			local sounds = t.TauntSounds
			if sounds != nil then
				local rand_taunt = nil

				while
					(rand_taunt == nil && table.Count(sounds) > 0)
					|| (rand_taunt != nil && table.Count(sounds) > 1 && rand_taunt == pl.last_taunt)
				do
					rand_taunt = table.Random(sounds)
				end

				t.LastTauntSound = rand_taunt

				pl.last_taunt_time = CurTime()
				pl.last_taunt = rand_taunt

				if rand_taunt != nil then
					GAMEMODE:LogO("Playing taunt sound "..rand_taunt, "GM:ShowSpare1", pl)
					if pl:Team() == PropHunt.TeamIDs.Hunters then
						pl:EmitSound(rand_taunt, 100)
					else
						pl:EmitPropSound(rand_taunt, 100)
					end
				end
			else
				GAMEMODE:LogO("Can't play taunt sound, empty sounds array for team", "GM:ShowSpare1", pl)
			end
		else
			GAMEMODE:LogO("Can't play taunt sound, invalid team", "GM:ShowSpare1", pl)
		end
	end

end


// This is called when the round time ends (props win)
function GM:RoundTimerEnd()
	if !GAMEMODE:InRound() then
		return
	end
   
	GAMEMODE:RoundEndWithResult(PropHunt.TeamIDs.Props, team.GetName(PropHunt.TeamIDs.Props) .. " have survived and win!")
end

// Called before start of round
function GM:OnPreRoundStart(num)
	GAMEMODE:Log("Cleaning up map...")
	game.CleanUpMap()

	--if (PropHunt.RoundTeamBalancing) then GAMEMODE:CheckTeamBalance() end

	for _, pl in pairs(player.GetAll()) do
		if pl:Team() == PropHunt.TeamIDs.Props || pl:Team() == PropHunt.TeamIDs.Hunters then
			// Switch teams if needed
			if GetGlobalInt("RoundNumber") != 1
			&& (PropHunt.SwapTeamsEveryRound
			|| ((team.GetScore(PropHunt.TeamIDs.Props) + team.GetScore(PropHunt.TeamIDs.Hunters)) > 0 || PropHunt.SwapTeamsPointsZero))
			then
				pl:ChatPrint("Teams have been swapped!")
				if pl:Team() == PropHunt.TeamIDs.Props then
					pl:SetTeam(PropHunt.TeamIDs.Hunters)
				else
					pl:SetTeam(PropHunt.TeamIDs.Props)
				end
			end
		end
	end

	GAMEMODE:Log("Preparing players...")

	UTIL_StripAllPlayers()
	UTIL_SpawnAllPlayers()
	UTIL_FreezeAllPlayers()


	GAMEMODE:Log("OnPreRoundStart done.")

end

function GM:Initialize()

	util.AddNetworkString("PlayableGamemodes")
	
	// If we're round based, wait 45 seconds before the first round starts
	if GAMEMODE.RoundBased then
		timer.Simple(PropHunt.PreStartTime, function() GAMEMODE:StartRoundBasedGameIfPlayersAvailable() end)
	end
	
end

function GM:StartRoundBasedGameIfPlayersAvailable()
	for _, ply in ipairs(player.GetAll()) do
		if(ply:Team() == PropHunt.TeamIDs.Hunters
		|| ply:Team() == PropHunt.TeamIDs.Props)
		then
			GAMEMODE:StartRoundBasedGame()
			return
		end
	end
	timer.Simple(5, function() GAMEMODE:StartRoundBasedGameIfPlayersAvailable() end)
end

function GM:Think()

	self.BaseClass:Think()

	// Unlimited ammo for all weapons EXCEPT grenades
	for _, ply in ipairs( player.GetAll() ) do
		if ( ply:Alive() and ply:GetActiveWeapon() != NULL ) then

			local wep = ply:GetActiveWeapon()

			// Refill weapons
			if PropHunt.UnlimitedAmmo && !!wep && wep:IsWeapon() then
				if PropHunt.UnlimitedGrenades || (!string.find(wep:GetClass(), "grenade") && !string.find(wep:GetClass(), "flash") && !string.find(wep:GetClass(), "frag")) then
					ply:GiveAmmo(9999, wep:GetPrimaryAmmoType(), false)
				end
			end
			if PropHunt.UnlimitedGrenades && !!wep && wep:IsWeapon() then
				if string.find(wep:GetClass(), "grenade") || string.find(wep:GetClass(), "flash") || string.find(wep:GetClass(), "frag") then
					ply:GiveAmmo(9999, wep:GetPrimaryAmmoType(), false)
				end

				ply:GiveAmmo(9999, wep:GetSecondaryAmmoType(), false)
			end


                end
        end
end