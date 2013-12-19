AddCSLuaFile(); // Shared

// TODO: EVERYTHING from the configuration must be placed here!!!

if PropHunt.AllowOneSided then PropHunt.AllowOneSided = 1 else PropHunt.AllowOneSided = 0 end

PropHunt.CVars = {
	AllowOneSided = CreateConVar("ph_allowonesided", tostring(PropHunt.AllowOneSided), FCVAR_REPLICATED),
}




