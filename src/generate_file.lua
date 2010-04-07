--[[
| Pontifícia Universidade Católica do Rio de Janeiro
| INF2545 - Sistemas Distribuidos	Prof.: Noemi
| Alunos: Danilo Moret
|		  Thiago M. C. marques
|
| Trabalho 1 - Tipos de servidores			  2010.1
--]]


local KB_const = 1024            -- Constant to convert KB in bytes.
local MB_const = 1024 * KB_const -- Constant to convert MB in bytes.

--[[
| Create a text file of specified size (in bytes).
|
| @param:
|	filename - Name of the file to be created. Must be at least 0.
|	size - Size (em bytes) of the file to be created.
|
| @return: Created file. Returns 'nil' if the file could not be created.
--]]
function generate_file(filename, size)
	-- Tests paramethers asserts.
	assert(size >= 0, "Invalid size. Must be at least 0.")
	
	
	newfile = io.open(filename, "w")
	if not newfile then
		return nil, "Could not open file."
	end
	
	-- Fills the file.
	for i = 1, size do
		newfile:write(i%10)
	end
	
	newfile:flush()
	return newfile
end


--[[
| Creates all necessary files for client/server testing.
|
| Files of the following sizes are generated: 10KB, 100KB, 1MB, 10MB, 100MB.
--]]
function generate_all_files()	
	generate_file( "10KB.txt",  10*KB_const)
	generate_file("100KB.txt", 100*KB_const)
	generate_file(  "1MB.txt",   1*MB_const)
	generate_file( "10MB.txt",  10*MB_const)
	generate_file("100MB.txt", 100*MB_const)
end


--[[
| main - calls the generator for all files when called from the command line.
--]]

generate_all_files()
