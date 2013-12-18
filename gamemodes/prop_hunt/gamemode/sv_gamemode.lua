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
 	return pl:Team() == PropHunt.TeamIDs.Hunters
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
	if pl:Team() == PropHunt.TeamIDs.Props then
		// Use disguiser weapon instead
		local weapon = pl:GetWeapon()
		for k, bannedProp in PropHunt.BannedPropModels do
			if !weapon:HasPropConfig(bannedProp) then
				weapon.PropConfiguration[bannedProp] = { Banned = true }
			else
				weapon.PropConfiguration[bannedProp].Banned = true
			end
		end
		weapon:CallOnClient("PrimaryAttack", nil)
	end
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
					pl:EmitSound(rand_taunt, 100)
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

	UTIL_StripAllPlayers()

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

	UTIL_SpawnAllPlayers()
	UTIL_FreezeAllPlayers()


	GAMEMODE:Log("OnPreRoundStart done.")

end

function GM:Initialize()

	util.AddNetworkString("PlayableGamemodes")
	
	// If we're round based, wait at least 45 seconds before the first round starts
	if GAMEMODE.RoundBased then
		timer.Simple(PropHunt.PreStartTime, function() GAMEMODE:StartRoundBasedGameIfPlayersAvailable() end)
	end
	
end

function GM:StartRoundBasedGameIfPlayersAvailable()
	local hasHunter = false
	local hasProp = false
	local allowOneSided = PropHunt.CVars.AllowOneSided:GetBool()
	for _, ply in ipairs(player.GetAll()) do
		if ply:Team() == PropHunt.TeamIDs.Hunters then hasHunter = true end
		if ply:Team() == PropHunt.TeamIDs.Props then hasProp = true end
		if (!allowOneSided && hasHunter && hasProp) || (allowOneSided && (hasHunter || hasProp)) then GAMEMODE:StartRoundBasedGame() return end
	end
	timer.Simple(5, function() GAMEMODE:StartRoundBasedGameIfPlayersAvailable() end)
end

function GM:Think()

	self.BaseClass:Think()

	// Unlimited ammo
	for _, ply in ipairs( player.GetAll() ) do
		if ( ply:Alive() and ply:GetActiveWeapon() != NULL ) then
			local wep = ply:GetActiveWeapon()
			// Filter
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