function GM:PlayerCanPickupWeapon(pl, ent)
 	return pl:TeamData().CanPickupWeapon or pl:Team() == PH_TEAM_HUNTER or false
end

function GM:PlayerDeath(victim, inflictor, killer)
 	victim:EmitPoolSound("Death")
end

function GM:PlayerUse(pl, ent)
	if !IsValid(pl) || !pl:Alive() || pl:Team() == TEAM_SPECTATOR then return false end

	if pl:Team() == PH_TEAM_PROP then
		// Use disguiser weapon instead
		local weapon = pl:GetWeapon("disguiser")
		weapon:CallOnClient("PrimaryAttack", nil)
	end
	
	return true
end

function GM:PlayerJoinTeam(pl, teamID)
	if teamID == TEAM_SPECTATOR then
		return true
	end
	return self.Base:PlayerJoinTeam(pl, teamID)
end

function GM:PlayerSetModel(pl)
	local player_model = PropHunt.Teams[pl:Team()].Model
	
	GAMEMODE:LogO("Precaching and loading model "..player_model, "GM:PlayerSetModel", pl)
	util.PrecacheModel(player_model)
	pl:SetModel(player_model)
end

function GM:PlayerSilentDeath(pl)
	// Notify all clients
	umsg.Start("PlayerPropSuicide") 
	umsg.Entity(pl)
	umsg.End()
	
	// Ragdoll
	pl:CreateRagdoll()
	pl:UnLock()
	
	// Sound
	pl:EmitPoolSound("Death")
	
	return self.BaseClass:PlayerSilentDeath(pl)
end

function GM:ShowSpare1(pl)
	if !IsValid(pl) || !pl:Alive() then return false end
	
	pl:EmitPoolSound("Taunt")
end

function GM:ShowSpare2(pl)
	// TODO: Team switch menu here
end