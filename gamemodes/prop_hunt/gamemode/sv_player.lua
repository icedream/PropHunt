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
	
	self:SetNWBool("blind", bool)
end

// Remove the child prop
function PlayerExt:RemoveProp()
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
	self.ph_prop:EmitSound(sound, 150)
end
