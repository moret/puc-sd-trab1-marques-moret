local servers = {"mono", "ondemand", "pre5", "pre10"}
local files = {"10KB","100KB","1MB","10MB","100MB"}
local clients = {"1", "5", "10", "15"}
local runs = {"1", "2", "3"}

local number_pattern = "(%d+.%d+)"

local total_time_key = "Total time taken: "
local higher_time_key = "Higher time taken: "
local average_time_key = "Average time taken: "


-- CHANGE THIS FOR EACH SHEET
local current_sheet = average_time_key
--local current_sheet = higher_time_key
--local current_sheet = total_time_key


function calculate_mean_time(log_fn, time_key)
	fileHnd, errStr = io.open(log_fn)
	if errStr then return 0 end
	log_file = fileHnd:read("*a")

	km_start, km_end = string.find(log_file, time_key)
	time_sum = 0
	samples = 0

	while km_end do
		time_sum = time_sum + string.match(log_file, number_pattern, km_end)
		samples = samples + 1
		km_start, km_end = string.find(log_file, time_key, km_end)
	end

	if samples > 0 then return (time_sum / samples) else return 0 end
end

---[[
for sn, server in ipairs(servers) do
	for fs, file in ipairs(files) do
		folder = "../results/moret/moret-logs-" .. server .. "-" .. file .. "/"
		for cn, client in ipairs(clients) do
			for rn, run in ipairs(runs) do
				if server == "pre5" or server == "pre10" then
					fn = "moret-servpre-cli" .. client .. "-run" .. run .. ".log"
					--print(folder .. fn)
					io.write(calculate_mean_time(folder .. fn, current_sheet) .. " \t")
				else
					fn = "moret-serv" .. server .. "-cli" .. client .. "-run" .. run .. ".log"
					--print(folder .. fn)
					io.write(calculate_mean_time(folder .. fn, current_sheet) .. " \t")
				end
			end
		end
		print()
	end
	print()
end
--]]
