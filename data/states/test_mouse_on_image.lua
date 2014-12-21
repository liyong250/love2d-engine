local s = {}

function s:enter()
	tree = Data.img.tree
	person = Data.img.person
end

function s:update(dt)
end

local tree_x, tree_y = 320, 200
function ishit(img, x, y)
	local mx, my = love.mouse.getPosition()
	local w, h = img:getWidth(), img:getHeight()
	local x, y= x - w / 2, y - h
	if love.util.inRect(mx, my, x, y, w, h) then		
		if img:testHit(mx - x, my - y) then
			return true
		end
	end
end

local function drawTestHit(img, x, y, hit)
	if hit then
		img:draw(x, y)
	else
		love.graphics.setColor(200, 200, 200)
		img:draw(x, y)
		love.graphics.setColor(255, 255, 255)
	end
end

function s:draw()
	local hit = ishit(tree, tree_x, tree_y)
	drawTestHit(tree, tree_x, tree_y, hit)
	hit = ishit(person, 250, 200)
	drawTestHit(person, 250, 200, hit)
end

return {test_mouse_on_image = s}
