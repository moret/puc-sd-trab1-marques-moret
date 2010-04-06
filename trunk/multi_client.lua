--[[
| Pontif�cia Universidade Cat�lica do Rio de Janeiro
| INF2545 - Sistemas Distribuidos	Prof.: Noemi
| Alunos: Danilo Moret
|		  Thiago M. C. marques
|
| Trabalho 1 - Tipos de servidores			  2010.1
--]]

require("posix")
require("sd_common")

if debug then
    list_initial_param(arg)
end

-- Initializing instrumentation counters
local files = arg[1] or name or 20
local name = arg[2] or name or ""
local simultaneous_clients = arg[3] or simultaneous_clients or 4
local serv_addr = arg[4]
local serv_port = arg[5]

for cli=1, simultaneous_clients do
	pid = posix.fork()
	if pid ~= 0 then -- Child process
		local client_name = "multi_cli" .. name .. cli
		receive_files(files, client_name, serv_addr, serv_port)
		os.exit()
	end
end
