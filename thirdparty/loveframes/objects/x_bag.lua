--[[------------------------------------------------
	-- Love Frames - A GUI library for LOVE --
	-- Copyright (c) 2012-2014 Kenny Shields --
--]]------------------------------------------------

-- grid object
local newobject = loveframes.NewObject("bag", "loveframes_object_bag", true)

--[[---------------------------------------------------------
	- func: initialize()
	- desc: initializes the object
--]]---------------------------------------------------------
function newobject:initialize()
	
	self.type = "bag"
	self.width = 100
	self.height = 100
	self.prevwidth = 100
	self.prevheight = 100
	self.rows = 0
	self.columns = 0
	self.cellwidth = 25
	self.cellheight = 25
	self.cellpadding = 5
	self.itemautosize = false
	self.children = {}
	self.OnSizeChanged = nil
	
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
	
	local parent = self.parent
	local children = self.children
	local base = loveframes.base
	
	-- move to parent if there is a parent
	if parent ~= base then
		self.x = self.parent.x + self.staticx
		self.y = self.parent.y + self.staticy
	end
	
	local cw = self.cellwidth + (self.cellpadding * 2)
	local ch = self.cellheight + (self.cellpadding * 2)
	local prevwidth = self.prevwidth
	local prevheight = self.prevheight
		
	self.width = (self.columns * self.cellwidth) + (self.columns * (self.cellpadding * 2))
	self.height = (self.rows * self.cellheight) + (self.rows * (self.cellpadding * 2))
	
	if self.width ~= prevwidth or self.height ~= prevheight then
		local onsizechanged = self.OnSizeChanged
		self.prevwidth = self.width
		self.prevheight = self.height
		if onsizechanged then
			onsizechanged(self)
		end
	end
	
	for row = 1, self.rows do
		for col = 1, self.columns do
			if children[row] then
				local v = self.children[row][col]
				if v then
					local x = 0 + ((cw * v.gridcolumn) - cw ) + (cw/2 - v.width/2)
					local y = 0 + ((ch * v.gridrow) - ch) + (ch/2 - v.height/2)
					v.staticx = x
					v.staticy = y
					v:update(dt)
				end
			end
		end
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
	local drawfunc = skin.DrawGrid or skins[defaultskin].DrawGrid
	local draw = self.Draw
	local drawcount = loveframes.drawcount
	local children = self.children
	
	-- set the object's draw order
	self:SetDrawOrder()
		
	if draw then
		draw(self)
	else
		drawfunc(self)
	end
	
	for row = 1, self.rows do
		for col = 1, self.columns do
			if children[row] then
				local v = self.children[row][col]
				if v then
					v:draw()
				end
			end
		end
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
	
	local children = self.children
	local hover = self.hover
	
	if hover and button == "l" then
		local baseparent = self:GetBaseParent()
		if baseparent and baseparent.type == "frame" then
			baseparent:MakeTop()
		end
	end
	
	if self.OnClick then
		self:OnClick(x, y, button)
	end
	
	for row = 1, self.rows do
		for col = 1, self.columns do
			if children[row] then
				local v = self.children[row][col]
				if v then
					v:mousepressed(x, y, button)
				end
			end
		end
	end
end

function newobject:keypressed()
end
function newobject:textinput()
end
function newobject:keyreleased()
end

function newobject:InBagArea(x, y)
	local cell_w = self.cellwidth + self.cellpadding * 2
	local cell_h = self.cellheight + self.cellpadding * 2
	local w = cell_w * self.columns
	local h = cell_h * self.rows
	if x > self.x and x < self.x + w
		and y > self.y and y < self.y + h then
		return true
	else
		return false
	end
end
function newobject:GetRowCol(x, y)
	local w = self.cellwidth + self.cellpadding * 2
	local h = self.cellheight + self.cellpadding * 2
	local column = math.ceil((x - self.x) / w)
	local row = math.ceil((y - self.y) / h)
	return row, column
end
function newobject:GetItemByXY(x, y)
	return self:GetItem(self:GetRowCol(x, y))
end
function newobject:RobItemByXY(x, y)
	local row, col = self:GetRowCol(x, y)
	local item = self:GetItem(row, col)
	if item then
		self:RemoveItem(row, col)
		return item
	end
end
function newobject:AddOrReplaceItem(obj, x, y)
	local row, column = self:GetRowCol(x, y)
	local old_item = self:GetItem(row, column)
	self:AddItem(obj, row, column)
	return old_item
end

-- 添加失败返回false
function newobject:AddToFirstEmptySlot(obj)
	for row = 1, self.rows do
		for col = 1, self.columns do
			if (not self.children[row])
				or (not self.children[row][col]) then
				self:AddItem(obj, row, col)
				return true
			end
		end
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
	
	local visible  = self.visible
	local children = self.children
	
	if not visible then
		return
	end
	
	for row = 1, self.rows do
		for col = 1, self.columns do
			if children[row] then
				local v = self.children[row][col]
				if v then
					v:mousereleased(x, y, button)
				end
			end
		end
	end
	
end

--[[---------------------------------------------------------
	- func: AddItem(object, row, column)
	- desc: adds and item to the object
--]]---------------------------------------------------------
function newobject:AddItem(object, row, column)

	
	local itemautosize = self.itemautosize
	local children = self.children
	
	object:Remove()
	
	children[row] = children[row] or {}
	children[row][column] = children[row][column] or {}
	children[row][column] = object

	object.parent = self
	object.gridrow = row
	object.gridcolumn = column
	
	if itemautosize then
		local cw = self.cellwidth + (self.cellpadding * 2)
		local ch = self.cellheight + (self.cellpadding * 2)
		object.width = cw - (self.cellpadding * 2)
		object.height = ch - (self.cellpadding * 2)
	end
	
	return self
	
end

function newobject:RemoveItem(row, column)
	local obj = self.children[row][column]
	self.children[row][column] = nil
	return obj
end


--[[---------------------------------------------------------
	- func: GetItem(row, column)
	- desc: gets an item from the object at the specified
			row and column
--]]---------------------------------------------------------
function newobject:GetItem(row, column)
	if self.children[row] then
		return self.children[row][column]
	end
end

--[[---------------------------------------------------------
	- func: SetItemAutoSize(bool)
	- desc: sets whether or not the object should auto-size
			its items
--]]---------------------------------------------------------
function newobject:SetItemAutoSize(bool)

	self.itemautosize = bool
	return self
	
end

--[[---------------------------------------------------------
	- func: GetItemAutoSize()
	- desc: gets whether or not the object should auto-size
			its items
--]]---------------------------------------------------------
function newobject:GetItemAutoSize()

	return self.itemautosize
	
end

--[[---------------------------------------------------------
	- func: SetRows(rows)
	- desc: sets the number of rows the object should have
--]]---------------------------------------------------------
function newobject:SetRows(rows)

	self.rows = rows
	return self
	
end

--[[---------------------------------------------------------
	- func: SetRows(rows)
	- desc: gets the number of rows the object has
--]]---------------------------------------------------------
function newobject:GetRows()

	return self.rows
	
end

--[[---------------------------------------------------------
	- func: SetColumns(columns)
	- desc: sets the number of columns the object should
			have
--]]---------------------------------------------------------
function newobject:SetColumns(columns)

	self.columns = columns
	return self
	
end

--[[---------------------------------------------------------
	- func: GetColumns()
	- desc: gets the number of columns the object has
--]]---------------------------------------------------------
function newobject:GetColumns()

	return self.columns
	
end

--[[---------------------------------------------------------
	- func: SetCellWidth(width)
	- desc: sets the width of the object's cells
--]]---------------------------------------------------------
function newobject:SetCellWidth(width)

	self.cellwidth = width
	return self
	
end

--[[---------------------------------------------------------
	- func: GetCellWidth()
	- desc: gets the width of the object's cells
--]]---------------------------------------------------------
function newobject:GetCellWidth()

	return self.cellwidth

end

--[[---------------------------------------------------------
	- func: SetCellHeight(height)
	- desc: sets the height of the object's cells
--]]---------------------------------------------------------
function newobject:SetCellHeight(height)

	self.cellheight = height
	return self
	
end

--[[---------------------------------------------------------
	- func: GetCellHeight()
	- desc: gets the height of the object's cells
--]]---------------------------------------------------------
function newobject:GetCellHeight()

	return self.cellheight
	
end

--[[---------------------------------------------------------
	- func: SetCellSize(width, height)
	- desc: sets the size of the object's cells
--]]---------------------------------------------------------
function newobject:SetCellSize(width, height)

	self.cellwidth = width
	self.cellheight = height
	return self
	
end

--[[---------------------------------------------------------
	- func: GetCellSize()
	- desc: gets the size of the object's cells
--]]---------------------------------------------------------
function newobject:GetCellSize()

	return self.cellwidth, self.cellheight
	
end

--[[---------------------------------------------------------
	- func: SetCellPadding(padding)
	- desc: sets the padding of the object's cells
--]]---------------------------------------------------------
function newobject:SetCellPadding(padding)

	self.cellpadding = padding
	return self
	
end

--[[---------------------------------------------------------
	- func: GetCellPadding
	- desc: gets the padding of the object's cells
--]]---------------------------------------------------------
function newobject:GetCellPadding()

	return self.cellpadding
	
end