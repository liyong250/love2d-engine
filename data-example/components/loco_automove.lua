--[[
* 实现功能描述
	* 使实体定时自动向某个方向进行移动（例如贪吃蛇的移动）
* 目标Entity必须
* 属性
* 方法
	* automove_towards( direction_x, direction_y )
* 产生的事件
	* move( direction_x, direction_y )
* 接受的事件
* 其他强制要求
* 用法示例
]]

local function onupdate(self, dt)
	self.owner:emit('move', self.direction_x, self.direction_y)
end

--[[
direction_x, direction_y = 0, 0
	构成一个方向向量（例如(1,2)和(2,4)表示的是同一个方向）
]]
local function create(owner, direction_x, direction_y)
	-- create
	local com =
	{
		direction_x = direction_x or 0,
		direction_y = direction_y or 0,
		owner = owner,

		onupdate = onupdate,
	}

	owner:bindcall('automove_towards',
		function(dx, dy)
			com.direction_x = dx
			com.direction_y = dy
		end)

	return com
end

return control