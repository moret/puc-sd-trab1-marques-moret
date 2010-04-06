--[[
| Pontif�cia Universidade Cat�lica do Rio de Janeiro
| INF2545 - Sistemas Distribuidos	Prof.: Noemi
| Alunos: Danilo Moret
|		  Thiago M. C. marques
|
| Trabalho 1 - Tipos de servidores			  2010.1
--]]

--[[
| File Description:
|       This file holds common methods and constants to all servers and clients, ensuring they are using
|		similar methods.
|
| Variables:
|       filepath - Path to the file to be sent by the server. Default is "10MB.txt".
|       chunk_size - Maximum size of each chunk to be sent to the client. Default is 10KB.
--]]

local socket = require("socket")
require("posix")

-- File size constants.
local KB_const = 1024            -- Constant to convert KB in bytes.
local MB_const = 1024 * KB_const -- Constant to convert MB in bytes.

local size_10KB =   10 * KB_const
local size_100KB = 100 * KB_const
local size_1MB =     1 * MB_const
local size_10MB =   10 * MB_const
local size_100MB = 100 * MB_const

-- Variables initialization
local filepath = arg[1] or filepath or "10MB.txt" -- Path to file to be sent to clients.
local serv_well_known_port = 1111

-- Initializing instrumentation counters
local instrumentation_steps = 5

-- Instrumentation: Lists initial parameters.
function list_initial_param(arg)
    if arg then
	print("-- Initial parameters --")
	for key, val in ipairs(arg) do
	    print("Arg " .. key .. ": " .. val)
	end
	print("-- End of Initial parameters --")
    else
	print("-- No initial parameters passed (arg = nil)")
    end
    
end

-- Print a log message in the standard output. Format is: "[time] name: message". Returns the time.
function time_log(message, name, end_time)
    end_time = end_time or socket.gettime() 
    local header = "[" .. end_time .. "] "
    if name then
	header = header .. name .. ": "
    end

    print(header .. message)
    return end_time
end

function elapsed_time_log(message, name, start_time, end_time)
    assert(start_time, " ! Error - Start time must not be nil.")

    end_time = end_time or socket.gettime()
    local elapsed_time = end_time - start_time
    message = message .. " (elapsed time: " .. elapsed_time .. ")"
    return time_log(message, name, end_time)
end

-- Getting server up on well known port.
function server_up()
	local server, server_error = socket.bind("*", serv_well_known_port)
	assert(server, " ! Error - Could not create server. " .. (server_error or ""))
	local ip, port = server:getsockname()
	time_log("Server listening on port " .. port)
	return server
end
	
-- File sending to client.
function send_file(client)
	local _file = io.open(filepath, "r")
	if _file then
		client:send(_file:read("*all"))
		_file:close()
		if debug then time_log("Transferred " .. filepath .. " file.") end
	else
		time_log("ERROR! File " .. filepath .. " could not be opened. Sending aborted.")
	end
end

-- File receiveng from server.
function client_run(name, serv_addr, serv_port)
	-- Parameter's default values initialization.
	serv_addr = serv_addr or "localhost"
	serv_port = serv_port or serv_well_known_port

	-- Sets the socket.
	local client = socket.tcp()
	client:settimeout(30)

	-- Start connection.
	local connection_req_time = time_log("Starting connection.", name)
	client:connect(serv_addr, serv_port)
	local connect_sucess_time = elapsed_time_log("Connection stabilished.", name, connection_req_time)
	if not client then
		local error_msg = "Could not connect to server at address: " .. serv_addr .. " port: " .. port
		return nil, error_msg
	end

	-- Start file receival.
	local receival_beg_time = time_log("Starting file receival.", name)
	local sample, err = client:receive("*a")
	client:close()
	local receival_end_time = elapsed_time_log("File receival complete.", name, receival_beg_time)
	local total_time = elapsed_time_log("Total time taken by client.", name, connection_req_time, receival_end_time)
	
	return sample, err
end

-- Receive files loop
function receive_files(files, name, serv_addr, serv_port)
	local files_per_step = files / instrumentation_steps
	local total_time = 0
	local higher_time = 0

	for j=1, instrumentation_steps do
		-- Using socket.gettime to obtain better precision, i.e., not in seconds only
		-- local start_time = os.time()
		local start_time = socket.gettime()
		for i=1, files_per_step do
			-- Execute check step.

			local sample, err = client_run(name, serv_addr, serv_port)
			if not sample then
			    print(" ! Error - File not received. " .. (err or ""))
			end
		end

		local end_time = socket.gettime()
		local elapsed_time = end_time - start_time
		if elapsed_time > higher_time then
		    higher_time = elapsed_time
		end
		total_time = total_time + elapsed_time

		-- When using socket.gettime, the method os.difftime is no longer usueful, so we're subtracting directly. It might not work the same way on differente OS's
		-- print("Sent " .. files_per_step .. " files in " .. os.difftime(os.time(), start_time) .. "s")
		print(name .. " received " .. files_per_step .. " files in " .. elapsed_time .. "s")
	end
	
	 print(name .. "| Files transfered: " .. files .. "\t Total time taken: " .. total_time)
	 print("Higher time taken: " .. higher_time .. "\t Average time taken: " .. total_time/files)
end
