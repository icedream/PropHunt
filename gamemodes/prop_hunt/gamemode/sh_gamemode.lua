AddCSLuaFile()

// Called on gamemdoe initialization to create teams
function GM:CreateTeams()
	if !GAMEMODE.TeamBased then
		return
	end

	GAMEMODE:Log("Setting up teams...")

	PropHunt.TeamIDs = {}

	PropHunt.TeamIDs.Hunters = 1
	team.SetUp		(PropHunt.TeamIDs.Hunters, "Hunters", Color(150, 205, 255, 255))
	team.SetSpawnPoint	(PropHunt.TeamIDs.Hunters, {"info_player_counterterrorist", "info_player_combine", "info_player_deathmatch", "info_player_axis"})
	team.SetClass		(PropHunt.TeamIDs.Hunters, {"Hunter"})

	PropHunt.TeamIDs.Props = 2
	team.SetUp		(PropHunt.TeamIDs.Props, "Props", Color(255, 60, 60, 255))
	team.SetSpawnPoint	(PropHunt.TeamIDs.Props, {"info_player_terrorist", "info_player_rebel", "info_player_deathmatch", "info_player_allies"})
	team.SetClass		(PropHunt.TeamIDs.Props, {"Prop"})

	GAMEMODE:Log("Teams set up")

end

// Called internally by PropHunt to log things
function GM:Log(log)
	print ("[PH] " .. log)
end

// Called internally by PropHunt to log things
function GM:LogF(log, fn)
	GAMEMODE:Log(fn .. " - " .. log)
end

// Called internally by PropHunt to log things
function GM:LogO(log, fn, obj)
	if obj == nil then
		obj = {}
		obj.Name = function() return "nil" end
	end
	if fn == nil then
		return
	end
	if obj["Name"] == nil then
		if obj["GetName"] == nil then
			GAMEMODE:LogF(log, obj.."->"..fn)
		else
			GAMEMODE:LogF(log, obj:GetName().."->"..fn)
		end
	else
		GAMEMODE:LogF(log, obj:Name().."->"..fn)
	end
end
