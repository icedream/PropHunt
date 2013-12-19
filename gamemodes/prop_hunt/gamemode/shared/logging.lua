AddCSLuaFile() // shared file

/**
 * LOG STUFF
 */

// Called internally by PropHunt to log things
function GM:Log(log)
	print ("[PH] " .. log)
end

// Called internally by PropHunt to log things
function GM:LogF(log, fn)
	GAMEMODE:Log(fn .. " - " .. log)
end

// Called internally by PropHunt to log things
function GM:LogO(log, fn, obj)
	if obj == nil then
		obj = {}
		obj.Name = function() return "nil" end
	end
	if fn == nil then
		return
	end
	if obj["Name"] == nil then
		if obj["GetName"] == nil then
			GAMEMODE:LogF(log, obj.."->"..fn)
		else
			GAMEMODE:LogF(log, obj:GetName().."->"..fn)
		end
	else
		GAMEMODE:LogF(log, obj:Name().."->"..fn)
	end
end