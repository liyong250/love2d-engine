--[[------------------------------------------------
	-- Love Frames - A GUI library for LOVE --
	-- Copyright (c) 2012-2014 Kenny Shields --
--]]------------------------------------------------

-- menu object
local newobject = loveframes.NewObject("menu", "loveframes_object_menu", true)

--[[---------------------------------------------------------
	- func: initialize()
	- desc: initializes the object
--]]---------------------------------------------------------
function newobject:initialize(menu)
	
	self.type = "menu"
	self.width = 80 -- 最小宽度
	self.height = 0
	self.largest_item_width = 0
	self.largest_item_height = 0
	self.is_sub_menu = false
	self.internal = false
	self.parentmenu = nil
	self.options = {}
	self.internals = {}
	
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
	local parent = self.parent
	local base = loveframes.base
	local update = self.Update
	
	-- move to parent if there is a parent
	if parent ~= base then
		self.x = self.parent.x + self.staticx
		self.y = self.parent.y + self.staticy
	end
	
	local cur_height = 0
	for k, v in ipairs(self.internals) do
		v:SetWidth(self.width)

		v:SetY( cur_height )
		cur_height = cur_height + v.height

		v:update(dt)
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
	local drawfunc = skin.DrawMenu or skins[defaultskin].DrawMenu
	local draw = self.Draw
	local drawoverfunc = skin.DrawOverMenu or skins[defaultskin].DrawOverMenu
	local drawcount = loveframes.drawcount
	
	-- set the object's draw order
	self:SetDrawOrder()
		
	if draw then
		draw(self)
	else
		drawfunc(self)
	end
	
	for k, v in ipairs(self.internals) do
		v:draw()
	end
	
	if drawoverfunc then
		drawoverfunc(self)
	end
	
end

--[[---------------------------------------------------------
	- func: mousepressed(x, y, button)
	- desc: called when the player presses a mouse button
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
	
	local internals = self.internals
	for k, v in ipairs(internals) do
		v:mousereleased(x, y, button)
	end

end

--[[---------------------------------------------------------
	- func: AddOption(text, icon, func)
	- desc: adds an option to the object
--]]---------------------------------------------------------
function newobject:AddOption(text, icon, func)

	local menuoption = loveframes.objects["menuoption"]:new(self)
	menuoption:SetText(text)
	menuoption:SetIcon(icon)
	menuoption:SetFunction(func)

	-- 动态调整菜单的尺寸，以便容纳菜单项
	local width = menuoption.width
	local height = menuoption.height
	if width > self.width then
		self.width = width
	end
	self.height = self.height + height

	table.insert(self.internals, menuoption)
	return self
	
end

--[[---------------------------------------------------------
	- func: RemoveOption(id)
	- desc: removes an option
--]]---------------------------------------------------------
function newobject:RemoveOption(id)

	for k, v in ipairs(self.internals) do
		if k == id then
			table.remove(self.internals, k)
			return
		end
	end
	
	return self
	
end

--[[---------------------------------------------------------
	- func: AddSubMenu(text, icon, menu)
	- desc: adds a submenu to the object
--]]---------------------------------------------------------
function newobject:AddSubMenu(text, icon, menu)

	local function activatorFunc(object)
		if menu:GetVisible() then
			local hoverobject = loveframes.hoverobject
			if hoverobject ~= object and hoverobject:GetBaseParent() ~= menu then
				menu:SetVisible(false)
			end
		else
			menu:SetVisible(true)
			menu:SetPos(object:GetX() + object:GetWidth(), object:GetY())
		end
	end
	
	menu:SetVisible(false)
	
	local menuoption = loveframes.objects["menuoption"]:new(self, "submenu_activator", menu)
	menuoption:SetText(text)
	menuoption:SetIcon(icon)
	
	if menu then
		menu.is_sub_menu = true
		menu.parentmenu = self
	end
	
	table.insert(self.internals, menuoption)
	return self
	
end

--[[---------------------------------------------------------
	- func: AddDivider()
	- desc: adds a divider to the object
--]]---------------------------------------------------------
function newobject:AddDivider()

	local menuoption = loveframes.objects["menuoption"]:new(self, "divider")
	
	table.insert(self.internals, menuoption)
	return self
	
end

--[[---------------------------------------------------------
	- func: GetBaseMenu(t)
	- desc: gets the object's base menu
--]]---------------------------------------------------------
function newobject:GetBaseMenu(t)
	
	local t = t or {}
	
	if self.parentmenu then
		table.insert(t, self.parentmenu)
		self.parentmenu:GetBaseMenu(t)
	else
		return self
	end
	
	return t[#t]
	
end

--[[---------------------------------------------------------
	- func: SetVisible(bool)
	- desc: sets the object's visibility
--]]---------------------------------------------------------
function newobject:SetVisible(bool)
	self.visible = bool
	
	if not bool then
		local internals = self.internals
		for k, v in ipairs(internals) do
			if v.menu then
				v.activated = false
				v.menu:SetVisible(bool)
			end
		end
	end
	
	return self
	
end