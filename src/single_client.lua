--[[
| Pontifícia Universidade Católica do Rio de Janeiro
| INF2545 - Sistemas Distribuidos	Prof.: Noemi
| Alunos: Danilo Moret
|		  Thiago M. C. marques
|
| Trabalho 1 - Tipos de servidores			  2010.1
--]]

require("sd_common")

-- Instrumentation: Lists initial parameters.
if _debug then
    list_initial_param(arg)
end

-- Initializing instrumentation counters
local files = files or 20
local name = name or "mc"
local serv_addr = serv_addr or "localhost"

receive_files(files, "single_cli" .. name, serv_addr, serv_well_known_port)
