--[[
* 实现功能描述
	* 下雪效果的实现
* 目标Entity必须
* 属性
* 方法
* 接受的事件
* 其他强制要求
* 用法示例
]]

local function ondraw(com)
	love.graphics.push()
	love.graphics.origin()
	love.graphics.draw(
		com.particle, love.window.getWidth() / 2 - 100, 
		-50,
		com.rotation,
		com.scale, com.scale)
	love.graphics.pop()
end

local function onupdate(com, dt)
	com.particle:update(dt)
end

--[[
image 雪花的图片
particle 下雪所使用的粒子系统初始化器（一个函数，接受并初始化一个ParticleSystem）
max = 100 最多多少雪花
rotation = 0 旋转下雪的角度
scale = 1 下雪场景的缩放
]]
local function create(entity, image, particle, max, rotation, scale)
	max = max or 100
	rotation = rotation or 0
	scale = scale or 1
	local ps = love.graphics.newParticleSystem(image, max)
	local t = 
	{
		max = max,
		rotation = rotation,
		scale = scale,
		particle = ps,

		ondraw = ondraw,
		onupdate = onupdate,
	}
	-- 用参数初始化该粒子系统
	particle(ps)
	-- 在一条线上“下雪”
	ps:setAreaSpread('normal', love.window.getWidth() / 2 + 100, 0)
	return t
end

return create