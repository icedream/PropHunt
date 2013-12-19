usermessage.Hook("resetHull", function(um)
	// message input
	local player = um:ReadEntity()
	
	// actually reset the hull
	player:ResetHull()
end)

usermessage.Hook("setBounding", function(um)
	// message input
	local player = um:ReadEntity()
	local obbmins = um:ReadVector()
	local obbmaxs = um:ReadVector()

	// hull from given vectors
	player:SetHull(obbmins, obbmaxs)
	player:SetHullDuck(obbmins, obbmaxs) -- ducking shouldn't work for props
end)

usermessage.Hook("setRenderOrigin", function(um)
	// TODO: This should reposition the player so the model is fully above the surface.
	// For some reason this does not work or is being ignored.
	
	// message input
	local player = um:ReadEntity()
	local renderOriginMin = um:ReadVector()
	local renderOriginMax = um:ReadVector()
	
	// debug message
	player:ChatPrint("RenderOrigin: " .. renderOriginMin.x .. "|" .. renderOriginMin.y .. "|" .. renderOriginMin.z)
	
	// reposition the player
	player:SetRenderOrigin(renderOriginMin, renderOriginMax)
	player:DrawModel()
end)