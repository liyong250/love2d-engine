local dist = 30
local speed = 200
local prefab = Class({love.entity.Prefab},
{
	init = 
		function(self, posHead, posTail, dirVec)
			love.entity.Prefab.init(self)
			-- 创建头部
			self.head = love.entity.SpawnPrefab('snakehead', speed, posHead, dirVec)
			-- 创建尾巴
			self.bodies = {}
			-- 创建测试节点
			for i = 1, 7 do
				self:_addBodyAfter(self.head, 380, 380)
			end
		end,
	_addBodyAfter = 
		-- 在leader后面插入一个新的body。leader是body或head。
		function(self, leader, x, y)
			local body = love.entity.SpawnPrefab('snakebody', leader, dist, speed, love.math.pos(x, y))
			self.bodies[body] = true
		end,
	addBodyAfterHead =
		-- 在首部添加一个
		function(self, x, y)
			self:_addBodyAfter(self.head, x, y)
		end,
	removeBody =
		function(self, body)
			-- 不允许删除后一个人
			if body.event:trigger('isleader', self.head) then
				return false
			end
			-- 从记录中彻底移除
			self.bodies[body] = nil
			-- 闪一下，然后移除
			body:removeCom('follow')
			love.anim.shine(body, {{0, 0, 0, 0}, {255, 110, 110, 255}},
				function() body:remove() end, .05, 1)
			return true
		end,
	onUpdate =
		function(self, dt)
			-- 自碰撞检测
			--[[
			for body in pairs(self.bodies) do
				if body:intersect(self.head) then
					if self:removeBody(body) then
						-- love.audio.stop(Snd.bomb)
						-- love.audio.play(Snd.bomb)
						-- World.bombAt(body:pos())
						-- Signal.emit('gameover', self.lastcounter)
					end
					break
				end
			end
			]]
		end,
	pos = function(self) return self.head:pos() end,
	onRemove =
		function(self, dt)
			self.head:remove()
			for body in pairs(self.bodies) do
				body:remove()
			end
		end,
	len = 
		-- 不应频繁调用！
		function(self, dt)
			local counter = 0
			for body in pairs(self.bodies) do
				counter = counter + 1
			end
			return counter
		end,
})

return prefab