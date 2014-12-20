local data = {}
Data = data -- 让前面已经载入的资源可以被后续载入的资源使用

local libpath = love.util.libPath(...)
local require_path = ...

--[[ shaders ]]
local shader_path = libpath .. '/shader/'
data.shader = love.util.loadDirectoryFiles(
		shader_path, 
		{'c'},
		function(filename, short_name, extension)
			return love.graphics.newShader( shader_path .. filename )
		end
	)

--[[ font ]]
data.font = {}
data.font.big = love.graphics.newFont(50)
data.font.medium = love.graphics.newFont(20)

--[[ particle ]]
local path = ... .. '.particle'
data.particle = love.util.loadDirectoryFiles(
		path, 
		{'lua'},
		function(filename, short_name, extension)
			return require(path .. '.' .. short_name)
		end
	)

--[[ img ]]

-- 载入当前目录的所有.png文件
local path = libpath .. '/img'
data.img = {}
love.util.loadDirectoryFiles(
		path, 
		{'png'}, 
		function( filename, short_name, extension )
			love.static.loadImage( data.img, path, filename, short_name )
		end
	)
-- 载入当前所有.lua文件，确认没有对应的png文件后，认为是适量图
local path = libpath .. '/img'
love.util.loadDirectoryFiles(
		path, 
		{'lua'}, 
		function( filename, short_name, extension )
			local pngpath = path .. '/' .. short_name .. '.png'
			if not love.storage.fileExist(pngpath) then
				data.img[short_name] = require(require_path .. '.img.' .. short_name)
			end
		end
	)

--[[ levels ]]

data.levels = require(... .. '.levels')



--[[ anim ]]

local function LoadAnims(dirname, png_info)
	-- 载入所有图片
	local files = love.util.loadDirectoryFiles(
			dirname, 
			{'png'},
			function(filename, short_name, extension)
				assert(png_info[short_name])
				local img = love.graphics.newImage(dirname .. '/' .. filename)
				png_info[short_name].image = img
				return img
			end
		)
	return love.anim.loadAnims(files, png_info)
end

local anim_path = libpath .. '/anim'
data.anim = LoadAnims(anim_path, require(... .. '.anim.pnginfo'))

-- 载入适量动画
local anim_require_path = ... .. '.anim.'
love.util.loadDirectoryFiles(
		anim_path,
		{'lua'},
		function(filename, short_name, extension)
			if short_name ~= 'pnginfo' then
				data.anim[short_name] = require(anim_require_path .. short_name)
			end
		end
	)

--[[ components ]]

local path = ... .. '.components'
data.components = love.util.loadDirectoryFiles(
		path, 
		{'lua'},
		function(filename, short_name, extension)
			return require(path .. '.' .. short_name)
		end
	)


--[[ font ]]
-- nothing


--[[ prefabs ]]

local path = ... .. '.prefabs'
data.prefabs = love.util.loadDirectoryFiles(
		path, 
		{'lua'},
		function(filename, short_name, extension)
			return 
				function(...)
					local info = require(path .. '.' .. short_name)
					info.name = short_name
					return info
				end
		end
	)



--[[ sound ]]

local path = love.util.libPath(...) .. '/sound'
data.sound = love.util.loadDirectoryFiles(
		path, 
		{'mp3', 'wav', 'MP3'},
		function(filename, short_name, extension)
			return love.audio.newSource(path .. '/' .. filename)
		end
	)



--[[ states ]]

local path = ... .. '.states'
data.states = {}
love.util.loadDirectoryFiles(
		path,
		{'lua'}, 
		function(filename, short_name, extension) 
			love.state.load(path .. '.' .. short_name, data.states)
		end
	)



-- 最后，把生成好的data返回
return data
