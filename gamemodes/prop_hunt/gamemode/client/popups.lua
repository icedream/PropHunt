// Shows that a player has killed too many props
usermessage.Hook("PlayerPropSuicide", function(um)
	local pl = um:ReadEntity()
	
	// TODO: Stub AddPlayerAction
	if !GAMEMODE.AddPlayerAction then
		GAMEMODE.AddPlayerAction = print
	end
	
	// Hunter anonymous?
	if !pl then
		GAMEMODE:AddPlayerAction("A hunter died for all the innocent props they hurt")
		return
	end
	
	GAMEMODE:AddPlayerAction(pl, "died for all the innocent props they hurt")
end)