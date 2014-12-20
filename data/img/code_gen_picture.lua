local g = love.graphics

local function draw()
	local x, y = 20, 20
	g.setLineWidth(5)
	g.line(x - 20, y, x + 20, y)
	g.line(x, y - 20, x, y + 20)
	g.circle('line', x, y, 15)
end
local img_data = love.static.drawImage(40, 40, draw)



local img = {raw = img_data}

function img:draw(x,y)
	g.draw(img_data, x, y)
end
function img:getWidth()
	return 40
end
function img:getHeight()
	return 40
end
return img