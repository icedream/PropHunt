// Prepare sound files for download
for teamName, teamTable in pairs(PropHunt.Teams) do
	for soundName, soundList in pairs(teamTable.Sounds) do
		for _, sound in pairs(soundList) do
			resource.AddFile("sound/"..sound)
		end
	end
end

// If there is a mapfile send it to the client (sometimes servers want to
// change settings for certain maps)
if file.Exists("../gamemodes/prop_hunt/gamemode/client/maps/"..game.GetMap()..".lua", "LUA") then
	AddCSLuaFile("client/maps/"..game.GetMap()..".lua")
end
if file.Exists("../gamemodes/prop_hunt/gamemode/shared/maps/"..game.GetMap()..".lua", "LUA") then
	AddCSLuaFile("shared/maps/"..game.GetMap()..".lua")
end
