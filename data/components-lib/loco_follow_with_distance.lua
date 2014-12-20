--[[
* 实现功能描述
	* 允许物体跟随另外一个物体，并保持一定距离
* 目标Entity必须
	* emit: move( dx, dy )
	* attr-read: pos()
* 属性
* 方法
	* follow( leader )
* 接受的事件
* 发布的事件
* 其他强制要求
* 用法实例
]]

local function onupdate(self)
	local leaderX, leaderY = self.leader:attr('pos')
	local ownerX, ownerY = self.owner:attr('pos')
	local dx = leaderX - ownerX
	local dy = leaderY - ownerY
	local dist = love.math.vector(dx, dy):len2()
	--[[
	-- 智能地调整速度，以便及时跟上。
	local dist2speedMapping = {
		[1.4] = 400,
		[1.3] = 300,
		[1.2] = 200,
		[1] = 100,
	}
	for multi, speed in pairs(dist2speedMapping) do
		if dist > self.minDistSquare * multi then
			self.owner:attr('speed', speed)
			break
		end
	end
	]]
	if dist > self.minDistSquare then
		self.owner:emit('move', dx, dy)
	end
end

local function onremove(res)
	-- 解除和leader的关系
	if res.leader then
		res.leader:emit('!breakup', res)
	end
	-- 告诉自己的小喽啰
	if res.follower then
		res.follower:emit('!dontfollowme', res)
	end
	-- 将小喽罗们分给自己的leader
	if res.follower and res.leader then
		res.leader:emit('!addFollower', res.follower)
	end

	res.leader = nil
	res.follower = nil
end

local function onsave(com, t)
	t.minDistSquare = com.minDistSquare
	if com.leader then
		t.leader = com.leader.guid
	end
end

local function onload(com, t, guid2entity)
	com.minDistSquare = t.minDistSquare
	if t.leader then
		com.owner:emit('follow', guid2entity[t.leader])
	end
end

--[[
leader
	跟随谁？
distance = 20
	和要跟随的物体之间的距离
]]
local function create(owner, leader, distance)
	minimumDistance = distance or 20
	local res =
	{
		owner = owner,
		minDistSquare = minimumDistance * minimumDistance,

		onremove = onremove,
		onload = onload,
		onsave = onsave,
	}

	local function removeFromLeader()
		if res.leader then
			res.leader:emit('!breakup', res.owner)
		end
	end

	local function follow(leader)
		if not leader then return end
		-- 解除和leader的关系
		removeFromLeader()
		-- 新的leader关系的建立~-
		res.leader = leader
		res.onupdate = onupdate
		leader:emit('!addFollower', res.owner)
	end

	-- 内部使用
	owner:bindcall('!addFollower',
		function(follower)
			assert(not res.follower, "You cannot follow me, coz I won't abandon my current follower")
			res.follower = follower
		end)
	owner:bindcall('!breakup',
		function(follower)
			assert(follower == res.follower)
			res.follower = nil
		end)
	owner:bindcall('!dontfollowme',
		function(leader)
			-- How sad I am...
			res.onupdate = nil
		end)


	owner:bindcall('follow', follow)

	-- 初始化跟着主人
	follow(leader)

	return res
end

return create