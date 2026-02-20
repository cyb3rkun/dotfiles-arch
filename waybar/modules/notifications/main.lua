#!/usr/bin/env lua

---@class Notification
---@field Id number
---@field Summary string
---@field Body string
---@field Message string
---@field AppName string
---@field IconPath string
---@field Urgency string
---@field Timestamp number

-- WARN: clone ljson to /usr/share/lua/5.4/json/ for this to work!
package.path = package.path..";/home/cyb3r/.config/waybar/modules/lua/json/?.lua"
JSON = require("json")
HOME = os.getenv("HOME")
CACHE_DIR = HOME .. "/.cache/notification_logger"
CACHE_FILE = CACHE_DIR .. "/notes.json"

---@return Notification[]
local function get_notes()
	---@type Notification[]
	local notes = {}
	local file = io.open(CACHE_FILE, "r")
	if not file then
		error("Couln't read cache file: " .. CACHE_FILE)
	end
	local data_str = file:read("*a")
	local data_table = JSON.parse(data_str)

	for _, note in ipairs(data_table) do
		---@type Notification
		local n = {
			Id = note.Id,
			Summary = note.Summary,
			Body = note.Body,
			Message = note.Message,
			AppName = note.AppName,
			IconPath = note.IconPath,
			Urgency = note.Urgency,
			Timestamp = note.Timestamp,
		}
		table.insert(notes, n)
	end
	-- print(JSON.format(data_table, "\t"))
	file:close()

	return notes
end

local notes = get_notes() or {}
local class = (function(count)
	if count == 0 then
		return "ok"
	else
		local severity = math.ceil(count / 2)
		if severity == 1 then
			return "low"
		elseif severity == 2 then
			return "med"
		else
			return "high"
		end
	end
end)(#notes)

local tooltip = ""

for _, note in ipairs(notes) do
	tooltip = tooltip .. note.AppName .. "\n"
	if note.Body and note.Body ~= "" then
		tooltip = tooltip .. "  " .. note.Body:gsub("\n", " ") .. "\n"
	end
	if note.Message and note.Message ~= "" then
		tooltip = tooltip
			.. "  "
			.. note.Message:gsub("\n", " ")
			.. "\n"
	end
	if note.Urgency then
		tooltip = tooltip
			.. "  "
			.. "Urgency: "
			.. tostring(note.Urgency)
			.. "\n"
	end
	tooltip = tooltip .. "\n"
end

print(JSON.encode({
	text = #notes > 0 and #notes or "0",
	tooltip = tooltip,
	class = class,
}))
io.flush()
