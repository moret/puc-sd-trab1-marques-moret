--[[
	Written by Danilo Moret
--]]

local socket = require("socket")

-- Methods
function oneClient()
	local client = socket.connect("localhost", 1111)
	if not client then
		return nil, "Could not connect to server."
	end
	local sample, err = client:receive("*a")
	client:close()
	return sample, err
end

-- Test assemble
files = 100
progress_check_steps = 5
simultaneous_clients = 3

local total_time = 0
local total_files_received = 0
for i=1, files/progress_check_steps do
	local check_step_files = 0
	
	-- Execute check step.
	local start_time = os.time()
	for j=1, progress_check_steps do
		local sample, err = oneClient()
		if sample then
			check_step_files = check_step_files + 1
		else
			print(" ! Error while receiving file: " .. err)
		end
	end
	local end_time = os.time()
	
	-- Analyse executed check step.
	local loop_time = os.difftime(end_time, start_time)
	total_time = total_time + loop_time
	total_files_received = total_files_received + check_step_files
	print("Check step " .. i ..
	      ": Received " .. check_step_files ..
		  " of " .. progress_check_steps .. " files" ..
		  " in " .. loop_time .. "s.")
end

print("Total time: " .. total_time .. "s.\tAverage time per file: " .. total_time / files .. "s.")
print(total_files_received .. " received of " .. files .. " files" ..
	  "(" .. total_files_received/files * 100 .. "%).")
