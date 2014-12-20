--[[------------------------------------------------
	-- Love Frames - A GUI library for LOVE --
	-- Copyright (c) 2012-2014 Kenny Shields --
--]]------------------------------------------------

-- bagitem object
local newobject = loveframes.NewObject("bagitem", "loveframes_object_bagitem", true)
local follow
--[[---------------------------------------------------------
	- func: initialize()
	- desc: initializes the object
--]]---------------------------------------------------------
function newobject:initialize()
	
	self.type = "bagitem"
	self.text = "bagitem"
	self.width = 80
	self.height = 25
	self.internal = false
	self.down = false
	self.clickable = true
	self.enabled = true
	self.toggleable = false
	self.toggle = false
	self.OnClick = nil
	self.follow = false
	
end


function newobject:FollowMouse()
	self.follow = true
	if self.parent:GetItem(self.gridrow, self.gridcolumn) == self then
		-- print('equal')
		self.parent:RemoveItem(self.gridrow, self.gridcolumn)
	else
		-- print('not equal')
	end
end
function newobject:StopFollowMouse()
	self.follow = false
	self.parent:AddItem(self, self.gridrow, self.gridcolumn)
end
function newobject:CenterToMouse()
	self.x = love.mouse.getX() - self.width / 2
	self.y = love.mouse.getY() - self.height / 2
end

--[[---------------------------------------------------------
	- func: update(deltatime)
	- desc: updates the object
--]]---------------------------------------------------------
function newobject:update(dt)

	local state = loveframes.state
	local selfstate = self.state
	
	if state ~= selfstate then
		return
	end
	
	local visible = self.visible
	local alwaysupdate = self.alwaysupdate
	
	if not visible then
		if not alwaysupdate then
			return
		end
	end
	
	self:CheckHover()
	
	local hover = self.hover
	local down = self.down
	local downobject = loveframes.downobject
	local parent = self.parent
	local base = loveframes.base
	local update = self.Update
	
	if not hover then
		self.down = false
		if downobject == self then
			self.hover = true
		end
	else
		if downobject == self then
			self.down = true
		end
	end
	
	if self.follow then
		self.x = love.mouse.getX() - self.width / 2
		self.y = love.mouse.getY() - self.height / 2
	-- move to parent if there is a parent
	elseif parent ~= base then
		self.x = self.parent.x + self.staticx
		self.y = self.parent.y + self.staticy
	end
	
	if update then
		update(self, dt)
	end

end


--[[---------------------------------------------------------
	- func: draw()
	- desc: draws the object
--]]---------------------------------------------------------
function newobject:draw()
	
	local state = loveframes.state
	local selfstate = self.state
	
	if state ~= selfstate then
		return
	end
	
	local visible = self.visible
	
	if not visible then
		return
	end

	local skins = loveframes.skins.available
	local skinindex = loveframes.config["ACTIVESKIN"]
	local defaultskin = loveframes.config["DEFAULTSKIN"]
	local selfskin = self.skin
	local skin = skins[selfskin] or skins[skinindex]
	local drawfunc = skin.DrawBagitem or skins[defaultskin].DrawBagitem
	local draw = self.Draw
	local drawcount = loveframes.drawcount
	
	-- set the object's draw order
	self:SetDrawOrder()
		
	if draw then
		draw(self)
	else
		drawfunc(self)
	end
	
end



function newobject:keypressed()
end
function newobject:keyreleased()
end
function newobject:textinput()
end
--[[---------------------------------------------------------
	- func: mousepressed(x, y, button)
	- desc: called when the player presses a mouse bagitem
--]]---------------------------------------------------------
function newobject:mousepressed(x, y, button)

	local state = loveframes.state
	local selfstate = self.state
	
	if state ~= selfstate then
		return
	end
	
	local visible = self.visible
	
	if not visible then
		return
	end
	
	local hover = self.hover
	
	if hover and button == "l" then
		local baseparent = self:GetBaseParent()
		if baseparent and baseparent.type == "frame" then
			baseparent:MakeTop()
		end
		self.down = true
		loveframes.downobject = self
	end
end

--[[---------------------------------------------------------
	- func: mousereleased(x, y, button)
	- desc: called when the player releases a mouse button
--]]---------------------------------------------------------
function newobject:mousereleased(x, y, button)
	local state = loveframes.state
	local selfstate = self.state
	
	if state ~= selfstate then
		return
	end
	
	local visible = self.visible
	
	if not visible then
		return
	end
	
	local hover = self.hover
	local down = self.down
	local clickable = self.clickable
	local enabled = self.enabled
	local onclick = self.OnClick
	
	if hover and down and clickable and button == "l" then
		
		if enabled then
			if onclick then
				onclick(self, x, y)
			end
			if self.toggleable then
				local ontoggle = self.OnToggle
				self.toggle = not self.toggle
				if ontoggle then
					ontoggle(self, self.toggle)
				end
			end
		end
	end
	
	self.down = false

end

--[[---------------------------------------------------------
	- func: SetText(text)
	- desc: sets the object's text
--]]---------------------------------------------------------
function newobject:SetText(text)

	self.text = text
	return self
	
end

--[[---------------------------------------------------------
	- func: GetText()
	- desc: gets the object's text
--]]---------------------------------------------------------
function newobject:GetText()

	return self.text
	
end

--[[---------------------------------------------------------
	- func: SetClickable(bool)
	- desc: sets whether the object can be clicked or not
--]]---------------------------------------------------------
function newobject:SetClickable(bool)

	self.clickable = bool
	return self
	
end

--[[---------------------------------------------------------
	- func: GetClickable(bool)
	- desc: gets whether the object can be clicked or not
--]]---------------------------------------------------------
function newobject:GetClickable()

	return self.clickable
	
end

--[[---------------------------------------------------------
	- func: SetClickable(bool)
	- desc: sets whether or not the object is enabled
--]]---------------------------------------------------------
function newobject:SetEnabled(bool)

	self.enabled = bool
	return self
	
end

--[[---------------------------------------------------------
	- func: GetEnabled()
	- desc: gets whether or not the object is enabled
--]]---------------------------------------------------------
function newobject:GetEnabled()

	return self.enabled
	
end

--[[---------------------------------------------------------
	- func: GetDown()
	- desc: gets whether or not the object is currently
	        being pressed
--]]---------------------------------------------------------
function newobject:GetDown()

	return self.down
	
end

--[[---------------------------------------------------------
	- func: SetToggleable(bool)
	- desc: sets whether or not the object is toggleable
--]]---------------------------------------------------------
function newobject:SetToggleable(bool)

	self.toggleable = bool
	return self

end

--[[---------------------------------------------------------
	- func: GetToggleable()
	- desc: gets whether or not the object is toggleable
--]]---------------------------------------------------------
function newobject:GetToggleable()

	return self.toggleable

end