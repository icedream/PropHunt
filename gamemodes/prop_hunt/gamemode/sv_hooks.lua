// Called when an entity takes damage
hook.Add("EntityTakeDamage", "PH_EntityTakeDamage", function(ent, dmginfo)
	local att = dmginfo:GetAttacker()
	if GAMEMODE:InRound() && ent && ent:GetClass() != "ph_prop" && !ent:IsPlayer() && att && att:IsPlayer() && att:Team() == PropHunt.TeamIDs.Hunters && att:Alive() then
		att:SetHealth(att:Health() - GetConVar("HUNTER_FIRE_PENALTY"):GetInt())
		if att:Health() <= 0 then
			umsg.Start("PlayerPropSuicide") 
 			umsg.Entity(att)
			umsg.End()
			att:KillSilent()
			att:CreateRagdoll()
			att:UnLock()

			local att_team = att:GetPlayerClass()
			if att_team then
				GAMEMODE:LogO("Playing death sound", "EntityTakeDamage", att)
				att_team:PlayDeathSound(att)
			else
				GAMEMODE:LogO("Not playing death sound, invalid att_team", "EntityTakeDamage", att)
			end
		end
	end
end)

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
		if(cl_playermodel == nil) then
			GAMEMODE:LogO("Using hands for playermodel <default>", "PH_DrawHands", ply)
		else
			GAMEMODE:LogO("Using hands for playermodel "..cl_playermodel, "PH_DrawHands", ply)
		end
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
end)

// Called when a player leaves
hook.Add("PlayerDisconnected", "PH_PlayerDisconnected", function(pl)
	GAMEMODE:LogO("Player disconnected", "PH_PlayerDisconnected", pl)
	pl:RemoveProp()
end)

// Called when a player connects
hook.Add("PlayerAuthed", "PH_PlayerAuthed", function(pl,stid,unid)
	GAMEMODE:LogO("Player authenticated, disabling crosshair", "PH_PlayerAuthed", pl)
	pl:CrosshairDisable()
end)

// Called when the players spawns
hook.Add("PlayerSpawn", "PH_PlayerSpawn", function(pl)
	GAMEMODE:LogO("Taking post-spawn actions for player", "PH_PlayerSpawn", pl)

	//pl:CrosshairDisable()
	pl:Blind(false)
	pl:RemoveProp()
	pl:SetColor( Color(255, 255, 255, 255))
	pl:SetRenderMode( RENDERMODE_TRANSALPHA )
	pl:UnLock()
	pl:ResetHull()
	pl.last_taunt_time = 0

	umsg.Start("ResetHull", pl)
	umsg.End()
	
	pl:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
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

// Called when round ends
hook.Add("RoundEnd", "PH_RoundEnd", function()
	for _, pl in pairs(team.GetPlayers(PropHunt.TeamIDs.Hunters)) do
		pl:Blind(false)
		pl:UnLock()
	end
end)

