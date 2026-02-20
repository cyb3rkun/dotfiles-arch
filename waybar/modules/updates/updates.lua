#!/usr/bin/env lua

local json = require("json")

local updates = {}

local f = io.popen("paru -Qu --quiet")
-- collect updates in updates table
if f then
	for line in f:lines() do
		table.insert(updates, line)
	end
	f:close()
end
local class = (function(count)
	if count == 0 then
		return "ok"
	else
		local severity = math.ceil(count / 10)
		if severity == 1 then
			return "low"
		elseif severity == 2 then
			return "med"
		else
			return "high"
		end
	end
end)(#updates)

print(json.encode({
	text = tostring(#updates),
	tooltip = #updates > 0 and table.concat(updates, "\n")
		or "Up To Date",
	num_updates = #updates,
	class = class,
}))
