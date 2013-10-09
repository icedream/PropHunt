AddCSLuaFile(); // Shared

if PropHunt.WeaponsAllowGrenade then PropHunt.WeaponsAllowGrenadeNum = 1 else PropHunt.WeaponsAllowGrenadeNum = 0 end

CreateConVar("HUNTER_BLINDLOCK_TIME", tostring(PropHunt.BlindLockTime), FCVAR_REPLICATED)
CreateConVar("HUNTER_FIRE_PENALTY", tostring(PropHunt.HunterFirePenalty), FCVAR_REPLICATED)
CreateConVar("HUNTER_KILL_BONUS", tostring(PropHunt.HunterKillBonus), FCVAR_REPLICATED)
CreateConVar("WEAPONS_ALLOW_GRENADE", tostring(PropHunt.WeaponsAllowGrenadeNum), FCVAR_REPLICATED)
