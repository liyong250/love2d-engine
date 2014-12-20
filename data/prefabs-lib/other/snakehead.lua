local prefab = Class({love.entity.Prefab},
{
	init = 
		function(self, speed, initposVector, initDirectionVector)
			love.entity.Prefab.init(self)
			self:addCom('loco', speed, initposVector:unpack())
			self:addCom('input')
			self:addCom('follow')
			self:addCom('automove', initDirectionVector)
			self:addCom('visual', love.anim.animGroup:new('down', 
				{
					down = Res.anim.head_down:clone(),
					up = Res.anim.head_up:clone(),
					left = Res.anim.head_left:clone(),
					right = Res.anim.head_right:clone(),
				}))

			self.speed = speed or 50

			self.event:bind('key_speedup', function() self.event:trigger('speed', self.speed * 2) end)
			self.event:bind('key_speeddown', function() self.event:trigger('speed', self.speed * .3) end)

			local event = {'left', 'right', 'up', 'down'}
			for _, e in pairs(event) do
				self.event:bind('move_' .. e, function() self.event:trigger('changeVisual', e) end)
			end

			local frame = loveframes.Create("frame")
			frame:SetName("Grid")
			frame:CenterWithinArea(unpack(demo.centerarea))
					
			local grid = loveframes.Create("grid", frame)
			grid:SetPos(5, 30)
			grid:SetRows(5)
			grid:SetColumns(5)
			grid:SetCellWidth(25)
			grid:SetCellHeight(25)
			grid:SetCellPadding(5)
			grid:SetItemAutoSize(true)
					
			local id = 1
					
			for i=1, 5 do
				for n=1, 5 do
					local button = loveframes.Create("button")
					button:SetSize(15, 15)
					button:SetText(id)
					grid:AddItem(button, i, n)
					id = id + 1
				end
			end
					
			grid.OnSizeChanged = function(object)
				frame:SetSize(object:GetWidth() + 10, object:GetHeight() + 35)
				frame:CenterWithinArea(unpack(demo.centerarea))
			end
		end,
	onUpdate = 
		function(self)
			self.event:trigger('speed', self.speed)
		end,s
	
})

return prefab