function GM:Log(...)
	printResult = "[PH] "
	for _, v in ipairs(arg) do
		if IsValid(v) && !!v["Name"] then
			printResult = printResult .. v:Name()
		else
			printResult = printResult .. tostring(v)
		end
		printResult = printResult .. " "
	end
	print(printResult)
end

function GM:LogF(fn, ...)
	if !fn then fn = "<unknown>" end
	GAMEMODE:Log(fn .. ":", arg)
end