AddCSLuaFile(); // Shared

if PropHunt.WeaponsAllowGrenade then PropHunt.WeaponsAllowGrenadeNum = 1 else PropHunt.WeaponsAllowGrenadeNum = 0 end
if PropHunt.AllowOneSided then PropHunt.AllowOneSided = 1 else PropHunt.AllowOneSided = 0 end

// TODO: More of them convars?
PropHunt.CVars = {
	AllowOneSided = CreateConVar("ph_allowonesided", tostring(PropHunt.AllowOneSided), FCVAR_REPLICATED),
	HunterBlindlockTime = CreateConVar("ph_hunter_blindlocktime", tostring(PropHunt.BlindLockTime), FCVAR_REPLICATED),
	HunterFirePenalty = CreateConVar("ph_hunter_firepenalty", tostring(PropHunt.HunterFirePenalty), FCVAR_REPLICATED),
	HunterKillBonus = CreateConVar("ph_hunter_killbonus", tostring(PropHunt.HunterKillBonus), FCVAR_REPLICATED),
	HunterAllowGrenades = CreateConVar("ph_weapons_allowgrenade", tostring(PropHunt.WeaponsAllowGrenadeNum), FCVAR_REPLICATED)
}




