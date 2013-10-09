// Create new class
local CLASS = {}

// Some settings for the class
CLASS.DisplayName			= "Hunter"
CLASS.WalkSpeed 			= 250
CLASS.CrouchedWalkSpeed 		= 0.2
CLASS.RunSpeed				= 300
CLASS.DuckSpeed				= 0.2
CLASS.DrawTeamRing			= false
CLASS.JumpPower				= 200
CLASS.DeathSounds			= PropHunt.Sounds.Death.Hunters
CLASS.TauntSounds			= PropHunt.Sounds.Taunt.Hunters
CLASS.Weapons				= {
						"weapon_crowbar", -- Crowbar
						"weapon_frag", -- Frag Grenade
						"bf3p90", -- BF3 P90
						//"kermite_shot_winch1300", -- Winchester 1300 shotgun
						"weapon_shotgun",
						"bf3m1911", -- BF3 M1911 pistol
					  }

// Called by spawn and sets loadout
function CLASS:Loadout(pl)
	-- TODO: Implement options for this

	// Ammunition
	pl:GiveAmmo(64, "Buckshot", false)	-- Shotgun Ammo (also applies for similar weapons)
	pl:GiveAmmo(255, "SMG1", false)		-- SMG Ammo (also applies for similar weapons)
	pl:GiveAmmo(255, "Pistol", false)	-- Pistol Ammo (also applies for similar weapons)

	timer.Simple(2.0, function()

	// Weapons
	for _,w in ipairs(self.Weapons) do
		// Check if weapon is a grenade and grenades are allowed first
		if !string.find(w, "grenade") || !string.find(w, "flash") || !string.find(w, "frag") || GetConVar("WEAPONS_ALLOW_GRENADE"):GetBool() then
			pl:Give(w)
		end
	end
	
	local cl_defaultweapon = pl:GetInfo("cl_defaultweapon") 
 	 
 	if pl:HasWeapon(cl_defaultweapon) then 
 		pl:SelectWeapon(cl_defaultweapon)
 	end

	end)

	pl:ChatPrint("You are now in the Hunters team!")
	pl:ChatPrint("Wait until you're not blind then find all players which hide as props.")

	return true
end

// Called when player spawns with this class
function CLASS:OnSpawn(pl)

	local unlock_time = math.Clamp(GetConVar("HUNTER_BLINDLOCK_TIME"):GetInt() - (CurTime() - GetGlobalFloat("RoundStartTime", 0)), 0, GetConVar("HUNTER_BLINDLOCK_TIME"):GetInt())
	local unlock_timestamp = CurTime() + unlock_time

	pl.func_ac_lock = function()
		if !!pl && pl:IsValid() && pl:Alive() && unlock_timestamp > CurTime() then
			/*pl:Blind(true)
			pl:Lock()*/
			timer.Simple(1, pl.func_ac_lock)
		elseif pl:IsValid() then
			pl:Blind(false)
			pl:UnLock()
			pl:SetCanWalk(true)
			pl:SetWalkSpeed(pl.OriginalWalkSpeed)
			pl.func_ac_lock = nil
			pl.unlock_time_left = nil
			pl.must_blind = false
		end
	end
	
	if unlock_time > 2 then
		pl.OriginalWalkSpeed = pl:GetWalkSpeed()
		pl:SetWalkSpeed(1)
		pl:SetCanWalk(false)

		-- BUG: Some weapon issue might come in if blinded too early
		timer.Simple(0.33, function() pl:Blind(true) end)

		-- BUG: Player won't be teleported back to spawnpoint if locked too early
		timer.Simple(2, function() pl:Lock() end)

		-- FIX: Early player release in next round if round ends before release
		timer.Simple(2, pl.func_ac_lock)
	end

	// Reset taunt time
	pl.last_taunt_time = 0

	// Enable crosshair
	pl:CrosshairEnable() 

end


// Called when a player dies with this class
function CLASS:OnDeath(pl, attacker, dmginfo)
	pl:CreateRagdoll()
	pl:UnLock()
	self:PlayDeathSound(pl)

	// Disable crosshair
	pl:CrosshairDisable()

end

function CLASS:GetRandomDeathSound()
	local DeathSound = nil
	
	while
		(table.Count(self.DeathSounds) > 1 && !DeathSound)
		|| (DeathSound != nil && (DeathSound == self.LastDeathSound))
	do
		DeathSound = table.Random(self.DeathSounds)
	end

	self.LastDeathSound = DeathSound

	return DeathSound
end

function CLASS:PlayDeathSound(pl)
	//pl:StopSound()
	local sound = self:GetRandomDeathSound()
	if sound == nil then return end
	pl:EmitSound(sound, 100)
end

// Register
player_class.Register("Hunter", CLASS)