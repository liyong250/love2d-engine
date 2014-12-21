--[[
person的实现
]]

local function start_walk() end 
local function loop() end
local function end_walk() end 

local function ondraw(self)
end
local function onupdate(self)
	World:call('grid_set_center', self)
	if self.aim_pos then
		local pos = love.math.pos( self:attr('pos') )
		if self.aim_pos:dist( pos ) > 10 then
			self:attr('move', self.aim_pos.x - pos.x, self.aim_pos.y - pos.y)
		else
			self.aim_pos = nil
			self:attr('anim', 'idle')
		end
	end
end
local function init(self, x, y, speed)
	-- 添加组件
	self:com('input_enabled', 'listener')
	self:com('loco')
	self:com('easy_animation',{
		idle = {{255,255,255}, nil, loop, nil},
		walk = {{255,0,0}, start_walk, loop, end_walk},
		run = {{0,255,255}, nil, loop, nil},
		chop = {{0,0,255}, function()end, 
			function()self:attr('anim', 'idle')end,
			function()self.work:emit('chop', self) self.work = nil end},
		}, 'idle')

	-- 初始化
	self:attr('speed', speed or 200)
	self:attr('pos', x, y)
	self.ondraw = ondraw
	self.onupdate = onupdate
	self.anim = 'walk'
	self.aim_pos = nil

	self:listen('plant',
		function()
			local x, y = self:attr('pos')
			World:call('spawn_entity', 'tree', x, y)
		end)
	self:listen('chop',
		function()
			if self.work then return end

			local trees = World:call('get_around_obj', 
				self,
				function(obj) return obj ~= self end, 
				4)
			if #trees > 0 then
				local tree = trees[1]
				self:attr('anim', 'chop')
				self.work = tree
			else
				log('no tree around!')
			end
		end)
	self:listen('move change',
		function()
			if self.anim == 'walk' then
				self.anim = 'run'
			else
				self.anim = 'walk'
			end
			self:attr('anim', self.anim)
		end)
	self:listen('move to',
		function(x, y)
			self.aim_pos = love.math.pos(x,y)
			self:attr('anim', self.anim)
		end)
end
return init 
