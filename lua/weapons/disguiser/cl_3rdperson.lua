hook.Add("CalcView", "Disguiser.ThirdPersonCalcView", function(player, pos, angles, fov)
	local smoothscale = 1
	
	if player:GetNetworkedBool("thirdperson") then
		angles = player:GetAimVector():Angle()

		local targetpos = Vector(0, 0, player:OBBMaxs().z)
		if player:KeyDown(IN_DUCK) then
			if player:GetVelocity():Length() > 0 then
				targetpos.z = targetpos.z / 1.33
		 	else
				targetpos.z = targetpos.z / 2
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
		
		// Smoothing - approaches a bit more slowly to the actual target position
		pos = targetpos
		pos = Vector(
			math.Approach(pos.x, targetpos.x, math.abs(targetpos.x - pos.x) * smoothscale),
			math.Approach(pos.y, targetpos.y, math.abs(targetpos.y - pos.y) * smoothscale),
			math.Approach(pos.z, targetpos.z, math.abs(targetpos.z - pos.z) * smoothscale)
		)
		
		// offset it by the stored amounts, but trace so it stays outside walls
		// we don't smooth this so the camera feels like its tightly following the mouse
		local offset = Vector(50 + (player:OBBMaxs().z - player:OBBMins().z), 0, 10)
		local t = {
			start = player:GetPos() + pos,
			endpos = (player:GetPos() + pos)
				+ (angles:Forward() * -offset.x)
				+ (angles:Right() * offset.y)
				+ (angles:Up() * offset.z),
			filter = player
		}
		if player:GetVehicle():IsValid() then
			pos = t.endpos
		else
			local tr = util.TraceLine(t)
			pos = tr.HitPos
			if tr.Fraction < 1.0 then
				pos = pos + tr.HitNormal
			end
		end

		// Smoothing FOV change
		fov = targetfov
		fov = math.Approach(fov, targetfov, math.abs(targetfov - fov) * smoothscale)
		
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
	local hit = tr.HitNonWorld

	// trace from camera to hit pos, if blocked, red crosshair
	local tr = util.TraceLine({
		start = player:GetPos(),
		endpos = tr.HitPos + tr.HitNormal * 5,
		filter = player,
		mask = MASK_SHOT
	})
	surface.SetDrawColor(255, 255, 255, 255)
	if (hit) then
		surface.SetDrawColor(0, 192, 24, 255)
	end
	/*
	if tr.Fraction != 1.0 then
		// Far
		surface.SetDrawColor(255, 255, 255, 255)
	else
		// Near
		surface.SetDrawColor(255, 208, 64, 255)
	end
	*/
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