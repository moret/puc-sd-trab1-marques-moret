--[[
	Written by Danilo Moret
--]]

local socket = require("socket")

-- Assembling the file
size_10k = 10000
size_100k = 100000
size_1M = 1000000
size_100M = 100000000

sample_size = size_100M
chunk_size = size_10k
chunk = ""

math.randomseed(os.time())

for i=1,chunk_size do
	chunk = (chunk .. math.random(0, 9))
end

-- Getting the server up
local server = socket.bind("*", 1111)
local ip, port = server:getsockname()
print("Listening on port " .. port)

while 1 do
	local client = server:accept()
	print("Connected at " .. os.time())
	client:settimeout(100)
	for i=1,sample_size/chunk_size do
		client:send(chunk)
	end
	client:close()
	print("Sent " .. sample_size .. " bytes at " .. os.time())
end

