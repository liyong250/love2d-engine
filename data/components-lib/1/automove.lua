-- 添加此组件的物体将会接收玩家控制。
local control = Class{
	init = 
		-- init('up', 0.5, 50) 往上自动移动
		function(self, owner, directionVector)
			self.owner = owner
			self.dirX, self.dirY = directionVector:unpack()

			local event = self.owner.event
			event:bind('input_followmouse', function()
					local ownerPosX, ownerPosY = self.owner.com.locomotive:pos()
					local mouseX, mouseY = World.mouseWorldPos()
					self.dirX = mouseX - ownerPosX
					self.dirY = mouseY - ownerPosY
				end)
			event:bind('input_dir', function(dx, dy) self.dirX = dx; self.dirY = dy; end)
		end,
	--[[
	每一帧都需要更新，以便实时获取玩家输入;
	上一帧过去的事件;
	]]		
	update = 
		function(self, dt)
			self.owner.event:trigger('move', self.dirX, self.dirY)
		end,
}

return control