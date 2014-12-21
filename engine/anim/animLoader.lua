--[[
载入标准动画。
标准动画指的是包含clone()/getWidth()/getHeight()/draw()/update()函数的table。

动画可以是帧动画和矢量动画。
* 帧动画动画由Png_info来定义，定义了使用的png文件是哪个、png文件的哪些区域构成动画、动画的速度、动画的名称等。
* 矢量动画直接载入相应的lua文件即可。
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