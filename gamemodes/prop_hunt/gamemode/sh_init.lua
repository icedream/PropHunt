AddCSLuaFile() // shared file

// Empty objects for configuration file
PropHunt = {}
PropHunt.Sounds = {}
PropHunt.Sounds.Loss = {}
PropHunt.Sounds.Victory = {}
PropHunt.Sounds.Taunt = {}
PropHunt.Sounds.Death = {}

// Include the required lua files
include("sh_fonts.lua")
include("sh_config.lua")
PropHunt.BlindLockTime = PropHunt.BlindLockTime + 1
include("sh_convars.lua")
include("sh_map.lua")
include("sh_fretta.lua")
include("sh_player.lua")
include("sh_gamemode.lua")

