AddCSLuaFile() // shared file

// Finds the player meta table or terminates
local PlayerExt = FindMetaTable("Player")
if !PlayerExt then return end