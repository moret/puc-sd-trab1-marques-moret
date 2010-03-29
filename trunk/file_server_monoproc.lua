--[[
| Pontifícia Universidade Católica do Rio de Janeiro
| INF2545 - Sistemas Distribuidos	Prof.: Noemi
| Alunos: Danilo Moret
|		  Thiago M. C. marques
|
| Trabalho 1 - Tipos de servidores			  2010.1
--]]


--[[
| File Description:
| 	Sets a monoprocess server that sends a specified file to the client.
| 	File is sent in series of chuncks.
|
| Variables:
|	filepath - Path to the file to be sent by the server. Default is "file.txt".
|	chunk_size - Maximum size of each chunk to be sent to the client. Default is 10KB.
--]]

local socket = require("socket")

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

-- Getting the server up
local server = socket.bind("*", 1111)
local ip, port = server:getsockname()
print("Listening on port " .. port)

while true do
	-- Client connection recieval.
	local client = server:accept()
	print("Connected at " .. os.time())
	client:settimeout(100)

	-- File sending to client.
	_file = io.open(filepath, "r")
	if _file then
		chunk = _file:read(chunk_size)
		while chunk do
			client:send(chunk)
			chunk = _file:read(chunk_size)
		end

		_file:close()
		print("Sent file " .. filepath .. " at " .. os.time())
	else
		print("File " .. filepath .. " could not be opened. Sending aborted.")
	end

	client:close()
end
