--[[
子弹的实现
]]

local function ondraw(self)
	local x, y = self:attr('pos')
	love.graphics.setColor(255 * math.random(), 100 + 50 * math.random(), 200 + 50 * math.random(), 0 + 150 * math.random())
	love.graphics.circle('fill', x, y, 8)
end
local function onupdate(self)
	local x, y = self:attr('pos')
	local dist = love.math.vector(x - self.aim_x, y - self.aim_y):len2()
	self.speed = love.math.vector(self.aim_x - x, self.aim_y - y)
	self:call('move', self.speed.x, self.speed.y)
	if love.window.intersect( x, y ) or dist < 100 then
		local ps = love.anim.particle:new( Data.img.white_ball32x32.raw, Data.particle.bomb_spread )
		self.update = function(self, dt) ps:update(dt) end
		self.draw = function(self) ps:draw(x, y) end
		love.timer.add(1, function() self:remove() end)
	end
end
local function init(self, x, y, aim_x, aim_y, speed)
	-- 添加组件
	self:com('loco')

	-- 初始化
	self.aim_x = assert(aim_x)
	self.aim_y = aim_y
	self:attr('speed', speed or 200)
	self:attr('pos', x, y)
	self.ondraw = ondraw
	self.onupdate = onupdate
end
return init 
