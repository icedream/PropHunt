
function GM:CalcView(pl, origin, angles, fov)
	local view = {} 
	
	if LocalPlayer():GetNWBool("blind", false) then
		-- Adds to blindness by turning off nearby sound.
		-- Yes, this is a very weird hack.
		view.origin = Vector(20000, 0, 0)
		view.angles = Angle(0, 0, 0)
		view.fov = fov
		
		return view
	end
	
 	view.origin = origin 
 	view.angles = angles 
 	view.fov = fov
	
 	// Weapon view change hack
	local wep = pl:GetActiveWeapon() 
	if wep && wep != NULL then 
		local func = wep.GetViewModelPosition 
		if func then 
			view.vm_origin, view.vm_angles = func(wep, origin*1, angles*1) // Note: *1 to copy the object so the child function can't edit it. 
		end
		 
		local func = wep.CalcView 
		if func then 
			view.origin, view.angles, view.fov = func(wep, pl, origin*1, angles*1, fov) // Note: *1 to copy the object so the child function can't edit it. 
		end 
	end
 	
 	return view 
end

function GM:PostDrawViewModel( vm, ply, weapon )
	if ( weapon.UseHands || !weapon:IsScripted() ) then
		local hands = LocalPlayer():GetHands()
		if ( IsValid( hands ) ) then hands:DrawModel() end
	end
end
