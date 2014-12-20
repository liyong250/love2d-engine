local anim = Class{ r = 0, speed = 1, radius = 20, color = {255, 255, 255, 255}, mode = 'line' }
local g = love.graphics

function anim:update(dt)
	self.r = self.r + self.speed * dt
end

function anim:draw(x, y)
	g.setColor(unpack(self.color))
	g.arc(self.mode, x, y, self.radius, self.r, self.r + 3.14 / 4, 10)
end

function anim:getWidth()
	return radius
end

function anim:getHeight()
	return radius
end

function anim:clone()
	return anim:new()
end

function anim:setSpeed(round_per_second)
	self.speed = math.pi * 2 * round_per_second
end

function anim:setRadius(radius)
	self.radius = radius
end

return anim