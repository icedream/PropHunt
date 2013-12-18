/**
 * Disguiser weapon
 *
 * @author	Icedream
 * @version	0.1
 * @license	GPL
 */
 
// DEBUG DEBUG DEBUG
print("[Disguiser] Loading shared...")

// Weapon info
SWEP.Author = "Icedream"
SWEP.Contact = "icedream@modernminas.de"
SWEP.Category = "Fun"
SWEP.Purpose = "Lets you disguise as a map model."
SWEP.Instructions =
	"Aim at a model on the map and press the left mouse button to disguise."
	.. " Undisguise with right mouse button."
SWEP.Spawnable  = true
SWEP.AdminSpawnable = true
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/c_toolgun.mdl" // won't be displayed anyways, see Deploy
SWEP.WorldModel = "models/weapons/w_toolgun.mdl" // won't be displayed anyways, see Deploy

// Precache models
util.PrecacheModel( SWEP.ViewModel )
util.PrecacheModel( SWEP.WorldModel )

// Disable ammo system
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none" // lasers would be nice :3
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

// Sounds
SWEP.Sounds = {
	Disguise = {
		"garrysmod/balloon_pop_cute.wav"
	},
	Undisguise = {
		"garrysmod/balloon_pop_cute.wav"
	},
	Shot = {
		"weapons/disguiser/shot1.mp3" // original sound by http://freesound.org/people/ejfortin/sounds/49678/
	}
}
SWEP.ChannelMapping = {
	Disguise = {
		Channel = CHAN_BODY,
		Volume = 1.0,
		Level = 85,
		Pitch = { 70, 130 }
	},
	Undisguise = {
		Channel = CHAN_BODY,
		Volume = 1.0,
		Level = 85,
		Pitch = { 70, 130 }
	},
	Shot = {
		Channel = CHAN_WEAPON,
		Volume = 0.5,
		Level = 60,
		Pitch = { 80, 160 }
	}
}

// Load the sounds
for soundName, soundPaths in pairs(SWEP.Sounds) do
	local internalSoundName = "Disguiser." .. soundName
	for k, soundPath in pairs(soundPaths) do
		if SERVER then
			resource.AddFile("sound/" .. soundPath)
		end
		if !file.Exists("sound/" .. soundPath, "GAME") then
			print("[Disguiser] WARNING: Sound not found: " .. soundPath)
		end
		util.PrecacheSound(soundPath)
	end
	print("[Disguiser] Loading sound " .. internalSoundName .. "...")
	sound.Add({
		name = internalSoundName,
		channel = SWEP.ChannelMapping[soundName].Channel,
		volume = SWEP.ChannelMapping[soundName].Volume,
		soundlevel = SWEP.ChannelMapping[soundName].Level,
		pitchstart = SWEP.ChannelMapping[soundName].Pitch[0],
		pitchend = SWEP.ChannelMapping[soundName].Pitch[1],
		sound = soundPaths
	})
end