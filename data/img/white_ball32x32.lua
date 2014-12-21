local g = love.graphics
local w = 32

local function draw()
	g.setColor(255,255,255,255)
	g.circle('fill',w/2,w/2,w/2)
end

local img_data = love.static.drawImage(w, w, draw, Data.shader.blur)
local img = {raw = img_data}

function img:draw(x,y)
	g.draw(img_data, x, y)
end
function img:getWidth()
	return w
end
function img:getHeight()
	return w
end
return img