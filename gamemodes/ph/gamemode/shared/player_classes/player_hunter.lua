DEFINE_BASECLASS("player_default")

player_manager.RegisterClass("player_hunter", {
	WalkSpeed = 200,
	RunSpeed = 350,
	
	// Player class initialization
	Init = function()
	end,
	
	// Player loadout
	Loadout = function()
		self.Player:RemoveAllAmmo()
		self.Player:StripWeapons()
		
		self.Player:Give("weapon_crowbar")
		self.Player:Give("weapon_frag")
		self.Player:Give("bf3m16")
		self.Player:Give("kermite_shot_winch1300")
		self.Player:Give("bf3m1911")
		
		self.Player:GiveAmmo(64, "Buckshot", false)
		self.Player:GiveAmmo(255, "SMG1", false)
		self.Player:GiveAmmo(255, "Pistol", false)
	end,
	
	// Player shoots at an entity (not a player!)
	EntityHit = function(target, dmg)
		if !target:IsPlayer() then
			if self.Player.Health() - 5 <= 0 then
				// Player gets killed
				self.Player:KillSilent()
				GAMEMODE:PlayerDeath(self.Player, dmg:GetInflictor(), self.Player)
			else
				// Just subtract 5 HP
				self.Player:SetHealth(self.Player:Health() - 5)
			end
		end
	end
}, "player_default")