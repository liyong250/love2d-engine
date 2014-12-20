local prefab = Class({love.entity.Prefab},
{
	init = 
		function(self, leader, minDist, speed, initposVector)
			love.entity.Prefab.init(self)
			self:addCom('loco', speed, initposVector:unpack())
			self:addCom('follow', leader, minDist)
			-- self:addTag('through')
			self:addCom('visual', love.anim.animGroup:new('up', 
				{
					down = Res.anim.body_down:clone(),
					up = Res.anim.body_up:clone(),
					left = Res.anim.body_left:clone(),
					right = Res.anim.body_right:clone(),
				}))

			local event = {'left', 'right', 'up', 'down'}
			for _, e in pairs(event) do
				self.event:bind('move_' .. e, function() self.event:trigger('changeVisual', e) end)
			end
		end,
	--onUpdate = function(self) print(self:pos()) end
})
return prefab