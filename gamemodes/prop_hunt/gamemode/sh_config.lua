// Props will not be able to become these models
PropHunt.BannedPropModels = {
	"models/props/cs_assault/dollar.mdl",
	"models/props/cs_assault/money.mdl",
	"models/props/cs_office/snowman_arm.mdl",
	"models/props/cs_office/computer_mouse.mdl",
	"models/props/cs_office/projector_remote.mdl"
}

// Unlimited ammo
PropHunt.UnlimitedAmmo = true

// Unlimited grenades
PropHunt.UnlimitedGrenades = false

// Seconds to run before the first round starts
PropHunt.PreStartTime = 45

// Allow only one team to have players for starting the first round
PropHunt.AllowOneSided = true

// Enable regular force-taunting?
PropHunt.ForceTaunt = true

// The forcetaunt interval for all players except campers. 0 to disable.
PropHunt.ForceTauntInterval = 30

// The forcetaunt interval for campers in seconds. 0 to disable.
PropHunt.ForceTauntIntervalForCampers = 15

// Forcetaunt should only trigger X seconds after starting the round. 0 for insta-trigger.
PropHunt.ForceTauntAfter = PropHunt.ForceTauntInterval *2

// Model for hunters
PropHunt.HunterModel = "models/player/combine_super_soldier.mdl"

// Maximum time (in minutes) for this fretta gamemode (Default: 30)
PropHunt.GameTime = 30

// Number of seconds hunters are blinded/locked at the beginning of the map (Default: 30)
PropHunt.BlindLockTime = 30

// Health points removed from hunters when they shoot  (Default: 5)
PropHunt.HunterFirePenalty = 5

// How much health to give back to the Hunter after killing a prop (Default: 20)
PropHunt.HunterKillBonus = 20

// Whether or not we include grenade launcher ammo (default: 1)
PropHunt.WeaponsAllowGrenade = true

// Minimum delay between taunt triggers (Default: 3)
PropHunt.TauntDelay = 3

// Rounds played on a map (Default: 10)
PropHunt.RoundsPerMap = 10

// Time (in seconds) for each round (Default: 300)
PropHunt.RoundTime = 300

// Determines if players should be team swapped every round [0 = No, 1 = Yes] (Default: 1)
PropHunt.SwapTeamsEveryRound = true

// Determines if players should be team swapped every round even if both teams have zero points [0 = No, 1 = Yes] (Default: 1)
PropHunt.SwapTeamsPointsZero = true

// Team-balancing after every round
PropHunt.RoundTeamBalancing = true

// Death sounds for hunters
PropHunt.Sounds.Death.Hunters = {
	"player/death/hunters/ih0001.mp3",
	"player/death/hunters/ih0002.mp3",
	"player/death/hunters/ih0003.mp3",
}

// Death sounds for props
PropHunt.Sounds.Death.Props = {
	"player/death/props/ih0001.mp3",
	"player/death/props/ih0002.mp3",
}

// Pop sounds for when the props switch
PropHunt.Sounds.Pop.Props = {
	"effect/pop1a.mp3",
	"effect/pop2a.mp3",
	"effect/pop3a.mp3",
	"effect/pop4a.mp3",
	"effect/pop5a.mp3",
}

// Taunt sounds for hunters
PropHunt.Sounds.Taunt.Hunters = {
	--"taunts/you_dont_know_the_power.wav",
	--"taunts/you_underestimate_the_power.wav",
	"taunts/props/ih000A.mp3",
	"taunts/hunters/ih0001.mp3",
	"taunts/hunters/ih0002.mp3",
	"taunts/hunters/ih0003b.mp3",
	"taunts/hunters/ih0004.mp3",
	"taunts/hunters/ih0005.mp3",
	"taunts/hunters/ih0006a.mp3",
	"taunts/hunters/ih0007a.mp3",
	"taunts/hunters/ih0008a.mp3",
	"taunts/hunters/ih0009a.mp3",
	"taunts/hunters/ih000Aa.mp3",
	"taunts/hunters/ih000Ba.mp3",
	"taunts/hunters/ih000C.mp3",
	"taunts/hunters/ih000D.mp3",
}

// Taunt sounds for props
PropHunt.Sounds.Taunt.Props = {
	--"taunts/go_away_or_i_shall.wav",
	--"taunts/ill_be_back.wav",
	--"taunts/negative.wav",
	--"taunts/ok_i_will_tell_you.wav",
	--"taunts/please_come_again.wav",
	--"taunts/threat_neutralized.wav",

	"taunts/props/ih0001.mp3",
	"taunts/props/ih0002.mp3",
	"taunts/props/ih0003.mp3",
	"taunts/props/ih0004.mp3",
	--"taunts/props/ih0005.mp3", -- Friday, friday, gotta get down on friday... not.
	"taunts/props/ih0006.mp3",
	"taunts/props/ih0007.mp3",
	"taunts/props/ih0008.mp3",
	"taunts/props/ih0009.mp3",
	"taunts/props/ih000A.mp3",
	"taunts/props/ih000B.mp3",
	"taunts/props/ih000C.mp3",
	"taunts/props/ih000D.mp3",
	"taunts/props/ih000E.mp3",
	"taunts/props/ih000F.mp3",
	"taunts/props/ih0010.mp3",
	"taunts/props/ih0011.mp3",
	"taunts/props/ih0012.mp3",
	"taunts/props/ih0013.mp3",
	"taunts/props/ih0014.mp3",
	"taunts/props/ih0015.mp3",
	"taunts/props/ih0016.mp3",
	"taunts/props/ih0017.mp3",
	"taunts/props/ih0018.mp3",
	"taunts/props/ih0019.mp3",
	"taunts/props/ih001A.mp3",
	"taunts/props/ih001B.mp3",
	"taunts/props/ih001C.mp3",
	"taunts/props/ih001D.mp3",
	"taunts/props/ih001E.mp3",
	"taunts/props/ih001F.mp3",
	"taunts/props/ih0020.mp3",
	"taunts/props/ih0021.mp3",
	"taunts/props/ih0022.mp3",
	"taunts/props/ih0023.mp3",
	"taunts/props/ih0024.mp3",
	"taunts/props/ih0025.mp3",
	"taunts/props/ih0026.mp3",
	"taunts/props/ih0027.mp3",
	"taunts/props/ih0028.mp3",
	"taunts/props/ih0029.mp3",
	"taunts/props/ih002A.mp3",
	"taunts/props/ih002B.mp3",
	"taunts/props/ih002C.mp3",
	"taunts/props/ih002D.mp3",
	"taunts/props/ih002E.mp3",
	"taunts/props/ih002F.mp3",
	"taunts/props/ih0030.mp3",
	"taunts/props/ih0031.mp3",
	"taunts/props/ih0032.mp3",
	"taunts/props/ih0033.mp3",
	"taunts/props/ih0034a.mp3",
	"taunts/props/ih0035a.mp3",
	"taunts/props/ih0036a.mp3",
	"taunts/props/ih0037a.mp3",
	"taunts/props/ih0038.mp3",
	"taunts/props/ih0039.mp3",
	"taunts/props/ih003A.mp3",
	"taunts/props/ih003B.mp3",
	"taunts/props/ih003C.mp3",
	"taunts/props/ih003D.mp3",
	"taunts/props/ih003E.mp3",
	"taunts/props/ih003F.mp3",
	"taunts/props/ih0040.mp3",
	"taunts/props/ih0041.mp3",
	"taunts/props/ih0042.mp3",
	"taunts/props/ih0043.mp3",
	"taunts/props/ih0044.mp3",
	"taunts/props/ih0045.mp3",
	"taunts/props/ih0046.mp3",
	"taunts/props/ih0047.mp3",
	"taunts/props/ih0048.mp3",
	"taunts/props/ih0049.mp3",
	"taunts/props/ih004A.mp3",
	"taunts/props/ih004B.mp3",
	"taunts/props/ih004C.mp3",
	"taunts/props/ih004D.mp3",
	"taunts/props/ih004E.mp3",
	"taunts/props/ih004F.mp3",
	"taunts/props/ih0050.mp3",
	"taunts/props/ih0051.mp3",
	"taunts/props/ih0052.mp3",
	"taunts/props/ih0053.mp3",
	"taunts/props/ih0054.mp3",
	"taunts/props/ih0055.mp3",
	"taunts/props/ih0056.mp3",

	--"taunts/you_dont_know_the_power.mp3",
	--"taunts/you_underestimate_the_power.mp3"
}

// Loss sounds for hunters
PropHunt.Sounds.Loss.Hunters = {
	"taunts/props/ih0025.mp3"
}

// Loss sounds for props
PropHunt.Sounds.Loss.Props = PropHunt.Sounds.Loss.Hunters // the same as hunters.

// Victory sounds for hunters
PropHunt.Sounds.Victory.Props = {
	"taunts/props/ih0021.mp3"
}

// Victory sounds for props
PropHunt.Sounds.Victory.Props = PropHunt.Sounds.Victory.Hunters // the same as hunters.

// If you like glitchy blindness, go ahead. :P
PropHunt.IWantGlitchyBlindness = false
