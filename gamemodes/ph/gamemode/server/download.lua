local function AddCSLuaFolder(fol)
	LogF("AddCSLuaFolder", "Appending folder ", fol .. "/")
	
	local files, folders = file.Find(fol .. "/*.lua", "LUA")
	LogF("AddCSLuaFolder", fol .. ": ", "Found ", #files, " files and ", #folders, " folders")
	
	for _, File in SortedPairs(files) do
		LogF("AddCSLuaFolder", fol .. ": ", "Appending file ", File)
		AddCSLuaFile(fol .. folder .. "/" ..File)
	end
	
	for _, Folder in SortedPairs(folders, true) do
		if Folder ~= ".." then
			AddCSLuaFolder(fol .. "/" .. Folder)
		end
	end
end

AddCSLuaFile("../cl_init.lua")
AddCSLuaFolder("client")
AddCSLuaFolder("shared")
AddCSLuaFolder("shared/player_classes")