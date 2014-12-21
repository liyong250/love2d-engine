-- 添加此组件的物体会跟随着某个物体移动
--[[
trigger:

bind:
addFollower(follower)
removeFollower(follower)
follow(leader)
isleader(leader)
getfollower()
]]


local prefab = Class{
	init = 
		function(self, owner, leader, minimumDistance)
			self.owner = owner
			minimumDistance = minimumDistance or 0
			self.minDistSquare = minimumDistance * minimumDistance
			self:follow(leader)

			self.owner.event:bind('addFollower', function(follower)
					if self.follower then
						self.follower.event:trigger('follow', follower)
					end
					self.follower = follower
				end)
			self.owner.event:bind('removeFollower', function(follower)
					self.follower = nil
				end)
			self.owner.event:bind('follow', function(leader)
					self:follow(leader)
				end)
			self.owner.event:bind('isleader', function(leader)
					return self.leader == leader
				end)
			self.owner.event:bind('getfollower', function() return self.follower end)
		end,
	update = 
		function(self)
			if not self.leader then return end

			local leaderX, leaderY = self.leader:pos()
			local ownerX, ownerY = self.owner:pos()
			local dx = leaderX - ownerX
			local dy = leaderY - ownerY
			local dist = love.math.vector(dx, dy):len2()
			local loc = self.owner.com.locomotive
			local dist2speedMapping = {
				[1.4] = 400,
				[1.3] = 300,
				[1.2] = 200,
				[1] = 100,
			}
			for multi, speed in pairs(dist2speedMapping) do
				if dist > self.minDistSquare * multi then
					self.owner.event:trigger('speed', speed)
					break
				end
			end
			if dist > self.minDistSquare then
				self.owner.event:trigger('move', dx, dy)
			end
		end,
	follow =
		function(self, leader)
			if not leader then return end
			-- 解除和旧leader的关系
			self:removeFromLeader()
			-- 新的leader关系的建立~-
			self.leader = leader
			leader.event:trigger('addFollower', self.owner)
		end,
	removeFromLeader =
		function (self)
			if self.leader then
				self.leader.event:trigger('removeFollower', self.owner)
			end
		end,
	onRemove =
		function(self)
			-- 解除和leader的关系
			self:removeFromLeader()
			-- 自己的follower继续跟着leader
			if self.leader then
				self.follower:trigger('follow', self.leader)
			end
		end,
}

return prefab