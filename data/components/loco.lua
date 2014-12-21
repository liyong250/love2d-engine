--[[
* 实现功能描述

* 目标Entity必须具有的属性和事件
* 向目标Entity上添加的属性和事件
	* 属性
		* z	R，按照下方物体遮盖上方物体的方式覆盖物体时可以使用该属性
		* pos WR，位置
		* speed WR，速度
	* 事件
		* moved(old_x, old_y, current_x, current_y)
* 可以接受的事件
	* move(direction_x, direction_y)
		(direction_x, direction_y)表示的向量指明了需要移动的方向
* 其他强制要求
	* World:cango( object, x, y )
		返回object是否可以移动到世界的(x,y)处
* 用法示例
	* 让人物可移动，速度是每秒100像素，初始位置是（0,0），并且位置信息表示人物脚所在的地方
	{'loco', 'continuous', 100, 0, 0, 
		function(x, y, w, h)
			-- x，y默认表示图片左上角坐标
			return x - w / 2, y - h
		end
	}
]]

local function try_set_pos(self, newx, newy)
	-- 改变显示的方向
	local dx, dy = newx - self.x, newy - self.y
	local dir
	if math.abs(dx) > math.abs(dy) then
		if dx > 0 then
			dir = 'right'
		else
			dir = 'left'
		end
	else
		if dy > 0 then
			dir = 'down'
		else
			dir = 'up'
		end
	end
	self.owner:emit('changeVisual', dir)
	-- 检测是否可以走
	newx, newy = World:attr('cango', self.owner, newx, newy)
	if newx ~= false then
	-- 发布事件
		self.owner:emit('move_' .. dir)-- 移动！同时修改外观（朝向不同方向）
		self.owner:emit('moved', self.x, self.y, newx, newy)
		self.x, self.y = newx, newy
		return true
	else
		return false
	end
end

local function onupdate(self, dt)
	local dx, dy = 0, 0
	for _, moveReq in pairs(self.moveRequests) do
		local Vector = love.math.vector
		direction_vector = Vector(moveReq[1], moveReq[2]):normalized()
		local tmp_dx = direction_vector * Vector(self._speed * moveReq[3], 0)
		local tmp_dy = direction_vector * Vector(0, self._speed * moveReq[3])
		if self.mode == 'continuous' then
			tmp_dx = tmp_dx * dt
			tmp_dy = tmp_dy * dt
		end
		dx = dx + tmp_dx
		dy = dy + tmp_dy
	end
	
	-- 不需要移动
	if dx == 0 and dy == 0 then return end

	-- 尝试移动
	local trials = {{dx, dy}}
	if dx ~= 0 then
		table.insert(trials, {dx, 0})
	end
	if dy ~= 0 then
		table.insert(trials, {0, dy})
	end

	for _, trial in pairs(trials) do
		local newx, newy = self.x + trial[1], self.y + trial[2]
		if try_set_pos(self, newx, newy) then
			break
		end
	end
	-- 请求处理完毕，全部清空
	self.moveRequests = {}
end

local function onsave(com, t)
	t.x = com.x
	t.y = com.y
	t.speed = com._speed
end

local function onload(com, t)
	com.x = t.x
	com.y = t.y
	com._speed = t.speed
end

--[[
mode = 'continuous'
	'continuous' speed将作为每秒移动的像素来处理
	'discontinuous' speed将作为每次移动的移动距离来处理
speed = 1
	详见type
x, y = 0, 0
	初始位置（具体画在哪里由最后一个函数来决定）
]]
local function create(owner, mode, speed, x, y)
	-- 默认参数值
	mode = mode or 'continuous'
	x = x or 0
	y = y or 0
	speed = speed or 1
	-- 创建组件
	local t =
	{
		owner = owner,
		_speed = speed,
		x = x,
		y = y,
		moveRequests = {},
		mode = mode,

		onupdate = onupdate,
		onload = onload,
		onsave = onsave,
	}
	-- 绑定事件
	owner:bindcall('move',
		function(x, y, multi)
			multi = multi or 1
			table.insert(t.moveRequests, {x, y, multi})
		end)
	owner:bindattr('speed',
		function(speed)
			if speed then
				t._speed = speed
			end
			return t._speed
		end)
	owner:bindattr('pos',
		function(x, y) 
			if type(x) == 'number' then
				try_set_pos(t, x, y)
			else
				return t.x, t.y 
			end
		end)
	owner:bindattr('z',
		function()
			return t.y
		end)
	-- 返回组件
	return t
end


return create
