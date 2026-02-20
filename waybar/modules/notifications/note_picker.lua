#!/usr/bin/env lua

JSON = require("json")

HOME = os.getenv("HOME")
CACHE_DIR = HOME .. "/.cache/notification_logger"
CACHE_FILE = CACHE_DIR .. "/notes.json"

local get_notes = function()
	local handle = io.popen("dunstctl history 2>/dev/null")
	if not handle then return {} end
	local data = handle:read("*a")
	handle:close()

	local js_data = JSON.parse(data)
	---@diagnostic disable-next-line: need-check-nil
	local notes = js_data.data[1] or {}

	---@type Notification[]
	local notifications = {}
	for i = #notes, 1, -1 do
		local note = notes[i]
		---@type Notification
		local notification = {
			Id = note.id.data,
			Summary = note.summary.data,
			Body = note.body.data,
			Message = note.message.data,
			AppName = note.appname.data,
			IconPath = note.icon_path.data,
			Urgency = note.urgency.data,
			Timestamp = note.timestamp.data,
		}
		table.insert(notifications, notification)
	end
	return notifications
end

local notes = get_notes()
local items = {}
for _, note in ipairs(notes) do
	table.insert(
		items,
		string.format("%d | %s: %s", note.Id, note.Summary, note.Body)
	)
end

local input_str = table.concat(items, "\n")
local tmpfile = os.tmpname()
local f = io.open(tmpfile, "w")
if not f then
	error(
		"Unable to open tempfile ["
			.. tmpfile
			.. "] with read permission"
	)
end
f:write(input_str)

local cmd = "wofi --dmenu --prompt 'Notifications:' < " .. tmpfile
local handle = io.popen(cmd, "r")
if not handle then return end

local selection = handle:read("*l")
handle:close()
os.remove(tmpfile)

if selection then
	local id = tonumber(selection:match("%d+"))
	print(id)
	for _, note in ipairs(notes) do
		if note.Id == id then
			print(string.format("%d", note.Id))
			-- show the selected popup
			os.execute("dunstctl history-pop " .. note.Id)
		end
	end
end
