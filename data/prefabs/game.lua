

local function coms()
	return
	{
		--{'objects'},
		--{'bk_image', Data.img.menubg.img, 'repeat_moving', {dx = 1, dy = -.6, speed = .1}}, 
		{'game', 18, 15, 32, 32, draw_cell},
		{'ui'}, 

		{'input_enabled', 'publisher and listener'},
		--{'score'},
	}
end

return { coms = coms, init = init }
