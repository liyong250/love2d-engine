--[[
* 实现功能描述
	* 改变整个屏幕的背景色
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
local color = {110, 110, 0}
local handler

local function onupdate(dt)

end

local function ondraw()
	love.graphics.setBackgroundColor(unpack(color))
end

local function startChangingColor()
	local timer = love.state.current().timer
	local aimColor = {255 * math.random(), 255 * math.random(), 255 * math.random()}
	handler = timer:tween(
			2, -- duration
			color, 
			aimColor,
			'linear',
			function()
				startChangingColor()
			end
		)
end

local function onremove(com)
	local timer = love.state.current().timer
	created = false
	love.graphics.setBackgroundColor(0, 0, 0, 0)
	if handler then
		timer:cancel(handler)
	end
end

local function create(t, mode)

	assert(not created, "The component bk_color can only be used once")

	local res =
	{	
		onupdate = onupdate,
		ondraw = ondraw,
		onremove = onremove,
	}

	t:bindcall('start_changing_bk_color', 
		function()
			startChangingColor()
		end)
	t:bindcall('stop_changing_bk_color',
		function()
			local timer = love.state.current().timer
			timer:cancel(handler)
		end)

	created = true
	return res
end

return create