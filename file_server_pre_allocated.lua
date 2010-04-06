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

if _debug then
    list_initial_param(arg)
end

-- Total processes
local num_proc = num_proc or 5

-- Getting the server up
local server = server_up()
local pid, proc_num

-- Setting que process pool.
for i = 1, num_proc - 1 do
	proc_num = i
	pid = posix.fork()
	if pid == 0 then -- Child process.
		break
	end
end

-- Listening to client requests.
while true do
	-- Client connection recieval.
	local client = server:accept()
	send_file(client)
	client:close()
end
