function GM:Think()
	self.BaseClass:Think()

	for _, ply in ipairs( player.GetAll() ) do
		if ( ply:Alive() and ply:GetActiveWeapon() != NULL ) then
			local wep = ply:GetActiveWeapon()
			// Filter
			if PropHunt.UnlimitedAmmo && !!wep && wep:IsWeapon() then
				if PropHunt.UnlimitedGrenades || (!string.find(wep:GetClass(), "grenade") && !string.find(wep:GetClass(), "flash") && !string.find(wep:GetClass(), "frag")) then
					ply:GiveAmmo(9999, wep:GetPrimaryAmmoType(), false)
				end
			end
			if PropHunt.UnlimitedGrenades && !!wep && wep:IsWeapon() then
				if string.find(wep:GetClass(), "grenade") || string.find(wep:GetClass(), "flash") || string.find(wep:GetClass(), "frag") then
					ply:GiveAmmo(9999, wep:GetPrimaryAmmoType(), false)
				end
				ply:GiveAmmo(9999, wep:GetSecondaryAmmoType(), false)
			end
		end
	end
end