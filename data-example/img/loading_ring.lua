local g = love.graphics
local w = 100

local function draw()
	local r1 = 0
	local r2 = math.pi * 2
	local cnt = 200
	local step_rad = (r2 - r1) / cnt
	local radius = 6
	local ring_radius = w / 2 - radius - 10
	for r = r2, r1, -step_rad do
		local x = w / 2 + ring_radius * math.cos(r)
		local y = w / 2 + ring_radius * math.sin(r)
		local percent = (r - r1) / (r2 - r1)
		local c = 155 --100 * (1 - percent) + 120-- color
		g.setColor(c, c, c, 255 * percent)
		g.circle('fill', x, y, radius * percent)
	end
	g.setColor(255, 255, 255, 255)
end

local raw = love.static.drawImage(w, w, draw)--, Data.shader.blur)
local img = {raw = raw}

function img:draw(x,y)
	g.draw(self.raw, x, y)
end
function img:getWidth()
	return w
end
function img:getHeight()
	return w
end
return img
