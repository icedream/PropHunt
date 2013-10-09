AddCSLuaFile() // shared file

// Finds the player meta table or terminates
local PlayerExt = FindMetaTable("Player")
if !PlayerExt then return end

// Blinds the player by setting view out into the void
function PlayerExt:Blind(bool)
	-- Is this even a valid player?
	if !self:IsValid() then
		GAMEMODE:LogO("Can't blind player, not a valid player", "PlayerExt:Blind", self)
		return
	end
	
	if SERVER then
		umsg.Start("SetBlind", self)
		if bool then
			GAMEMODE:LogO("Sending request to blind player", "PlayerExt:Blind", self)
			umsg.Bool(true)
		else
			GAMEMODE:LogO("Sending request to unblind player", "PlayerExt:Blind", self)
			umsg.Bool(false)
		end
		umsg.End()
	else
		if bool then
			GAMEMODE:LogO("Received request to blind player", "PlayerExt:Blind", self)
			blind = true
		else
			GAMEMODE:LogO("Received request to unblind player", "PlayerExt:Blind", self)
			blind = false
		end
	end
end

// Remove the child prop
function PlayerExt:RemoveProp()
	-- Are we server-side?
	if CLIENT then return end

	-- Is this even a valid player?
	if !self:IsValid() then
		GAMEMODE:LogO("Can't remove child prop, not a valid player", "PlayerExt:EmitPropSound", self)
		return
	end

	if !self.ph_prop || !self.ph_prop:IsValid() then
		GAMEMODE:LogO("Can't remove child prop, no valid child prop", "PlayerExt:RemoveProp", self)
		return
	end
	
	-- Try to cut the sound by moving the prop outside the map
	self.ph_prop:SetOwner(nil)
	self.ph_prop:SetParent(nil)

	GAMEMODE:LogO("Moving child prop outside map", "PlayerExt:RemoveProp", self)
	self.ph_prop:SetPos(Vector(999, 999, 999))

	GAMEMODE:LogO("Removing child prop", "PlayerExt:RemoveProp", self)
	self.ph_prop:Remove()
	self.ph_prop = nil
end

// Play a sound on the child prop
function PlayerExt:EmitPropSound(sound)
	-- Are we server-side?
	if CLIENT then return end

	-- Is this even a valid player?
	if !self:IsValid() then
		GAMEMODE:LogO("Can't play sound, not a valid player", "PlayerExt:EmitPropSound", self)
		return
	end

	if !self.ph_prop || !self.ph_prop:IsValid() then
		GAMEMODE:LogO("Can't play sound, no valid child prop", "PlayerExt:EmitPropSound", self)
		return
	end

	GAMEMODE:LogO("Playing sound "..sound, "PlayerExt:EmitPropSound", self)
	self.ph_prop:EmitSound(sound)
end
