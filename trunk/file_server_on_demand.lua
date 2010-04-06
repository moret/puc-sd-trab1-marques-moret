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
|       Sets a on-demand multiprocess server that sends a specified file to the client.
--]]

local socket = require("socket")
require("posix")
require("sd_common")

if debug then
    list_initial_param(arg)
end

-- Getting the server up
local server = server_up()

while true do
	-- Client connection recieval.
	local client = server:accept()
	local pid = posix.fork()
	if pid == 0 then -- Child process, pid stores the child's PID.
	    server:close() -- Closes socket that the child is not using.
	    send_file(client)
	    client:close()
	    os.exit() -- Child ends execution
	else -- Father process, pid ~= 0
	    client:close() -- Closes socket that the father is not using.
	end
end