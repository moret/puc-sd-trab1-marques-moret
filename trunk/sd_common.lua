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
local chunk_size = chunk_size or size_10KB
local serv_well_known_port = 1111

-- Initializing instrumentation counters
local debug_mode = false
local instrumentation_steps = 5

-- Getting server up on well known port.
function server_up()
	local server, server_error = socket.bind("*", serv_well_known_port)
	assert(server, " ! Error - Could not create server. " .. (server_error or ""))
	local ip, port = server:getsockname()
	print("Listening on port " .. port)
	return server
end
	
-- File sending to client.
function send_file(client)
	local _file = io.open(filepath, "r")
	if _file then
		client:send(_file:read("*all"))
		_file:close()
		if debug_mode then print("Transferred " .. filepath .. " file at " .. socket.gettime() .. "s") end
	else
		print("ERROR! File " .. filepath .. " could not be opened. Sending aborted.")
	end
end

-- File receiveng from server.
function client_run(name, serv_addr, serv_port)
	-- Parameter's default values initialization.
	serv_addr = serv_addr or "localhost"
	serv_port = serv_port or serv_well_known_port

	local client = socket.connect(serv_addr, serv_port)
	if not client then
		return nil, "Could not connect to server."
	end
	local sample, err = client:receive("*a")
	client:close()
	if debug_mode then print(name .. " received " .. filepath .. " file at " .. socket.gettime() .. "s") end
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
			assert(sample, " ! Error while receiving file: " .. (err or ""))
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
	
	 print("Files transfered: " .. files .. "\t Total time taken: " .. total_time)
	 print("Higher time taken: " .. higher_time .. "\t Average time taken: " .. total_time/files)
end
