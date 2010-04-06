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

if _debug then
    list_initial_param(arg)
end

-- Initializing instrumentation counters
local files = files or 20
local name = name or "mc"
local simultaneous_clients = simultaneous_clients or 4
local serv_addr = serv_addr or "localhost"

for cli=1, simultaneous_clients do
	pid = posix.fork()
	if pid ~= 0 then -- Child process
		local client_name = "multi_cli" .. name .. cli
		receive_files(files, client_name, serv_addr, serv_well_known_port)
		os.exit()
	end
end
