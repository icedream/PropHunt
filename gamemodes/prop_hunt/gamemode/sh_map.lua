AddCSLuaFile() // shared file

function AddPHTweakScript(prefix)
	if file.Exists("maps/"..prefix..game.GetMap()..".lua", "LUA")
	|| file.Exists("../gamemodes/prop_hunt/gamemode/maps/"..prefix..game.GetMap()..".lua", "LUA") --needed?
	|| file.Exists("../lua_temp/prop_hunt/gamemode/maps/"..prefix..game.GetMap()..".lua", "LUA") --needed?
	then
		include("maps/"..prefix..game.GetMap()..".lua")
	end
end

local ph_tweak_prefix = "cl_"
if SERVER then ph_tweak_prefix = "sv_" end

AddPHTweakScript("sh_")
AddPHTweakScript(ph_tweak_prefix)
