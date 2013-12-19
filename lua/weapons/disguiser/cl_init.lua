// Weapon info for client
SWEP.PrintName = "Disguiser"
SWEP.Slot = 0
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.WepSelectIcon = surface.GetTextureID("vgui/gmod_tool" )
SWEP.Gradient = surface.GetTextureID("gui/gradient" )
SWEP.InfoIcon = surface.GetTextureID("gui/info")

// DEBUG DEBUG DEBUG
print("[Disguiser] Loading clientside...")

// Shared stuff
include("sh_init.lua")

local BannedPropError_Entity = nil
local BannedPropError_Time = 5
local function BannedPropError()
	AddWorldTip(
		BannedPropError_Entity:EntIndex(),
		"You can not use this prop, it has been banned by the server.",
		0.02,
		BannedPropError_Entity:GetPos(),
		BannedPropError_Entity)
	if BannedPropError_Time < 5 then
		BannedPropError_Time = BannedPropError_Time + 0.02
		timer.Simple(0.02, BannedPropError)
	end
end

usermessage.Hook("cantDisguiseAsBannedProp", function(um)
	local entity = um:ReadEntity()
	surface.PlaySound("resource/warning.wav")
	
	// Fallback to raw print if we can't have our beloved sandbox AddWorldTip
	if !!AddWorldTip then
		// I hate how AddWorldTip hardcodes the worldtip time to 0.05 seconds.
		// Let's make a timer to avoid additional graphic hooks.
		BannedPropError_Entity = entity
		if (BannedPropError_Time or 5) >= 5 then
			BannedPropError_Time = 0
			BannedPropError()
		end
		BannedPropError_Time = 0
	else
		chat.AddText(Color(255, 0, 0), "You can not use this prop, it has been banned by the server.")
	end
end)

include("cl_3rdperson.lua")
include("cl_obb.lua")