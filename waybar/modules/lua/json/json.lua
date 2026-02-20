local json = {}

function json.escape_str(s)
	s = s:gsub("\\", "\\\\")
		:gsub('"', '\\"')
		:gsub("\n", "\\n")
		:gsub("\r", "\\r")
		:gsub("\t", "\\t")
	return '"' .. s .. '"'
end

function json.encode(value)
	local t = type(value)
	if t == "string" then
		return json.escape_str(value)
	elseif t == "number" or t == "boolean" then
		return tostring(value)
	elseif t == "table" then
		-- check for array-table
		local is_array = true
		local max_index = 0
		for k, _ in pairs(value) do
			if type(k) ~= "number" then
				is_array = false
				break
			end
			if k > max_index then max_index = k end
		end
		-- parse array table to json string
		if is_array then
			local items = {}
			for i = 1, max_index do
				table.insert(items, json.encode(value[i]))
			end
			return "[" .. table.concat(items, ",") .. "]"
		else
			--collect keys and sort them
			local keys = {}
			for k, _ in pairs(value) do
				table.insert(keys, k)
			end
			table.sort(
				keys,
				function(a, b) return tostring(a) < tostring(b) end
			)

			-- parse table to json string
			local items = {}
			for _, k in ipairs(keys) do
				table.insert(
					items,
					json.escape_str(k) .. ":" .. json.encode(value[k])
				)
			end
			return "{" .. table.concat(items, ",") .. "}"
		end
	elseif t == "nil" then
		return "null"
	else
		error("Unsupported type: " .. t)
	end
end
---@param json_str string
---@return table
function json.parse(json_str)
	local pos = 1
	local function skip_ws() pos = json_str:match("[ \n\r\t]*()", pos) end

	local parse_val

	local function parse_string()
		local s = ""
		pos = pos + 1 --skip \"
		while true do
			local c = json_str:sub(pos, pos)
			-- skip_ws()
			if c == '"' then
				pos = pos + 1
				break
			elseif c == "\\" then
				local nextc = json_str:sub(pos + 1, pos + 1)
				if nextc == '"' then
					s = s .. '"'
				elseif nextc == "\\" then
					s = s .. "\\"
				elseif nextc == "/" then
					s = s .. "/"
				elseif nextc == "b" then
					s = s .. "\b"
				elseif nextc == "f" then
					s = s .. "\f"
				elseif nextc == "n" then
					s = s .. "\n"
				elseif nextc == "r" then
					s = s .. "\r"
				elseif nextc == "t" then
					s = s .. "\t"
				else
					s = s .. nextc
				end
				pos = pos + 2
			else
				s = s .. c
				pos = pos + 1
			end
		end
		return s
	end

	local function parse_number()
		local num = json_str:match("^-?%d+%.?%d*[eE]?[+-]?%d*", pos)
		assert(num, "Invalid number at position " .. pos)
		pos = pos + #num
		return tonumber(num)
	end

	local function parse_array()
		local arr = {}
		pos = pos + 1 -- skip "["
		skip_ws()
		if json_str:sub(pos, pos) == "]" then
			pos = pos + 1
			return arr
		end
		while true do
			table.insert(arr, parse_val())
			skip_ws()
			local c = json_str:sub(pos, pos)
			if c == "]" then
				pos = pos + 1
				break
			elseif c == "," then
				pos = pos + 1
			else
				error("Expected ',' or ']' at position " .. pos)
			end
		end
		return arr
	end

	local function parse_object()
		local obj = {}
		pos = pos + 1 -- skip "{"
		skip_ws()
		if json_str:sub(pos, pos) == "}" then
			pos = pos + 1
			return obj
		end
		while true do
			skip_ws()
			local key = parse_string()
			skip_ws()
			if json_str:sub(pos, pos) ~= ":" then
				error("Expected : after key at pos " .. pos)
			end
			pos = pos + 1
			obj[key] = parse_val()
			skip_ws()
			local c = json_str:sub(pos, pos)
			if c == "}" then
				pos = pos + 1
				break
			elseif c == "," then
				pos = pos + 1
			else
				error("Expected ',' or '}' in object at pos " .. pos)
			end
		end
		return obj
	end

	parse_val = function()
		skip_ws()
		local c = json_str:sub(pos, pos)
		if c == "{" then
			return parse_object()
		elseif c == "[" then
			return parse_array()
		elseif c == '"' then
			return parse_string()
		elseif c:match("[%d%-]") then
			return parse_number()
		elseif json_str:sub(pos, pos + 3) == "true" then
			pos = pos + 4
			return true
		elseif json_str:sub(pos, pos + 4) == "false" then
			pos = pos + 5
			return false
		elseif json_str:sub(pos, pos + 3) == "null" then
			pos = pos + 4
			return nil
		else
			error("Invalid Json at position: " .. pos)
		end
	end
	---@diagnostic disable-next-line: return-type-mismatch
	return parse_val()
end

function json.format(value, indentchar, indent)
	indent = indent or 0
	indentchar = indentchar or "    "
	local formatting = string.rep(indentchar, indent)

	if type(value) == "table" then
		local is_array = (#value > 0)
		local result = {}
		if is_array then
			table.insert(result, formatting .. "[")
			for i, v in ipairs(value) do
				table.insert(
					result,
					string.rep(indentchar, indent + 1)
						.. json.format(v, indentchar, indent + 1)
						.. (i < #value and "," or "")
				)
			end
			table.insert(result, formatting .. "]")
		else
			table.insert(result, "{")
			local n = 0
			for _ in pairs(value) do
				n = n + 1
			end
			local count = 0
			for k, v in pairs(value) do
				count = count + 1
				table.insert(
					result,

					string.rep(indentchar, indent + 1)
						.. json.escape_str(tostring(k))
						.. ": "
						.. json.format(v, indentchar, indent + 1)
						.. (count < n and "," or "")
				)
			end
			table.insert(result, formatting .. "}")
		end
		return table.concat(result, "\n")
	elseif type(value) == "string" then
		return json.escape_str(value)
	else
		return tostring(value)
	end
end
return json
