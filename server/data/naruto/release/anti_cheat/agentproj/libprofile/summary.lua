-- LuaProfiler
-- Copyright Kepler Project 2005-2007 (http://www.keplerproject.org/luaprofiler)
-- $Id: summary.lua,v 1.5 2007/08/22 21:05:13 carregal Exp $

-- Function that reads one profile file
function ReadProfile(file)

	local profile

	-- Check if argument is a file handle or a filename
	if io.type(file) == "file" then
		profile = file

	else
		-- Open profile
		profile = io.open(file)
		end

	-- Table for storing each profile's set of lines
	line_buffer = {}

	-- Get all profile lines
	local i = 1
	for line in profile:lines() do
		line_buffer[i] = line
		i = i + 1
    end

	-- Close file
	profile:close()
	return line_buffer
	end

-- Function that creates the summary info
function CreateSummary(lines, summary)

	local global_time = 0

	-- Note: ignore first line
	for i = 2, table.getn(lines) do
		word = string.match(lines[i], "[^\t]+\t[^\t]+\t([^\t]+)")
		local_time, total_time = string.match(lines[i], "[^\t]+\t[^\t]+\t[^\t]+\t[^\t]+\t[^\t]+\t([^\t]+)\t([^\t]+)")
        if not (local_time and total_time) then return global_time end
        if summary[word] == nil then
			summary[word] = {};
			summary[word]["info"] = {}
			summary[word]["info"]["calls"] = 1
			summary[word]["info"]["total"] = local_time
			summary[word]["info"]["func"] = word

		else
			summary[word]["info"]["calls"] = summary[word]["info"]["calls"] + 1
			summary[word]["info"]["total"] = summary[word]["info"]["total"] + local_time;
			end

		if tonumber(local_time) then
		global_time = global_time + tonumber(local_time);
		end
		end

	return global_time
	end

-- Global time
global_t = 0

-- Summary table
profile_info = {}

-- Check file type
local verbose = false
local filename
if arg[1] == "-v" or arg[1] == "-V" then
  verbose = true
  filename = arg[2]
else
  filename = arg[1]
end
if filename then
  file = io.open(filename)
else
  print("Usage")
  print("-----")
  print("lua summary.lua [-v] <profile_log>")
  os.exit()
end
if not file then
  print("File " .. filename .. " does not exist!")
  os.exit()
end
firstline = file:read(11)

-- File is single profile
if firstline == "stack_level" then

	-- Single profile
	local lines = ReadProfile(file)
	global_t = CreateSummary(lines, profile_info)

else

	-- File is list of profiles
	-- Reset position in file
	file:seek("set")

	-- Loop through profiles and create summary table
	for line in file:lines() do

		local profile_lines

		-- Read current profile
		profile_lines = ReadProfile(line)

		-- Build a table with profile info
		global_t = global_t + CreateSummary(profile_lines, profile_info)
		end

	file:close()
	end

-- Sort table by total time
sorted = {}
for k, v in pairs(profile_info) do table.insert(sorted, v) end
table.sort(sorted, function (a, b) 
	local a = tonumber(a["info"]["total"])
	local b = tonumber(b["info"]["total"])
	a = a and a or 0
	b = b and b or 0
	return a > b 
end)

-- Output summary

local colsize = {func=#'Func', average=#'Average per call', percent=#'%Time', calls=#'Calls', total=#'Total time'}
for k, v in pairs(sorted) do
	local average = v["info"]["total"] / tonumber(v["info"]["calls"])
	local percent = 100 * tonumber(v["info"]["total"]) / global_t
	v['average'] = average
	v['percent'] = percent
	
	colsize['func'] = math.max(#v["info"]["func"], colsize['func'])
	colsize['average'] = math.max(#tostring(v["average"]), colsize['average'])
	colsize['percent'] = math.max(#tostring(v["percent"]), colsize['percent'])
	colsize['calls'] = math.max(#tostring(v["info"]["calls"]), colsize['calls'])
	colsize['total'] = math.max(#tostring(v["info"]["total"]), colsize['total'])
end
for k, v in pairs(colsize) do
	colsize[k] = colsize[k] + 2
end

local function getstr(k, v)
	local l = colsize[k] - #tostring(v)
	return tostring(v) .. string.rep(' ', l)
end

if verbose then
	print(getstr('func', 'Func') .. getstr('calls', 'Calls') ..getstr('average', 'Average per call') ..getstr('total', 'Total time') ..getstr('percent', '%Time'))
else
	print(getstr('func', 'Func') .. getstr('total', 'Total time'))
end

for k, v in pairs(sorted) do
	if v["info"]["func"] ~= "(null)" then
		local average = v['average']
		local percent = v['percent']
		if verbose then
		  print(getstr('func', v["info"]["func"]) .. getstr('calls', v["info"]["calls"]) .. getstr('average', average) .. getstr('total', v["info"]["total"]) .. getstr('percent', percent))
		else
		  print(getstr('func', v["info"]["func"]) .. getstr('total', v["info"]["total"]))
		end
	end
end

