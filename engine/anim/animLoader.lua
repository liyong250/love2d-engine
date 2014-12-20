--[[
GG
20141018
]]

local function LoadAnims(files, png_info)
	-- 根据配置信息，生成动画
	local allanims = {}
	for filename, fileinfo in pairs(png_info) do
		local img = fileinfo.image
		local g = love.anim.newGrid(img:getWidth() / fileinfo.cols, img:getHeight() / fileinfo.rows, 
			img:getWidth(), img:getHeight())
		if fileinfo['anims'] then
			for animname, animinfo in pairs(fileinfo['anims']) do
				local time = animinfo.time or fileinfo.time
				local animName = filename .. '_' .. animname
				allanims[animName] = 
					love.anim.newAnimation(files[filename], g(unpack(animinfo.tiles)), time)
				love.util.trace("Loading animation", animName)
			end
		else
			allanims[filename] = 
				love.anim.newAnimation(files[filename], g(unpack(fileinfo.tiles)), fileinfo.time)
			love.util.trace("Loading animation", filename)
		end
	end
	return allanims
end
return LoadAnims