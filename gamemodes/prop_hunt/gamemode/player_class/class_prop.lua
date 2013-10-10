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

	if PropHunt.ForceTaunt && PropHunt.ForceTauntInterval > 0 then
		GAMEMODE:LogO("Prepared force taunt.", "CLASS:OnSpawn", pl)

		pl.last_moving_time = CurTime()
		pl.last_moving_pos = pl:GetPos()
		pl.first_forcetaunt_run = CurTime() + PropHunt.ForceTauntAfter + math.random(0, PropHunt.ForceTauntInterval)
		pl.func_forcetaunt = function()

			// check if player is fine for forcetaunting
			if !pl || !pl["IsValid"] || !pl:IsValid() || !pl:Alive() || pl:Team() != PropHunt.TeamIDs.Props then
				GAMEMODE:LogO("Forcetaunt: player is not okay. Will not repeat.", "pl.func_forcetaunt", pl)
				return
			end

			// check if player is moving away from place and if yes, reset "last_moving_time"
			local distance = pl.last_moving_pos:Distance(pl:GetPos())
			if distance > 130 then
				pl.last_moving_pos = pl:GetPos() // reset last position
				pl.last_moving_time = CurTime()
			end

			local isCamping = CurTime() - pl.last_moving_time > 5;		
			local last_taunt_timespan = CurTime() - (pl.last_taunt_time or 0)
			local shouldTriggerForcetaunt = CurTime() > (pl.first_forcetaunt_run or 0) && PropHunt.ForceTaunt
			if (isCamping && shouldTriggerForcetaunt && (PropHunt.ForceTauntIntervalForCampers or 0) > 0 && last_taunt_timespan >= PropHunt.ForceTauntIntervalForCampers)
			|| (!isCamping && shouldTriggerForcetaunt && (PropHunt.ForceTauntInterval or 0) > 0 && last_taunt_timespan >= PropHunt.ForceTauntInterval) then
				GAMEMODE:ShowSpare1(pl)
				GAMEMODE:LogO("Forcetaunt: triggered.", "pl.func_forcetaunt", pl)
			end

			timer.Simple(1, pl.func_forcetaunt)

		end
		timer.Simple(1, pl.func_forcetaunt)
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
