local prefab = Class({Prefab},
{
	init = 
		function(self, initposVector)
			self:addCom('locomotive', 0, initposVector:unpack())
			self.anim = Anims.body_down:clone()
		end,
})
return prefab