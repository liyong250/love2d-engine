--[[
* 实现功能描述
	* 用图片作为背景。有多种效果可以选择。
* 目标Entity必须
* 属性
* 方法
	* start_changing_bk_color()
	* stop_changing_bk_color()
* 接受的事件
* 其他强制要求
* 用法示例
]]

local created = false

local function onupdate_repeat_moving(com, dt)
	local dx = com.direction_vector * love.math.vector(com.speed, 0)
	local dy = com.direction_vector * love.math.vector(0, com.speed)
	com.origin_x = com.origin_x + dx
	com.origin_y = com.origin_y + dy
	com.quad = love.graphics.newQuad(
		com.origin_x, com.origin_y, 
		love.graphics.getWidth(), -- graphics.getDimensions() won't work...
		love.graphics.getHeight(),
		com.img:getDimensions())
end

local function ondraw_repeat_moving_real(com)
	love.graphics.draw( com.img, com.quad, 
		0, 0, -- position
		0, 1, 1, -- rotation scale
		0, 0, -- start pos
		0, 0) -- shear
end
local function ondraw_repeat_moving(com)
	if com.quad then
		com.ondraw = ondraw_repeat_moving_real
	end
end

local function onremove_repeat_moving(com)
	created = false
end

--[[
picture
	使用love.graphics.newImage创建的图片
mode = nil
	* string类型，渲染图片的方式。取值列表：
		* nil 默认将图片会在在(0,0)处
		* stretch 将图片拉升并绘制到整个屏幕
		* repeat 从(0,0)处开始平铺图片
		* repeat_moving 从(0,0)处开始平铺，并且让整个背景出现移动效果
param = nil
	附加参数，根据mode而变化。mode取值对应的param取值为：
	* repeat_moving
		此参数必须设置为{dx=?,dy=?,speed=?}的形式。
		(dx,dy)表示移动方向，speed表示每秒移动的像素数。
]]
local function create(t, picture, mode, param)
	assert(not created, "The component bk_image can only be used once")
	
	local res = 
	{
		img = picture,
		param = param,
	}
	if mode == 'repeat_moving' then
		res.img:setWrap('repeat', 'repeat')
		res.origin_x = 0
		res.origin_y = 0

		res.direction_vector = love.math.vector(param.dx, param.dy)
		res.speed = param.speed

		res.onupdate = onupdate_repeat_moving
		res.ondraw = ondraw_repeat_moving
		res.onremove = onremove_repeat_moving
	--[[
	elseif not mode then

	elseif mode == 'stretch' then

	elseif mode == 'repeat' then
	]]
	else
		error("Unknown mode")
	end

	created = true
	return res
end

return create