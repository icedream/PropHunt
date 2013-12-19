AddCSLuaFile()

/**
 * TEAM MANAGEMENT
 */

function GM:CreateTeams()
	if !GAMEMODE.TeamBased then
		return
	end

	GAMEMODE:Log("Setting up teams...")
	
	local teamID = 0
	PropHunt.TeamsByNumber = {}
	
	for teamName, teamTable in pairs(PropHunt.Teams) do
	
		if teamID >= 2 then
			// We already have 2 teams. More aren't supported.
			break
		end
		
		// Assign number
		teamID = teamID + 1
		teamTable.ID = teamID
		teamTable.Name = teamName
		
		// Default spawn points
		if !!teamTable.Spawnpoints then
			if teamID == PH_TEAM_HUNTER then
				// These are going to be the hunters
				teamTable.Spawnpoints = {"info_player_counterterrorist", "info_player_combine", "info_player_deathmatch", "info_player_axis"}
			elseif teamID == PH_TEAM_PROP then
				// These are going to be the props
				teamTable.Spawnpoints = {"info_player_terrorist", "info_player_rebel", "info_player_deathmatch", "info_player_allies"}
			end
		end
		
		// Make an alias for the team and refresh data
		PropHunt.TeamsByNumber[teamID] = teamTable
		
		// Register team
		team.SetUp			(teamTable.ID, teamTable.Name, teamTable.Color)
		team.SetSpawnPoint	(teamTable.ID, {"info_player_counterterrorist", "info_player_combine", "info_player_deathmatch", "info_player_axis"})
		team.SetClass		(teamTable.ID, {teamTable.Class or teamTable.Name})
		GAMEMODE:Log("Team \"" .. teamTable.Name .. "\" registered")
	end
	
	for num, teamTable in pairs(PropHunt.TeamsByNumber) do
		PropHunt.Teams[num] = teamTable
	end
	PropHunt.TeamsByNumber = nil

	GAMEMODE:Log("Team setup finished")

end