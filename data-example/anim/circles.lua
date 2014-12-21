local function create()		
	local res = {}
	local cnt, gap = 40, 2
	local r, r1, r2, s, color = {},{},{},{},{}

    local cr = 0
    for i = 1, cnt do
        cr = cr + gap * math.random() + 1
        r[i] = cr
        r1[i] = math.pi * math.random()
        r2[i] = math.pi * math.random()
        s[i] = math.pi * 0.05 * math.random()
        color[i] = {math.random() * 255, math.random() * 255, math.random() * 255, math.random() * 100 + 150}
    end

	function res.draw(x, y)
	    for i = 1, cnt do
	        love.graphics.setColor(unpack(color[i]))
	        love.graphics.arc('line', x, y, r[i], r1[i], r2[i], 20)
	    end
	end
	function res.update(dt)
	    local mx, my = love.mouse.getPosition()
	    x = mx
	    y = my
	    for i = 1, cnt do
	        r1[i] = r1[i] + s[i]
	        r2[i] = r2[i] + s[i]
	    end
	end

	return res
end

return create