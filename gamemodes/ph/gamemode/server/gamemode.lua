function GM:AllowPlayerPickup(ply, entity)
	return false
end

function GM:CreateTeams()
	team.SetUp(
		1,
		"Hunters",
		Color(224, 224, 64))
	team.SetUp(
		2,
		"Props",
		Color(64, 64, 224))
end

function GM:EntityTakeDamage(targetEntity, damageInfo)
	local attacker = damageInfo:GetAttacker()
	
	if attacker:IsPlayer() then
		player_manager.RunClass(attacker, "EntityHit", targetEntity, damageInfo)
	end
	
	if targetEntity:IsPlayer() then
		player_manager.RunClass(targetEntity, "TakeDamage", damageInfo)
	end
end

function GM:Initialize()
	// TODO: Timer stuff
end

function GM:PlayerDeath(ply, inflictor, attacker)
	if ply:IsPlayer() then
		player_manager.RunClass(ply, "Death", inflictor, attacker)
	end
end