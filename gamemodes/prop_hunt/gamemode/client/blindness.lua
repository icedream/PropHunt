// Called for blindness
hook.Add("HUDPaint", "PH_Blindness", function()
	-- Blind method #2, this fixes the glitches due to looking at void
	if LocalPlayer():GetNWBool("blind", false) && !PropHunt.IWantGlitchyBlindness then
		surface.SetDrawColor( 0, 0, 0, 255 )
		surface.DrawRect( 0, 0, ScrW(), ScrH() )
	end
end)