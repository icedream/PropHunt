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