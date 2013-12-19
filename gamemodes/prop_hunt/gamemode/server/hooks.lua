// Called when an entity takes damage
hook.Add("EntityTakeDamage", "PH_EntityTakeDamage", function(ent, dmginfo)
	local att = dmginfo:GetAttacker()
	
	// TODO: Fix InRound()
	if //GAMEMODE:InRound()
		&& IsValid(ent) && !ent:IsPlayer()
		&& IsValid(att) && att:IsPlayer() && att:Alive()
	then
		// Not-a-player penalty
		if (!!att:TeamData().NoPlayerHitPenalty) then
			att:SetHealth(att:Health() - att:TeamData().NoPlayerHitPenalty)
			if att:Health() <= 0 then
				att:KillSilent()
			end
		end
	end
end)

// Hands patch
hook.Add("PlayerSetModel", "PH_DrawHands", function(ply)
	if(ply:Team() != PropHunt.TeamIDs.Hunters) then return end

	local oldhands = ply:GetHands()
	if ( IsValid( oldhands ) ) then oldhands:Remove() end

	local hands = ents.Create( "gmod_hands" )
	if ( IsValid( hands ) ) then
		ply:SetHands( hands )
		hands:SetOwner( ply )

		-- Which hands should we use?
		local cl_playermodel = "combine" or ply:GetInfo( "cl_playermodel" ) or ply:GetModel() or nil
		local info = player_manager.TranslatePlayerHands( cl_playermodel )
		if ( info ) then
			hands:SetModel( info.model )
			hands:SetSkin( info.skin )
			hands:SetBodyGroups( info.body )
		end

		-- Attach them to the viewmodel
		local vm = ply:GetViewModel( 0 )
		hands:AttachToViewmodel( vm )

		vm:DeleteOnRemove( hands )
		ply:DeleteOnRemove( hands )

		hands:Spawn()
 	end
end)

// Called when the gamemode is initialized
hook.Add("Initialize", "PH_Initialize", function()
	GAMEMODE:LogF("Disabling flashlight", "PH_Initialize")
	game.ConsoleCommand("mp_flashlight 0\n")
	return true
end)

// Called when a player leaves
hook.Add("PlayerDisconnected", "PH_PlayerDisconnected", function(pl)
	GAMEMODE:LogO("Player disconnected", "PH_PlayerDisconnected", pl)
	return true
end)

// Called when a player connects
hook.Add("PlayerAuthed", "PH_PlayerAuthed", function(pl,stid,unid)
	GAMEMODE:LogO("Player authenticated, disabling crosshair", "PH_PlayerAuthed", pl)
	pl:CrosshairDisable()
	return true
end)

// Called when the players spawns
hook.Add("PlayerSpawn", "PH_PlayerSpawn", function(pl)
	GAMEMODE:LogO("Taking post-spawn actions for player", "PH_PlayerSpawn", pl)

	pl:Blind(false)
	pl:SetColor(Color(255, 255, 255, 255))
	pl:SetRenderMode( RENDERMODE_TRANSALPHA)
	pl:UnLock()
	pl:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)

	return true
end)

// Removes all weapons on a map
hook.Add("InitPostEntity", "PH_RemoveWeaponsAndItems", function()
	GAMEMODE:LogF("Removing all weapons on map", "PH_RemoveWeaponsAndItems")

	for _, wep in pairs(ents.FindByClass("weapon_*")) do
		wep:Remove()
	end
	
	for _, item in pairs(ents.FindByClass("item_*")) do
		item:Remove()
	end
end)