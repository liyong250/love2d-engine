--[[
* 实现功能描述
	* 使实体定时自动向某个方向进行移动（例如贪吃蛇的移动）
* 目标Entity必须
* 属性
	* periodic_move_delay RW, ( number )
	* periodic_move_direction RW, ( direction_x, direction_y )
* 方法
* 产生的事件
	* move( direction_x, direction_y )
* 接受的事件
* 其他强制要求
* 用法示例
]]
local function onremove(com)
	love.ui.current().timer:cancel(com.timer_handler)
end

local function create(owner, delay, dx, dy)
	local res = {
		onremove = onremove,

		owner = owner,
	}
	
	delay = delay or 1
	dx = dx or 1
	dy = dy or 0

	local timer = love.state.current().timer
	res.timer_handler = timer:addPeriodic(
		delay,
		function()
			owner:emit('move', dx, dy)
		end)
	owner:bindattr('periodic_move_delay',
		function(new_delay)
			if new_delay then
				delay = new_delay
			else
				return delay
			end
		end)
	owner:bindattr('periodic_move_direction',
		function(new_dx, new_dy)
			if new_dx then
				dx = new_dx
				dy = new_dy
			else
				return dx, dy
			end
		end)
	return res
end

return create
