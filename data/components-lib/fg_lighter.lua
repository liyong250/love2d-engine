--[[
* 实现功能描述
	* 黑夜效果和黑夜的光照效果的实现
* 目标Entity必须
* 属性
* 方法
	* 对mask角色来说：
		* intoDay()
		* intoNight()
	* 对lighter角色来说：
		* light_on()
		* light_off()
		* light_switch()
* 接受的事件
* 其他强制要求
* 用法示例
]]


local canvas -- 营造夜晚效果的画布
local created = false -- mask模式只能被添加一次
local lights -- 火光列表（表，含有pos属性即可）

local dayLight -- 白天的颜色
local nightLight -- 夜晚的颜色
local curLight -- 当前颜色（用来实现渐变）

local intoNightTimer
local intoDayTimer

local function cancelTimers()
	local timer = love.state.current().timer
	timer:cancel(intoDayTimer)
	timer:cancel(intoNightTimer)
end

local function intoNight()
	local timer = love.state.current().timer
	cancelTimers()
	intoNightTimer = timer:tween(
		5,
		curLight,
		nightLight
		)
end

local function intoDay()
	local timer = love.state.current().timer
	cancelTimers()
	intoDayTimer = timer:tween(
		40,
		curLight,
		dayLight
		)
end

local function onremove(com)
	if com.role == 'mask' then
		canvas = nil
		created = false
		lights = nil
		cancelTimers()
	end
end


local function ondraw()
	love.graphics.push()
	love.graphics.origin()

	-- 画到画布上去
	love.graphics.setCanvas(canvas)
	canvas:clear(curLight[1], curLight[2], curLight[3], 100)
	love.graphics.setBlendMode('additive')
	for light in pairs(lights) do
		local world_x, world_y = light.owner:attr('pos')
		local owner_w, owner_h = light.owner:attr('size')
		world_x = world_x - owner_w / 2
		world_y = world_y - owner_h / 2
		local screen_x, screen_y = love.gameworld:bindcall('world2ScreenCoords', world_x, world_y)
		local w, h = light.light:getWidth(), light.light:getHeight()
		local scale = 1.3
		local x, y = screen_x - w * scale / 2, screen_y - h * scale / 2
		light.light:draw(x, y, 0, scale, scale)
	end

	-- 画到屏幕上
	love.graphics.setCanvas()
	love.graphics.setBlendMode('multiplicative')
	love.graphics.draw(canvas, 0, 0)

	love.graphics.setBlendMode('alpha')
	love.graphics.pop()
end

local function onupdate(com, dt)
	for light in pairs(lights) do
		light.light:update(dt)
	end
end

local function mask(entity, t)
	assert(not created, "Lighter with role 'mask' can only be created once")

	canvas = love.graphics.newCanvas()
	created = true
	lights = {}
	light = 255

	dayLight = {255, 200, 200}
	nightLight = {2, 2, 2}
	curLight = {255, 200, 200}

	t.ondraw = ondraw
	t.onupdate = onupdate
	t.onremove = onremove

	entity:listen("intoNight", intoNight)
	entity:listen("intoDay", intoDay)
end

local function light(entity, t)
	local light = 
	{
		owner = entity,
		light = Data.anim.light:clone()
	}

	entity:listen('light_on',
		function()
			lights[light] = true
		end)
	entity:listen('light_off',
		function()
			lights[light] = nil
		end)
	entity:listen('light_switch',
		function()
			if lights[light] then
				lights[light] = nil
			else
				lights[light] = true
			end
		end)
end

local function create(entity, role)
	local res =
	{
		role = role,
	}
	if role == 'mask' then
		mask(entity, res)
	elseif role == 'light' then
		light(entity, res)
	else
		error("Unrecognized role", role)
	end
	return res
end

return create