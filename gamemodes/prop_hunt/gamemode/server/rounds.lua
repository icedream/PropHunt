// Called when the game needs to check how the round ends
function GM:CheckPlayerDeathRoundEnd()
	if !GAMEMODE.RoundBased || !GAMEMODE:InRound() then 
		return
	end

	local Teams = GAMEMODE:GetTeamAliveCounts()

	if table.Count(Teams) < 1 then
		GAMEMODE:RoundEndWithResult(1001, "Draw, everyone loses!")
	elseif table.Count(Teams) == 1 then
		local teamID = table.GetFirstKey(Teams)
		GAMEMODE:RoundEndWithResult(teamID, team.GetName(teamID).." win!")
	end
end

// This is called when the round time ends (props win)
function GM:RoundTimerEnd()
	if !GAMEMODE:InRound() then
		return
	end
   
	GAMEMODE:RoundEndWithResult(PropHunt.TeamIDs.Props, team.GetName(PropHunt.TeamIDs.Props) .. " have survived and win!")
end

// Called before start of round
function GM:OnPreRoundStart(num)

	UTIL_StripAllPlayers()

	GAMEMODE:Log("Cleaning up map...")
	game.CleanUpMap()

	--if (PropHunt.RoundTeamBalancing) then GAMEMODE:CheckTeamBalance() end

	for _, pl in pairs(player.GetAll()) do
		if pl:Team() == PropHunt.TeamIDs.Props || pl:Team() == PropHunt.TeamIDs.Hunters then
			// Switch teams if needed
			if GetGlobalInt("RoundNumber") != 1
			&& (PropHunt.SwapTeamsEveryRound
			|| ((team.GetScore(PropHunt.TeamIDs.Props) + team.GetScore(PropHunt.TeamIDs.Hunters)) > 0 || PropHunt.SwapTeamsPointsZero))
			then
				pl:ChatPrint("Teams have been swapped!")
				if pl:Team() == PropHunt.TeamIDs.Props then
					pl:SetTeam(PropHunt.TeamIDs.Hunters)
				else
					pl:SetTeam(PropHunt.TeamIDs.Props)
				end
			end
		end
	end

	UTIL_SpawnAllPlayers()
	UTIL_FreezeAllPlayers()


	GAMEMODE:Log("OnPreRoundStart done.")

end

function GM:CanStartRound(iNum)
	// Only check on first round
	if (iNum > 1) then return true end
	
	local hasHunter = false
	local hasProp = false
	local allowOneSided = PropHunt.CVars.AllowOneSided:GetBool()
	for _, ply in ipairs(player.GetAll()) do
		if ply:Team() == PropHunt.TeamIDs.Hunters then hasHunter = true end
		if ply:Team() == PropHunt.TeamIDs.Props then hasProp = true end
		if (!allowOneSided && hasHunter && hasProp)
			|| (allowOneSided && (hasHunter || hasProp))
		then
			return true
		end
	end
	return false
end

hook.Add("RoundEnd", "PH_RoundEnd", function()
	for _, pl in pairs(player.GetAll()) do
		pl:Blind(false)
		pl:UnLock()
	end
end)
