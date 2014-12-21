love.util = require('thirdparty.lume')
love.util.makeConst = require("lib.const")

-- 路径转换
love.util.libPath =
	function(path)
		return string.gsub(path, "%.", '/')
	end
love.util.requirePath =
	function(path)
		return string.gsub(path, '/', "%.")
	end

-- 遍历文件夹下的文件
function love.util.loadDirectoryFiles(path, types, loader)
	local res = {}
	local function handler(filename)
		-- 获取文件短名和后缀名
		local begin
		if types == 'all' then
			begin = string.find(filename, ".%w*$")
		else
			for _, filetype in pairs(types) do
				begin = string.find(filename, '.' .. filetype .. '$')
				if begin then break end
			end
		end
		local short_name, extension
		if begin then
			short_name = string.sub(filename, 0, begin - 1)
			extension = string.sub(filename, begin)
		end
		-- 如果成功获取到短名，则载入该文件
		if short_name then
			local short_name = string.sub(filename, 0, begin - 1)
			res[short_name] = loader(filename, short_name, extension)
		end
	end
	love.filesystem.getDirectoryItems(
			love.util.libPath(path), 
			handler
		)
	return res
end

-- 点的位置是否在窗口内部
-- 重载的形式 intersect( point )
function love.window.intersect( x, y )
	local w, h = love.window.getDimensions()
	if type(y) ~= 'number' then
		local point = x
		x, y = point.x, point.y
	end
	if x < 0 or y < 0 or x > w or y > h then return true end
end

-- 相交判断 
function love.util.inRect(px, py, x, y, w, h)
	if px > x and px < x + w and py > y and py < y + h then return true end 
end

