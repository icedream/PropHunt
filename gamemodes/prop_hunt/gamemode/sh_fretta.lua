AddCSLuaFile() // Shared

// Fretta gamemode
DeriveGamemode("fretta")

// Include the player classes
IncludePlayerClasses()

// Information about the gamemode
--Metadata
GM.Name				= "Prop Hunt"
GM.Author			= "Icedream (original by AMT, port by Kow@lski)"
GM.Email			= "icedream@modernminas.de"
GM.Website			= "http://xspacesoft.github.io/PropHunt/"

--Game
GM.AddFragsToTeamScore		= true
GM.CanOnlySpectateOwnTeam 	= true
GM.Data 			= {}
GM.EnableFreezeCam		= true
GM.GameLength			= PropHunt.GameTime
GM.NoAutomaticSpawning		= true
GM.NoNonPlayerPlayerDamage	= true
GM.NoPlayerPlayerDamage 	= true
GM.RoundBased			= true
GM.RoundLimit			= PropHunt.RoundsPerMap
GM.RoundLength 			= PropHunt.RoundTime
GM.RoundPreStartTime		= 0
GM.SelectModel			= false
GM.SuicideString		= "had too much #YOLOSWAG."
GM.TeamBased 			= true

--Help
GM.Help	= [[Prop Hunt is a twist on the classic backyard game Hide and Seek.

As a Prop you have ]]..PropHunt.CVars.HunterBlindLockTime:GetInt()..[[ seconds to replicate an existing prop on the map and then find a good hiding spot. Press [E] to replicate the prop you are looking at. Your health is scaled based on the size of the prop you replicate.

As a Hunter you will be blindfolded for the first ]]..PropHunt.CVars.HunterBlindLockTime:GetInt()..[[ seconds of the round while the Props hide. When your blindfold is taken off, you will need to find props controlled by players and kill them. Damaging non-player props will lower your health significantly. However, killing a Prop will increase your health by ]]..PropHunt.CVars.HunterKillBonus:GetInt()..[[ points.

Both teams can press [F3] to play a taunt sound.]]