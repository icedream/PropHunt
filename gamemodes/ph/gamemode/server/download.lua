local function AddCSLuaFolder(fol)
	fol = string.lower(fol)
	local _, folders = file.Find(fol .. "*", "LUA")
	for _, folder in SortedPairs(folders, true) do
		if folder ~= "." and folder ~= ".." then
			for _, File in SortedPairs(file.Find(fol .. folder .."/*.lua", "LUA")) do
				MsgC(Color(0, 192, 0), "AddCSLuaFolder: Appending file " .. fol .. folder .. "/" .. File)
				AddCSLuaFile(fol .. folder .. "/" ..File)
			end
		end
	end
end

AddCSLuaFolder("client/")
AddCSLuaFolder("shared/")
AddCSLuaFolder("shared/player_classes/")