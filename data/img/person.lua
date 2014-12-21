local g = love.graphics
local w = 30
local h = w * 2

local function draw()
	local r = w * .3
	local mid = h * .6
	local half = w * .5
	g.setColor(150, 155, 250, 255)
	g.setLineWidth(r)
	love.graphics.circle('fill', half, half, r)
	love.graphics.line(half, half, half, mid)
	love.graphics.line(half, mid, 0, h)
	love.graphics.line(half, mid, w, h)
	love.graphics.line(0, w, w, w)
	g.setLineWidth(0)
	g.setColor(255, 255, 255, 255)
end

local raw = love.static.drawImage(w, h, draw, Data.shader.scanlines)--, Data.shader.blur)
local img = love.static:new(raw)
img:drawOnFeet(true)
return img
