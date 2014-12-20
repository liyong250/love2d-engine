local s = {}

local function draw_text(x, y, text)
	local w, h = love.window.getWidth(), love.window.getHeight()
	text = "Loading" .. text
	love.graphics.printf(text, 0, y + Data.img.loading_ring:getHeight() / 2 + 10, w, 'center')
end

function s:enter()
	s.rot = Data.anim.rotate_center:new(Data.img.loading_ring.raw)
	s.text = Data.anim.flapping_text:new(
		{'', '.', '..', '...', ' ..', '  .', ' .', '.'}, draw_text, 20)
end

function s:update(dt)
	s.rot:update(dt)
	s.text:update(dt)
end


function s:draw()
	local w, h = love.window.getWidth(), love.window.getHeight()
	local x, y = w / 2, h / 2
	s.rot:draw(x, y)
	s.text:draw(x, y)
end

return {test = s}
