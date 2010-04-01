--[[
| Pontifícia Universidade Católica do Rio de Janeiro
| INF2545 - Sistemas Distribuidos       Prof.: Noemi
| Alunos: Danilo Moret
|                 Thiago M. C. marques
|
| Trabalho 1 - Tipos de servidores                        2010.1
--]]




--[[
| File Description:
|       Sets a on-demand multiprocess server that sends a specified file to the client.
|       Files are sent in series of chuncks.
|
| Variables:
|       filepath - Path to the file to be sent by the server. Default is "file.txt".
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
local filepath = filepath or "file.txt" -- Path to file to be sent to clients.
local chunk_size = chunk_size or size_10KB


function send_file(client)
    local _file = io.open(filepath, "r")
    if _file then
	local chunk = _file:read(chunk_size)
	while chunk do
	    client:send(chunk)
	    chunk = _file:read(chunk_size)
	end


	_file:close()
	print("Sent file " .. filepath .. " at " .. os.time())
    else
	print("File " .. filepath .. " could not be opened. Sending aborted.")
    end
end


-- Getting the server up
local server, server_error = socket.bind("*", 1111)
assert(server, " ! Error - Could not create server. " .. (server_error or ""))

local ip, port = server:getsockname()
print("Listening on port " .. port)


while true do
        -- Client connection recieval.
        local client = server:accept()
        print("Client ", client, " connected at " .. os.time())
	
	local pid = posix.fork()

	if pid ~= 0 then -- Father process, pid stores the child's PID.
	    client:close() -- Closes socket that the father is not using.
	else -- Child process, pid = 0
	    server:close() -- Closes socket that the child is not using.

	    client:settimeout(100)

	    send_file(client)

	    client:close()
	    os.exit() -- Child ends execution
	end

end