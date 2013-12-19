AddCSLuaFile() // shared file

// Empty objects for configuration file
PropHunt = {}
PropHunt.Teams = {}

// Load config separately
// TODO: Put this into server code
if SERVER then AddCSLuaFile("config.lua") end

// Include the required lua files
include("constants.lua")
include("logging.lua")
include("config.lua")
include("convars.lua")
include("map.lua")
include("gamemode.lua")
include("teams.lua")