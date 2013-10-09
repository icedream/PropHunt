// Send the required lua files to the client
-- client-side lua
AddCSLuaFile("cl_gamemode.lua")
AddCSLuaFile("cl_hooks.lua")
AddCSLuaFile("cl_init.lua")
-- shared lua
AddCSLuaFile("sh_config.lua") // Separate from sh_config.lua so it doesn't get removed accidentally
AddCSLuaFile("sh_init.lua")

// Prepare sound files for download
-- PropHunt.Sounds.*
for _, soundcat in pairs(PropHunt.Sounds) do
	-- PropHunt.Sounds.*.*
	for _, soundlist in pairs(soundcat) do
		-- Files
		for _, sound in pairs(soundlist) do
			resource.AddFile("sound/"..sound)
		end
	end
end

// If there is a mapfile send it to the client (sometimes servers want to
// change settings for certain maps)
if file.Exists("../gamemodes/prop_hunt/gamemode/maps/"..game.GetMap()..".lua", "LUA") then
	AddCSLuaFile("maps/"..game.GetMap()..".lua")
end
