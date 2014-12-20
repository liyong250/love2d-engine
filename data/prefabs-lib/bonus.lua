
local function coms()
	return
	{
		-- 可视化组件
		{
			'visual',
			Data.img.mylogo,
			'grid'
		},
		--{'colored', 255, 100, 55, 255},
		--{'lighter', 'light'},

		{'loco', 'discontinuous', 1, row, col},
	}
end

return 
{
	coms = coms,
	init = 
	function(t, row, col)
		t.world:attr('grid_row_col', row, col, 'bonus')
	end
}