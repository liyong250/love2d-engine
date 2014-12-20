local coms = 
{
	{'loco', 400, 100, 100},
	{'control'},
	{'visual', e.anim.animGroup:new('right',
		{
			left = Res.anim.body_left:clone(),
			right = Res.anim.body_right:clone(),
			up = Res.anim.body_up:clone(),
			down = Res.anim.body_down:clone(),
		})},
	{'input'},
}

return coms