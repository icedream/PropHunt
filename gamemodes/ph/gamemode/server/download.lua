local function AddCSLuaFolder(fol)
	fol = string.lower(fol)
	local _, folders = file.Find(fol .. "*", "LUA")
	for _, folder in SortedPairs(folders, true) do
		if folder ~= ".." then
			LogF("AddCSLuaFolder", "Appending folder ", fol .. folder .. "/")
			for _, File in SortedPairs(file.Find(fol .. folder .."/*.lua", "LUA")) do
				LogF("AddCSLuaFolder", "Appending file ", fol .. folder .. "/" .. File)
				AddCSLuaFile(fol .. folder .. "/" ..File)
			end
		else
			LogF("AddCSLuaFolder", "Not appending folder ", fol .. folder .. "/")
		end
	end
end

AddCSLuaFile("../cl_init.lua")
AddCSLuaFolder("client/")
AddCSLuaFolder("shared/")
AddCSLuaFolder("shared/player_classes/")