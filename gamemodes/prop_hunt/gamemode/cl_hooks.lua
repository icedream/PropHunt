// Called immediately after starting the gamemode 
hook.Add("Initialize", "PH_Initialize", function() hullz = 80 end)

// Called for blindness
hook.Add("HUDPaint", "PH_Blindness", function()
	-- Blind method #2, this fixes the glitches due to looking at void
	if LocalPlayer():GetNWBool("blind", false) && !PropHunt.IWantGlitchyBlindness then
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