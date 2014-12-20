local last_obj

return
{
	coms = 
	function()
		return
		{
			-- 可视化组件
			{
				'visual',
				love.anim.animGroup:new(
					'right',
					{
						left = Data.anim.body_left:clone(),
						right = Data.anim.body_right:clone(),
						up = Data.anim.body_up:clone(),
						down = Data.anim.body_down:clone(),
					}
				),
				'grid'
			},
			{'visual_colored', 'colored', {red = 255, green = 110, blue = 110, alpha = 139}},
			--{'lighter', 'light'},

			-- 逻辑组件
			{'loco', 'discontinuous', 1, 2, 2},
			{'loco_follow_repeat_pos'},
		}
	end,
	init = 
	function(t)

		t:listen('moved',
			function(oldx, oldy, newx, newy)
				t.world:attr('grid_row_col', oldx, oldy, false)
				t.world:attr('grid_row_col', newx, newy, 'snake_body')
			end)
		last_obj = t
	end
}