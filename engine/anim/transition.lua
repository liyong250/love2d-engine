--[[
转场效果的实现。
使用：
* new一个转场实例
* draw和update
* callback中载入下一个场景。调用revert显示出来
]]
local trans = {}

-- 点阵列效果
local dots = Class{
	init = 
		function(self, callback, showScene, speed, color)
			self.dots = {}
			self.showScene = showScene
			self.color = color or {0, 0, 0, 255}
			self.paused = false
			self.callback = callback
			self.speed = speed or 200
			self.cellwidth = 100
			self.cellheight = 100
			self.cntrow = math.ceil(love.window.getHeight() / self.cellheight) + 1
			self.cntcol = math.ceil(love.window.getWidth() / self.cellwidth) + 1
			self.maxradius = 100
			for i = 1, self.cntcol do
				if self.showScene then
					self.dots[i] = {r = (i + self.cntrow) * 10}
				else
					self.dots[i] = {r = (i - self.cntrow) * 10}
				end
			end
		end,
	revert = 
		function(self)
			self.paused = false
			self.showScene = not self.showScene
		end,
	update = 
		function(self, dt)
			if self.paused then return end
			for col = 1, self.cntcol do
				if self.showScene then
					self.dots[col].r = self.dots[col].r - self.speed * dt
				else
					self.dots[col].r = self.dots[col].r + self.speed * dt
				end
			end
			if self.showScene then
				if self.dots[self.cntcol].r < 0 then
					self.paused = true
					self.callback()
				end
			else
				if self.dots[1].r > self.maxradius then
					self.paused = true
					self.callback()
				end
			end
		end,
	draw = 
		function(self)
			local oldColor = {love.graphics.getColor()}
			love.graphics.setColor(unpack(self.color))
			for row = 1, self.cntrow do
				for col = 1, self.cntcol do
					local idx = col
					if self.dots[idx].r > 0 then
						local x = (col - 1) * self.cellwidth
						local y = (row - 1) * self.cellheight
						love.graphics.circle('fill', x, y, self.dots[idx].r, 20)
					end
				end
			end
			love.graphics.setColor(unpack(oldColor))
		end,
}

trans.dots = dots
