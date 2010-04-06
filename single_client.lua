--[[
| Pontif�cia Universidade Cat�lica do Rio de Janeiro
| INF2545 - Sistemas Distribuidos	Prof.: Noemi
| Alunos: Danilo Moret
|		  Thiago M. C. marques
|
| Trabalho 1 - Tipos de servidores			  2010.1
--]]

require("sd_common")

-- Initializing instrumentation counters
local files = arg[1] or name or 20
local name = arg[2] or name or ""
local serv_addr = arg[3]
local serv_port = arg[4]

receive_files(files, "single_cli" .. name, serv_addr, serv_port)
