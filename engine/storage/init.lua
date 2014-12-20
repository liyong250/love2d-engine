
local storage = {}

local function save(filename, obj)
	local file = io.open(filename, 'w')
	file:write(love.storage.serialize(obj))
	file:close()
end

-- 判断require是否会成功
function storage.exist(filepath)
	local path = love.util.libPath( filepath ) .. '.lua'
	local file = io.open( path, 'r' ) -- 读一下，判断是否存在
	if file then
		file:close()
		return true
	else
		local path = love.util.libPath( filepath ) .. '/init.lua'
		local file = io.open( path, 'r' ) -- 读一下，判断是否存在
		if file then
			file:close()
			return true
		end
	end
end

-- 判断文件是否存在
function storage.fileExist(filepath)
	local file = io.open( filepath, 'r' ) -- 读一下，判断是否存在
	if file then
		file:close()
		return true
	end
end

-- 保存存档
function storage.save(key, obj)
	local filename = './save/' .. key .. '.lua'
	local file = io.open(filename, 'w')
	file:write(love.storage.serialize(obj))
	file:close()
end
function storage.load(key)
	local path = 'save.' .. key
	return require_force( path )
end
function storage.remove(key)
	local path = 'save/' .. key .. '.lua'
	os.remove(path)
end

love.storage = storage
love.storage.serialize = require('thirdparty.ser')