local BaseCamera = require(... .. '.camera')

local CNT_LOOP_FOREVER = -99

BaseCamera.paused = true

function BaseCamera:shake(seconds_per_loop, range, cnt_loop)
	local function restart(self)
		self.max_range = range or 50
		self.delta = 2 * range / seconds_per_loop
		self.dir = 1
		if cnt_loop == 'forever' then
			self.cnt_loop = CNT_LOOP_FOREVER 
		else
			self.cnt_loop = cnt_loop or -1 
		end
		self.paused = false
		self.range = 0
	end
	self.restart = restart
	self:restart()
end

function BaseCamera:restart()
	if self.restart then
		self:restart()
	end
end

function BaseCamera:update(dt)
	if self.paused then return end
	if self.range > self.max_range or 
		self.range < 0 then
		self.dir = - self.dir
	end
	if self.range < 0 then
		self.cnt_loop = self.cnt_loop - 1
	end
	if self.cnt_loop == 0 then
		self.paused = true
		return
	end
	self.range = self.range + self.dir * self.delta * dt
	BaseCamera.move(self, 
			math.random() * self.range,
			math.random() * self.range)
end

--[[
一个例子
local Camera = require('shake_camera')
local cam = Camera:new()
function update(dt)
	if ??? then
		cam:shake(5, 30, 2) -- shake 2 times, 5 seconds every time, 30 pixels as max shaking range.
	end
	cam:update(dt)
end
function draw()
	-- draw something without camera effects
	cam:beginScene()
	-- draw something here
	cam:endScene()
	-- draw something without camera effects
end
]]

love.camera = BaseCamera
