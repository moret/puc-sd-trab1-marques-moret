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
|       Sets a pre-allocated multiprocess server that sends a specified file to
|		the client.
|
| Variables:
|       chunk_size - Maximum size of each chunk to be sent to the client. Default is 10KB.
|		num_proc - Number of processes to be pre-allocated. Default is 5.
--]]

local socket = require("socket")
require("posix")
require("sd_common")

-- Total processes
num_proc = arg[2] or 5

-- Getting the server up
local server = server_up()
local pid

-- Setting que process pool.
for i = 1, num_proc - 1 do
	pid = posix.fork()
	if pid == 0 then -- Child process.
		break
	end
end

-- Listening to client requests.
while true do
	-- Client connection recieval.
	local client = server:accept()
	send_file(client, "server_pre")
	client:close()
end
