AddCSLuaFile() // shared file

function AddPHTweakScript(prefix)
	if file.Exists(prefix .. "/maps/" .. game.GetMap() .. ".lua", "LUA")
	|| file.Exists("../gamemodes/prop_hunt/gamemode/" .. prefix .. "/maps/" .. game.GetMap() .. ".lua", "LUA") --needed?
	|| file.Exists("../lua_temp/prop_hunt/gamemode/" .. prefix .. "/maps/" .. game.GetMap() .. ".lua", "LUA") --needed?
	then
		include(prefix .. "/maps/"..prefix..game.GetMap()..".lua")
	end
end

local ph_tweak_prefix = "client"
if SERVER then ph_tweak_prefix = "server" end

AddPHTweakScript("shared")
AddPHTweakScript(ph_tweak_prefix)
