// Finds the player meta table or terminates
local PlayerExt = FindMetaTable("Player")
if !PlayerExt then return end

// Make the player play a preconfigured sound (see ../shared/config.lua)
function PlayerExt:EmitPoolSound(identifier)
	-- Is this even a valid player?
	if !IsValid(self) then return false end
	
	// Do we have sounds?
	if !self:TeamData().Sounds
		|| !self:TeamData().Sounds[identifier]
		|| #self:TeamData().Sounds[identifier] <= 0
	then
		return false
	end
	
	-- Too lazy to reimplement the anti-repeat algorithm here
	self:EmitSound(self:TeamData().Sounds[identifier], 100)
end

// Blindfold the player
function PlayerExt:Halt(time, blind)
	-- Is this even a valid player?
	if !IsValid(self) then return false end
	
	-- Time valid?
	if time <= 0 then return false end
	
	self.unlock_timestamp = CurTime() + time
	
	-- Our lock function for this player
	pl.func_ac_lock = function()
		pl = pl or self -- I have no idea.
		
		-- Valid player?
		if !IsValid(pl) || !pl:Alive() then return end
		
		-- Time expired yet?
		if pl.unlock_timestamp > CurTime() then
			-- Don't unhalt, time did not expire yet
			timer.Simple(1, pl.func_ac_lock)
		else
			-- Unhalt
			pl:Blind(false)
			pl:UnLock()
			pl:SetCanWalk(true)
			pl:SetWalkSpeed(pl.OriginalWalkSpeed)
			pl.func_ac_lock = nil
        end
        
		-- Some stuff we should do right at the beginning if it's affordable
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
	end
end

// Blinds the player
function PlayerExt:Blind(bool)
	-- Is this even a valid player?
	if !IsValid(self) then return false end
	
	self:SetNWBool("blind", bool)
	return true
end

// Get the team data
function PlayerExt:TeamData()
	-- Is this even a valid player?
	if !IsValid(self) then return false end
	
	-- Do we have a team table?
	local teamTable = PropHunt.Teams[self:Team()]
	if !teamTable then return {} end
	
	return teamTable
end

// Load out the player
function PlayerExt:Loadout()
	-- Is this even a valid player?
	if !IsValid(self) then return false end
	
	-- Default the crosshair to be enabled
	self:EnableCrosshair()
	
	local teamTable = self:TeamData()
	
	-- Do we have weapons?
	if !!teamTable.Weapons && #teamTable.Weapons > 0 then
		for _, weaponID in pairs(teamTable.Weapons) do
			GAMEMODE:LogO("Giving weapon: " .. weaponID, "PlayerExt:Loadout", self)
			self:Give(weaponID)
		end
		
		-- Ammunition
		if teamTable.UnlimitedAmmo then
			teamTable.Ammunition = {
				Buckshot = 64,
				SMG1 = 255,
				Pistol = 255
			}
		end
		for ammoType, ammoCount in pairs(teamTable.Ammunition) do
			GAMEMODE:LogO("Giving ammo: " .. ammoType .. " x " .. ammoCount, "PlayerExt:Loadout", self)
			self:GiveAmmo(ammoCount, ammoType, false /* don't show notification, for some reason ignored anyways */)
		end
	
		-- Default weapon
		local defaultWeapon = self:GetInfo("cl_defaultweapon")
		if self:HasWeapon(defaultWeapon) then
			self:SelectWeapon(defaultWeapon)
		end
	end
	
	return true
end

// Forcetaunt
function PlayerExt:ForceTaunt(intervalNormal, intervalCamping, firstDelay)
	// Player valid?
	if !IsValid(self) then return false end

	GAMEMODE:LogO("Enabling forcetaunt on player...", "PlayerExt:EnableForceTaunt", self)

	// normal interval must be given and valid if force taunt is to be activated
	if intervalNormal <= 0 then return end
	
	// default values to existing ones
	if intervalCamping <= 0 then intervalCamping = intervalNormal end
	if firstDelay < 0 then firstDelay = 0 end
	
	// reset player taunt timestamp
	self.forcetaunt_int = intervalNormal
	self.forcetaunt_int_camping = intervalCamping
	self.last_taunt_time = CurTime()
	self.last_taunt = nil
	self.last_moving_time = CurTime()
	self.last_moving_pos = self:GetPos()
	self.first_forcetaunt_run = CurTime() + firstDelay
		+ math.random(0, intervalNormal) // fuzzing, it's boring and loud and too mechanical otherwise
	self.func_forcetaunt = function()
		// Check if player is fine
		if !IsValid(self) || !self:Alive() then return end
		
		// Did the player move?
		if self.last_moving_pos:Distance(self:GetPos()) > 130 then
			self.last_moving_pos = self:GetPos()
			self.last_moving_time = CurTime()
		end
		
		// Is the player camping?
		local isCamping = CurTime() - (self.last_moving_time or CurTime()) > 5
		local last_taunt_timespan = CurTime() - (pl.last_taunt_time or 0)
		local first_forcetaunt_pass = CurTime() > (pl.first_forcetaunt_run or 0)
		if first_forcetaunt_pass then
			if (isCamping && (last_taunt_timespan > self.forcetaunt_int_camping or 0))
				|| (!isCamping && (last_taunt_timespan > self.forcetaunt_int or 0))
			then
				GAMEMODE:ShowSpare1(self) -- simulate pressing the spare 1 key
				GAMEMODE:LogO("Forcetaunt triggered", "self.func_forcetaunt", self)
			end
		end
		
		timer.Simple(1, self.func_forcetaunt)
	end
	
	timer.Simple(1, self.func_forcetaunt) -- kick off
end

// Prepare the player
function PlayerExt:BeforeSpawn()
	// Player valid?
	if !IsValid(self) then return false end

	GAMEMODE:LogO("Preparing player...", "PlayerExt:Prepare", self)

	local teamData = self:TeamData()
	
	self:Loadout()
	
	if !!teamData.ForceTaunt then
		self:Forcetaunt(
			teamData.ForceTauntInterval,
			teamData.ForceTauntInterval * teamData.ForceTauntCampingMultiply,
			teamData.ForceTauntAfter)
	end
	
	if !!teamData.SpawnDelay then
		self:Halt(
			teamData.SpawnDelay,
			teamData.SpawnDelayBlindness)
	end
end