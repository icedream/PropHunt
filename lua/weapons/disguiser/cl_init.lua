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

usermessage.Hook("cantDisguiseAsBannedProp", function(um)
	surface.PlaySound("resource/warning.wav")
	chat.AddText(Color(255, 0, 0), "You can not use this prop, it has been banned by the server.")
end)

usermessage.Hook("resetHull", function(um)
	// message input
	local player = um:ReadEntity()
	
	// actually reset the hull
	player:ResetHull()
end)

usermessage.Hook("setBounding", function(um)
	// message input
	local player = um:ReadEntity()
	local obbmins = um:ReadVector()
	local obbmaxs = um:ReadVector()

	// hull from given vectors
	player:SetHull(obbmins, obbmaxs)
	player:SetHullDuck(obbmins, obbmaxs) -- ducking shouldn't work for props
end)

usermessage.Hook("setRenderOrigin", function(um)
	// TODO: This should reposition the player so the model is fully above the surface.
	// For some reason this does not work or is being ignored.
	
	// message input
	local player = um:ReadEntity()
	local renderOriginMin = um:ReadVector()
	local renderOriginMax = um:ReadVector()
	
	// debug message
	player:ChatPrint("RenderOrigin: " .. renderOriginMin.x .. "|" .. renderOriginMin.y .. "|" .. renderOriginMin.z)
	
	// reposition the player
	player:SetRenderOrigin(renderOriginMin, renderOriginMax)
	player:DrawModel()
end)

hook.Add("CalcView", "Disguiser.ThirdPersonCalcView", function(player, pos, angles, fov)
	local smooth = 1
	local smoothscale = 0.5
	
	if player:GetNetworkedBool("thirdperson") then
		angles = player:GetAimVector():Angle()

		local targetpos = Vector(0, 0, 60)
		if player:KeyDown(IN_DUCK) then
			if player:GetVelocity():Length() > 0 then
				targetpos.z = 50
		 	else
				targetpos.z = 40
			end
		end

		player:SetAngles(angles)
		
		local targetfov = fov
		if player:GetVelocity():DotProduct(player:GetForward()) > 10 then
			if player:KeyDown(IN_SPEED) then
				targetpos = targetpos + player:GetForward() * -10
			else
				targetpos = targetpos + player:GetForward() * -5
			end
		end 

		// tween to the target position
		pos = targetpos
		if smooth != 0 then
			pos.x = math.Approach(pos.x, targetpos.x, math.abs(targetpos.x - pos.x) * smoothscale)
			pos.y = math.Approach(pos.y, targetpos.y, math.abs(targetpos.y - pos.y) * smoothscale)
			pos.z = math.Approach(pos.z, targetpos.z, math.abs(targetpos.z - pos.z) * smoothscale)
		else
			pos = targetpos
		end

		// offset it by the stored amounts, but trace so it stays outside walls
		// we don't tween this so the camera feels like its tightly following the mouse
		local offset = Vector(5, 5, 5)
		if true then // chasecam_zoom
			offset.x = 70 // back
			offset.y = 0 // right
			offset.z = 0 // up
		end
		local t = {}
		t.start = player:GetPos() + pos
		t.endpos = t.start + angles:Forward() * -offset.x
		t.endpos = t.endpos + angles:Right() * offset.y
		t.endpos = t.endpos + angles:Up() * offset.z
		t.filter = player
		/*if player:GetScriptedVehicle():IsValid() then
			pos = t.endpos
		else*/
			local tr = util.TraceLine(t)
			pos = tr.HitPos
			if tr.Fraction < 1.0 then
				pos = pos + tr.HitNormal * 3
			end
		//end

		// tween the fov
		fov = targetfov
		if smooth != 0 then
			fov = math.Approach(fov, targetfov, math.abs(targetfov - fov) * smoothscale)
		else
			fov = targetfov
		end
		return GAMEMODE:CalcView(player, pos, angles, fov)
	end
end)

hook.Add("HUDPaint", "Disguiser.ThirdPersonHUDPaint", function()
	local player = LocalPlayer()
	if !player:GetNetworkedBool("thirdperson") then
		return
	end

	// trace from muzzle to hit pos
	local t = {}
	t.start = player:GetShootPos()
	t.endpos = t.start + player:GetAimVector() * 9000
	t.filter = player
	local tr = util.TraceLine(t)
	local pos = tr.HitPos:ToScreen()
	local fraction = math.min((tr.HitPos - t.start):Length(), 1024) / 1024
	local size = 10 + 20 * (1.0 - fraction)
	local offset = size * 0.5
	local offset2 = offset - (size * 0.1)

	// trace from camera to hit pos, if blocked, red crosshair
	t = {}
	t.start = player:GetPos()
	t.endpos = tr.HitPos + tr.HitNormal * 5
	t.filter = player
	local tr = util.TraceLine(t)
	if tr.Fraction != 1.0 then
		surface.SetDrawColor(255, 48, 0, 255)
	else
		surface.SetDrawColor(255, 208, 64, 255)
	end
	surface.DrawLine(pos.x - offset, pos.y, pos.x - offset2, pos.y)
	surface.DrawLine(pos.x + offset, pos.y, pos.x + offset2, pos.y)
	surface.DrawLine(pos.x, pos.y - offset, pos.x, pos.y - offset2)
	surface.DrawLine(pos.x, pos.y + offset, pos.x, pos.y + offset2)
	surface.DrawLine(pos.x - 1, pos.y, pos.x + 1, pos.y)
	surface.DrawLine(pos.x, pos.y - 1, pos.x, pos.y + 1)
end)

hook.Add("HUDShouldDraw", "Disguiser.ThirdPersonHUDShouldDraw", function(name)
	if name == "CHudCrosshair" and LocalPlayer():GetNetworkedInt("thirdperson") == 1 then
		return false
	end
end)