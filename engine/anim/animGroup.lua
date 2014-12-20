local animgroup = Class{
	init = 
		-- 第一个参数是当前anim的名称;
		-- allAnims是全部anims，格式是{'name' = AnimObject, 'name2' = AnimObject2, ...}
		function(self, curAnimName, allAnims)
			assert(allAnims[curAnimName])
			self.anims = allAnims
			self:change(curAnimName)
		end,
	change =
		function(self, animName)
			assert(self.anims[animName])
			self.curAnim = self.anims[animName]
		end,
	draw =
		function(self, ...)
			self.curAnim:draw(...)
		end,
	update =
		function(self, dt)
			self.curAnim:update(dt)
		end,
	getWidth = function(self) return self.curAnim:getWidth() end,
	getHeight = function(self) return self.curAnim:getHeight() end,
}

return animgroup