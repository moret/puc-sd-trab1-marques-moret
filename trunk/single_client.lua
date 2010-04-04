--[[
| Pontifícia Universidade Católica do Rio de Janeiro
| INF2545 - Sistemas Distribuidos	Prof.: Noemi
| Alunos: Danilo Moret
|		  Thiago M. C. marques
|
| Trabalho 1 - Tipos de servidores			  2010.1
--]]

local socket = require("socket")
require("sd_common")

-- Initializing instrumentation counters
local files = 20
local name = arg[1] or ""

for i=1, files do
	-- Execute check step.
	local sample, err = client_run("single_client" .. name)
	assert(sample, " ! Error while receiving file: ")
end
