--[[
Author: godguy
Function: load all *.lua in the given directory.
载入“游戏根目录/dirname”目录下的所有.lua文件；
例如包含 file1.lua file2.lua，则返回如下结果：
{ file1 = require("file1.lua"), file2 = require("file2.lua")}；
在每次require后，如果相对模块进行一些操作，可以设置postLoadFunc，其函数就是刚刚得到的模块；
如果有不想要包含的文件，则作为可变参数传进来。
]]
local function LoadDirectory(dirname, postloadFunc, ...)
	local all_modules = {}
	local ignore_files = {}
	for _, ignore_filename in ipairs({...}) do
		ignore_files[ignore_filename] = true
	end
	love.filesystem.getDirectoryItems(dirname, function(filename)
			if ignore_files[filename] then return end
			local begin = string.find(filename, '.lua')
			if begin then
				local module_name = string.sub(filename, 0, begin - 1)
				all_modules[module_name] = require(module_name)
				if postloadFunc then
					postloadFunc(module_name, all_modules[module_name])
				end
			end
		end)
	return all_modules
end
return LoadDirectory
