
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
			--{'colored', 255, 100, 55, 255},
			--{'lighter', 'light'},

			-- 逻辑组件
			{'input_enabled', 'listener'},
			{'control'},

			{'loco', 'discontinuous', 1, 4, 4},
			{'loco_periodic_move', .2, 1, 0},
		}
	end
	, 
	init = 
	function(t)

		t:listen('moved',
			function(_, _, newx, newy)
				local cell = t.world:attr('grid_row_col', newx, newy)
				if cell == 'snake_body' then
					t.world:emit('game_over')
				elseif cell == 'bonus' then
					t.world:bindcall('snake_add_a_body')
				end
			end)
	end
}