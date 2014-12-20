math.randomseed( os.time() )

-- 引擎的编写需要使用的外部库
Class = require("lib.class")

-- 加载引擎的各个模块
local require_path = ...
love.filesystem.getDirectoryItems(
			string.gsub(require_path, "%.", '/'), 
			function(filename)
				if filename == 'init.lua' then return end
				local lua_file = require_path .. '.' .. filename
				require(lua_file)
			end
		)

-- 包裹一下require，先检测文件是否存在，以便增强错误检查。
local old_require = require
function require( ... )	
	if love.storage.exist( ... ) then
		return old_require( ... )
	end
end

function require_exist( ... )	
	if love.storage.exist( ... ) then
		return old_require( ... )
	else
		love.util.trace( "failed to require", ... )
		os.exit(-1)
	end
end


function require_force(...)
	local name = ...
	if love.storage.exist( name ) then
		package.loaded[name] = nil -- 强制重新加载
		return old_require( name )
	else
		love.util.trace( "failed to require", name )
	end
end
require_again = require_force
