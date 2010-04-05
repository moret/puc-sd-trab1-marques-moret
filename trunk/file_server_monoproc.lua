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
--]]

local socket = require("socket")
require("sd_common")

-- Getting the server up
local server = server_up()

while true do
	-- Client connection recieval.
	local client = server:accept()
	send_file(client)
	client:close()
end
