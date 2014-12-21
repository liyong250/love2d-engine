math.randomseed( os.time() )

-- 引擎的编写需要使用的外部库
Class = require("lib.class")

-- 加载引擎的各个模块
local require_path = ...
love.filesystem.getDirectoryItems(
			string.gsub(require_path, "%.", '/'), 
			function(filename)
				if string.find(filename, "%.") then return end -- 只处理文件夹
				local lua_file = require_path .. '.' .. filename
				require(lua_file)
			end
		)

--[[
包裹一下require，先检测文件是否存在，以便增强错误检查。
]]
-- 安全的require。如果require的东西不存在，则返回nil。
function try_require( ... )
	if love.storage.exist( ... ) then
		return require( ... )
	end
end
-- 强制重新载入。如果要载入的东西不存在则报警告。
function require_again(...)
	local name = ...
	if love.storage.exist( name ) then
		package.loaded[name] = nil -- 强制重新加载
		return require( name )
	else
		love.util.trace( "failed to require", name )
	end
end
