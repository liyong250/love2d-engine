local img = {}
local g = love.graphics
function img:draw(x,y)
	g.setLineWidth(5)
	g.line(x - 20, y, x + 20, y)
	g.line(x, y - 20, x, y + 20)
	g.circle('line', x, y, 15)
end
function img:getWidth()
	return 40
end
function img:getHeight()
	return 40
end
return img