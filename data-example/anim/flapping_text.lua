local anim = Class{}
local g = love.graphics

function anim:init(texts, draw_text, flap_per_x_seconds)
	flap_per_x_seconds = flap_per_x_seconds or 1

	self.texts = texts
	self.text = texts[1]
	self.cur = 1
	self.speed = 1 / flap_per_x_seconds
	self.t = 0
	self.draw_text = draw_text
end

function anim:update(dt)
	self.t = self.t + dt
	if self.t > self.speed then
		self.t = 0
		self.cur = self.cur + 1
		if self.cur > #self.texts then
			self.cur = 1
		end
		self.text = self.texts[ self.cur ]
	end
end

function anim:draw(x, y)
	self.draw_text(x, y, self.text)
end

function anim:getWidth()
	return 0
end

function anim:getHeight()
	return 0
end

function anim:clone()
	return anim:new()
end

return anim