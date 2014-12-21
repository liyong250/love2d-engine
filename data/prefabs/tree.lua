--[[
]]

local function ondraw(self)
	local x, y =self:attr('pos')
	love.graphics.print(tostring(self.life), x - 20, y - 20)
end
local function onupdate(self)
end
local function init(self, x, y)
	self.life = 100
	-- 添加组件
	self:com('loco')
	self:com('easy_animation',{
		idle = {{255,255,255}},
		chopped = {{255,0,0}, nil, 
			function() 
				self.life = self.life - 10
				if self.life <= 0 then	
					self:attr('anim', 'die')
				else
					self:attr('anim', 'idle') 
				end
			end},
		die = {{255,255,0}, nil, 
			function()
				log('tree is cut!')
				self:remove()
			end},
		}, 'idle')

	-- 初始化
	self.ondraw = ondraw
	self.onupdate = onupdate

	self:attr('pos', x, y)

	self:bindattr('live', function() return true end)
	self:listen('chop',
		function(worker)
			if self.life > 0 then
				self:attr('anim', 'chopped')
			else
				log('oh, i\'m already dead!')
			end
		end)
end
return init 
