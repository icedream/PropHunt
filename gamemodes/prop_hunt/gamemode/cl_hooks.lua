// Called immediately after starting the gamemode 
hook.Add("Initialize", "PH_Initialize", function() hullz = 80 end)

// Called for blindness
hook.Add("HUDPaint", "PH_Blindness", function()
	-- Blind method #2, this fixes the glitches due to looking at void
	if LocalPlayer():GetNWBool("blind", false) then
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawRect( 0, 0, ScrW(), ScrH() )
	end
end)

// Shows that a player has killed too many props
usermessage.Hook("PlayerPropSuicide", function(um)
	local pl = um:ReadEntity()
	if !pl then
		GAMEMODE:AddPlayerAction("A hunter died for all the innocent props they hurt")
		return
	end
	GAMEMODE:AddPlayerAction(pl, "died for all the innocent props they hurt")
end)

// Shows when a player tries to use a banned prop
usermessage.Hook("PlayerUseBannedProp", function(um)
	surface.PlaySound("resource/warning.wav")
	chat.AddText(Color(255,0,0),"You can not use this prop, it has been banned by the server.")
end)

// Resets the player hull
usermessage.Hook("ResetHull", function(um)
	if LocalPlayer() && LocalPlayer():IsValid() then
		LocalPlayer():ResetHull()
		hullz = 80
	end
end)

// Sets the player hull
usermessage.Hook("SetHull", function(um)
	hullxy = um:ReadLong()
	hullz = um:ReadLong()
	new_health = um:ReadLong()
	
	LocalPlayer():SetHull(Vector(hullxy * -1, hullxy * -1, 0), Vector(hullxy, hullxy, hullz))
	LocalPlayer():SetHullDuck(Vector(hullxy * -1, hullxy * -1, 0), Vector(hullxy, hullxy, hullz))
	LocalPlayer():SetHealth(new_health)
end)
