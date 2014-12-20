local anim = Class{ r = 0, speed = 5 }
local g = love.graphics

function anim:init(drawable)
	self.drawable = drawable
end

function anim:update(dt)
	self.r = self.r + self.speed * dt
end

function anim:draw(x, y)
	g.draw(self.drawable, x, y, self.r, 1, 1, self.drawable:getWidth() / 2, self.drawable:getHeight() / 2)
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

function anim:setRad(rad)
	self.r = rad
end

return anim