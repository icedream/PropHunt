// Create new class
local CLASS = {}

// Some settings for the class
CLASS.DisplayName			= "Prop"
CLASS.WalkSpeed 			= 250
CLASS.CrouchedWalkSpeed			= 0.2
CLASS.RunSpeed				= 300
CLASS.DuckSpeed				= 0.2
CLASS.DrawTeamRing			= false
CLASS.DrawViewModel			= false
CLASS.FullRotation			= false
CLASS.JumpPower				= 200
CLASS.DeathSounds			= PropHunt.Sounds.Death.Props
CLASS.TauntSounds			= PropHunt.Sounds.Taunt.Props

// Called by spawn and sets loadout
function CLASS:Loadout(pl)
	// Props don't get anything

	pl:ChatPrint("You are now in the Props team!")
	pl:ChatPrint("Go to a prop, look at it and press E to turn into that prop. Then run away from the Hunters!")

end

// Called when player spawns with this class
function CLASS:OnSpawn(pl)
	// Make original player invisible
	pl:SetColor( Color(255, 255, 255, 0))
	
	// Make prop entity
	pl.ph_prop = ents.Create("ph_prop")
	pl.ph_prop:SetSolid(SOLID_BBOX)
	pl.ph_prop:SetParent(pl) // make it move with the original player
	pl.ph_prop:SetOwner(pl)
	pl.ph_prop.max_health = 100
	pl.ph_prop:Spawn()
	pl.ph_prop:SetPos(pl:GetPos())
	pl.ph_prop:SetAngles(pl:GetAngles())
	// Reset taunt time
	pl.last_taunt_time = 0

	if PropHunt.ForceTaunt && PropHunt.ForceTauntInterval > 0then
		local checkForceTaunt = function()
			if !pl || !pl:IsValid() || !pl:IsAlive() then
				return
			end
	
			if CurTime() - pl.last_taunt_time >= PropHunt.ForceTauntInterval then
				GAMEMODE:ShowSpare1(pl)
			end
	
			timer.Simple(1, checkForceTaunt)
		end
		timer.Simple(30 + math.random(0, PropHunt.ForceTauntInterval * 2), checkForceTaunt)
	end
end

// Called when a player dies with this class
function CLASS:OnDeath(pl, attacker, dmginfo)
	GAMEMODE:LogO("Trying to play death sound", "CLASS:OnDeath", pl)
	self:PlayDeathSound(pl)
	pl:RemoveProp()
end

function CLASS:GetRandomDeathSound()
	local DeathSound = nil
	
	while
		(table.Count(self.DeathSounds) > 1 && !DeathSound)
		|| (DeathSound != nil && (DeathSound == self.LastDeathSound))
	do
		DeathSound = table.Random(self.DeathSounds)
	end

	self.LastDeathSound = DeathSound

	return DeathSound
end

function CLASS:PlayDeathSound(pl)
	local soundn = self:GetRandomDeathSound()
	if soundn == nil then
		GAMEMODE:LogO("Got no sound from random function, aborting death sound playback", "CLASS:PlayDeathSound", pl)
		return
	end
	//pl:StopSound()
	//if pl.ph_prop != nil && pl.ph_prop:IsValid() then pl.ph_prop:StopSound() end
	GAMEMODE:LogO("Playing death sound "..soundn, "CLASS:PlayDeathSound", pl)
	sound.Play(soundn, pl:GetPos())
end

// Register
player_class.Register("Prop", CLASS)