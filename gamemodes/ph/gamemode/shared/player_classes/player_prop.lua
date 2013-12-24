DEFINE_BASECLASS("player_default")

player_manager.RegisterClass("player_prop", {
	WalkSpeed = 200,
	RunSpeed = 350,
	
	MaxHealth = 250,
	
	// Player class initialization
	Init = function()
	end,
	
	// Player loadout
	Loadout = function()
		self.Player:RemoveAllAmmo()
		self.Player:StripWeapons()
		
		self.Player:Give("disguiser")
	end,
	
	// Player dies
	Death = function(inflictor, attacker)
		// Give attacker 20 HP back
		if IsValid(attacker) && attacker:IsPlayer() then
			attacker:SetHealth(math.Clamp(attacker:Health() + 20, 0, attacker:GetMaxHealth()))
		end
	end
}, "player_default")