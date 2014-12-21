local g = love.graphics
local w, h = 40, 100

local function draw()
	g.setColor(50, 155, 50, 255)
	local tw = w * .3 -- trunk width
	local half = w * .5
	local tl = half - tw / 2 -- trunk left
	local tr = half + tw / 2 -- trunk right
	local th = h * .85 -- trunk height
	love.graphics.polygon('fill',
			half, 0, 
			0, th,
			tl, th,
			tl, h,
			tr, h,
			tr, th,
			w, th)
	g.setColor(255, 255, 255, 255)
end

local raw = love.static.drawImage(w, h, draw, Data.shader.scanlines)--, Data.shader.blur)
local img = love.static:new(raw)
img:drawOnFeet(true)
return img
