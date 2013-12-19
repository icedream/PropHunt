// Seconds to run before the first round starts
PropHunt.PreStartTime = 45

// Allow only one team to have players for starting the first round
PropHunt.AllowOneSided = true

// Maximum time (in minutes) for this fretta gamemode (Default: 30)
PropHunt.GameTime = 30

// Rounds played on a map (Default: 10)
PropHunt.RoundsPerMap = 10

// Time (in seconds) for each round (Default: 300 seconds or 5 minutes)
PropHunt.RoundTime = 300

// Determines if players should be team swapped every round (Default: true)
PropHunt.SwapTeamsEveryRound = true

// Determines if players should be team swapped every round even if both teams have zero points (Default: true)
PropHunt.SwapTeamsPointsZero = true

// Team-balancing after every round
PropHunt.RoundTeamBalancing = true

// If you like glitchy blindness, go ahead. :P
PropHunt.IWantGlitchyBlindness = false

// Teams
PropHunt.Teams = {

	// Hunters
	Hunter = {
		Model = "models/player/combine_super_soldier.mdl",
		Weapons = {
			"weapon_crowbar", -- Crowbar
			"weapon_frag", -- Frag Grenade
			"bf3m16", -- BF3 M16A3
			"kermite_shot_winch1300", -- Winchester 1300 shotgun
			"bf3m1911", -- BF3 M1911 pistol
		},
		Color = Color(150, 205, 255, 255), // Team color
		WalkSpeed = 250,
		CrouchMultiply = 0.5,
		DuckMultiply = 0.2,
		RunMultiply = 1.25,
		JumpPower = 200,
		InvisibleNames = false,
		UnlimitedAmmo = true,
		UnlimitedGrenades = true,
		MinimumTauntInterval = 3,
		ForceTaunt = false,
		ForceTauntInterval = 45, // Forcetaunt at least every X seconds
		ForceTauntCampingMultiply = 0.3, // When camping, X * Y seconds
		ForceTauntAfter = 30, // Delay first forcetaunt by X seconds
		KillBonus = 20, // How much HP does a hunter get back for killing a prop?
		NoPlayerHitPenalty = 5, // How much HP does a wrong shot cost?
		SpawnDelay = 30, // Let them join later
		SpawnDelayBlindness = true, // Blind first
		Sounds = {
			Loss = {
				"taunts/props/ih0025.mp3"
			},
			Victory = {
				"taunts/props/ih0021.mp3"
			},
			Death = {
				"player/death/hunters/ih0001.mp3",
				"player/death/hunters/ih0002.mp3",
				"player/death/hunters/ih0003.mp3",
			},
			Taunt = {
				"taunts/you_dont_know_the_power.wav",
				"taunts/you_underestimate_the_power.wav",
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
		}
	},
	
	// Props
	Props = {
		Model = "models/player/Kleiner.mdl",
		Weapons = {
			"disguiser" -- well, without it props wouldn't make sense
		},
		Color = Color(255, 60, 60, 255), // Team color
		WalkSpeed = 250,
		CrouchMultiply = 0.5,
		DuckMultiply = 0.2,
		RunMultiply = 1.25,
		JumpPower = 200,
		InvisibleNames = true,
		MinimumTauntInterval = 3,
		ForceTaunt = true,
		ForceTauntInterval = 45, // Forcetaunt at least every X seconds
		ForceTauntCampingMultiply = 0.3, // When camping, X * Y seconds
		ForceTauntAfter = 30, // Delay first forcetaunt by X seconds
		SpawnDelay = 0, // Let them join later
		SpawnDelayBlindness = false, // Blind first
		Sounds = {
			Loss = {
				"taunts/props/ih0025.mp3"
			},
			Victory = {
				"taunts/props/ih0021.mp3"
			},
			Death = {
				"player/death/props/ih0001.mp3",
				"player/death/props/ih0002.mp3",
			},
			Taunt = {
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
		}
	}
}

