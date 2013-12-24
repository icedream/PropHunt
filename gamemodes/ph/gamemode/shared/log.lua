function Log(...)
	Msg("[PH] ")
	MsgN(...)
end

function LogF(fn, ...)
	Msg("[PH] " .. (fn or "<unknown>") .. ": ")
	MsgN(...)
end