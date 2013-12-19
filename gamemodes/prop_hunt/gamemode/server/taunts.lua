// Called when player presses [F3]. Plays a taunt for their team
function GM:ShowSpare1(pl)
	// Round and player checks
	if !GAMEMODE:InRound() || !IsValid(pl) || !pl:Alive() then return end
	
	// Too early triggered?
	if pl.last_taunt_time + PropHunt.TauntDelay > CurTime() then return end
	
	// Is that team even defined in the configuration?
	if !PropHunt.Teams[pl:Team()] then return end

	// Are there even defined sounds?
	local sounds = PropHunt.Teams[pl:Team()].Sounds
	if !sounds then return end

	// We could use EmitSound's randomness, but we don't want the same
	// sound over and over again. Let's be deluxe here.
	local rand_taunt = nil
	while
		(rand_taunt == nil && table.Count(sounds) > 0)
		|| (rand_taunt != nil && table.Count(sounds) > 1 && rand_taunt == pl.last_taunt)
	do
		rand_taunt = table.Random(sounds)
	end
	pl.last_taunt_time = CurTime()
	pl.last_taunt = rand_taunt
	if rand_taunt != nil then
		GAMEMODE:LogO("Playing taunt sound "..rand_taunt, "GM:ShowSpare1", pl)
		pl:EmitSound(rand_taunt, 100)
	end
end
