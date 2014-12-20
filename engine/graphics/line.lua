
function love.graphics.line_laser(x1, y1, x2, y2, width, fragment)
	width = width or 1
	fragment = fragment or 10

	local factor = 255 / width
	local step = width / fragment
	for w = width, 1, -step do
		love.graphics.setColor(w * factor, 255 * math.random(), 255, 255)
		love.graphics.setLineWidth(w)
		love.graphics.line(x1, y1, x2, y2)
	end
end

function love.graphics.line_smooth(x1, y1, x2, y2, width, color_inner, color_outer, fragment)
	width = width or 1
	color_inner = color_inner or {love.graphics.getColor()}
	color_outer = color_outer or {love.graphics.getBackgroundColor()}
	fragment = fragment or 6
	

	local r, g, b, a = unpack(color_outer)
	local r2, g2, b2, a2 = unpack(color_inner)
	local rs, gs, bs, as = (r2 - r) / fragment, 
		(g2 - g) / fragment, 
		(b2 - b) / fragment, 
		(a2 - a) / fragment -- red color step => rs

	local fragment_width = width / fragment
	for i = 1, fragment do
		local w = (fragment - i + 1) * fragment_width -- line width
		
		love.graphics.setColor(r, g, b, a)
		r = r + rs
		b = b + bs
		g = g + gs
		a = a + as

		love.graphics.setLineWidth(w)
		love.graphics.setStencil(draw1)
		love.graphics.line(x1, y1, x2, y2)
		love.graphics.circle('fill', x1, y1, w / 2)
		love.graphics.circle('fill', x2, y2, w / 2)
	end
end