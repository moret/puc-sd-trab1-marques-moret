--[[
| Pontifícia Universidade Católica do Rio de Janeiro
| INF2545 - Sistemas Distribuidos	Prof.: Noemi
| Alunos: Danilo Moret
|		  Thiago M. C. marques
|
| Trabalho 1 - Tipos de servidores			  2010.1
--]]

require("posix")
require("sd_common")

-- Initializing instrumentation counters
local files = arg[1] or name or 20
local name = arg[2] or name or ""
local simultaneous_clients = arg[3] or simultaneous_clients or 4

for cli=1, simultaneous_clients do
	pid = posix.fork()
	if pid ~= 0 then
		receive_files(files, "multi_cli" .. name .. cli)
		break
	end
end
