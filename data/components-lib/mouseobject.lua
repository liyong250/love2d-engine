--[[
* 实现功能描述
	实现让物体跟随鼠标移动的效果。例如实现鼠标移动背包物体，实现图片鼠标指针。
* 目标Entity必须具有的属性和事件
	* cango( object, x, y )
		返回object是否可以移动到世界的(x,y)处
* 向目标Entity上添加的属性和事件
	* 属性
		* mouseobject( object ) RW，返回鼠标上的object，或设置object到鼠标上。
			注意，不应当通过 mouseobject( nil ) 来移除先前设置的object，而应当通过 rm_mouseobject方法。
	* 方法
		* rm_mouseobject() 移除先前设置的object
* 可以接受的事件
* 其他强制要求
	* 要求放在鼠标上的table必须包含如下方法：
		* draw	画出自己
		* CenterToMouse 将自己移动到鼠标所在的地方
		* StopFollowMouse 不在跟随鼠标时可以获取到的通知事件
		* FollowMouse 被添加到鼠标上时可以得到的通知事件
	* 可选要求
		* update 函数将会被调用，如果table存在此方法
* 用法示例
	* 让人物可移动，速度是每秒100像素，初始位置是（0,0），并且位置信息表示人物脚所在的地方
	{'loco', 'continuous', 100, 0, 0, 
		function(x, y, w, h)
			-- x，y默认表示图片左上角坐标
			return x - w / 2, y - h
		end
	}
]]


local function onupdate(self, dt)
	if self.object then
		if self.object.update then
			self.object:update(dt)
		end
		self.object:CenterToMouse()
	end
end	
local  function ondraw(self)
	love.graphics.push()
	love.graphics.origin()
	if self.object then
		self.object:draw()
	end
	love.graphics.pop()
end
local function add_item(obj)
	local self = love.mouse
	if self.object then
		self.object:StopFollowMouse()
	end
	obj:FollowMouse()
	self.object = obj
end
local function remove_item()
	local self = love.mouse
	if self.object then
		self.object:StopFollowMouse()
		self.object = nil
	end
end

local function create(owner, speed, x, y)
	love.mouse.onupdate = onupdate
	love.mouse.ondraw = ondraw
	love.mouse.add_item = add_item
	love.mouse.remove_item = remove_item

	owner:bindattr('mouseobject',
		function(obj)
			if obj then
				add_item(obj)
			else
				return love.mouse.object
			end
		end)
	owner:listen('rm_mouseobject', remove_item)
	return love.mouse
end


return create