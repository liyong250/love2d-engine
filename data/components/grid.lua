
local function set_row_col(self, row, col, obj)
	self[row] = self[row] or {}
	self[row][col] = obj
end

local function get_obj_row_col(self, obj)
	local x, y = obj:attr('pos')
	return math.ceil(y / self.ch), math.ceil(x / self.cw)
end

local function insert_row_col(self, row, col, obj)
	self[row] = self[row] or {}
	self[row][col] = self[row][col] or {}
	self[row][col][obj] = true
end

local function set_obj(self, obj)
	local row, col = get_obj_row_col(self, obj)
	set_row_col(self, row, col, obj)
end

local function insert_obj(self, obj)
	local row, col = get_obj_row_col(self, obj)
	insert_row_col(self, row, col, obj)
end

local function get_row_col(self, row, col)
	return self[row] and self[row][col]
end

local function get_x_y(self, x, y)
	local row, col = math.ceil(y / self.ch), math.ceil(x / self.cw)
	return get_row_col(self, row, col)
end

local function remove_obj_by_row_col(self, row, col, obj)
	self[row][col][obj] = nil
end
local function remove_obj(self, obj)
	local row, col = get_obj_row_col(self, obj)
	self[row][col][obj] = nil
end

local function update_obj(self, obj, row, col)
	local new_row, new_col = get_obj_row_col(self, obj)
	if row == new_row and col == new_col then return end
	remove_obj_by_row_col(self, row, col, obj)
	insert_row_col(self, new_row, new_col, obj)
end

local function traverse(self, func, draw_cell)
	local size = math.ceil(self.size / 2)	
	for r = self.cr - size, self.cr + size do for c = self.cc - size, self.cc + size do
		local x, y = self.cw * c, self.ch * r

		if draw_cell then
			love.graphics.setColor(255,255,255,50)
			love.graphics.rectangle('line', x, y, self.cw, self.ch)
			love.graphics.setColor(255,255,255,250)
		end

		if self[r] and self[r][c] then
			local objs = self[r][c] 
			for obj in pairs(objs) do
				func(obj, r, c)
			end
		end
	end end
end
local function onupdate(self, dt)
	traverse(self, function(obj, r, c) update_obj(self, obj, r, c) end)
	traverse(self, function(obj) obj:update(dt) end)
end


local function ondraw(self)
	traverse(self, function(obj, r, c) obj:draw() end, true)
end

local function get_around_obj(self, obj, test_func, size)
	size = size or 4	
	test_func = test_func or function()return true end

	size = math.ceil(size / 2)
	local row,col = get_obj_row_col(self, obj)
	local res = {}
	for r = row - size, row + size do for c = col - size, col + size do
		local objs = get_row_col(self, r, c)	
		if objs then
			for obj in pairs(objs) do
				if test_func(obj) then
					table.insert(res, obj)
				end
			end
		end
	end end
	return res
end
local function onsave(self, t)
--[[	for entity in pairs(self._entities) do
		t[entity.name] = t[entity.name] or {}
		local sub = {}
		table.insert(t[entity.name], sub)
		entity:save(sub)
	end]]
end

local function onload(self, t)
	--[[
	local guid2entity = {}
	-- 创建所有entity，更新GUID，记录GUID和entity的对应关系。
	for name, datas in pairs(t) do
		for _, data in pairs(datas) do
			local entity = World:emit('spawn_entity', name)
			entity.guid = data.guid
			guid2entity[data.guid] = entity
		end
	end
	-- 对所有entity调用onload函数
	for name, datas in pairs(t) do
		for _, data in pairs(datas) do
			local entity = guid2entity[data.guid]
			entity:load(data, guid2entity)
		end
	end
	return guid2entity
	]]
end

local function create(owner, cell_width, cell_height, cnt_rows, cnt_cols, center_row, center_col, update_size)
	local t = {}
	t.cw = cell_width
	t.ch = cell_height
	t.nr = cnt_rows
	t.nc = cnt_cols
	t.cr = center_row
	t.cc = center_col
	t.size = update_size
	
	t.onupdate = onupdate
	t.ondraw = ondraw

	-- 发布事件
	local function remove(obj) 
		remove_obj(t, obj)		
	end
	local function spawn(name, x, y, ...)
		assert(x > 0 and y > 0, 'x,y='..x..','..y)
		local obj = love.entity.MakeEntity(Data.prefabs[name], x, y, ...)
		insert_obj(t, obj)
		-- 设置属性
		obj.remove = remove
		obj.name = name
		return obj;
	end
	local function get_around(obj, test_func, size)
		return get_around_obj(t, obj, test_func, size)
	end
	local function set_center(obj)
		local row, col = get_obj_row_col(t, obj)
		t.cr = row
		t.cc = col
	end

    owner:bindcall('spawn_entity', spawn)
    owner:bindcall('remove_entity', remove)
	owner:bindcall('get_around_obj', get_around)
	owner:bindcall('grid_set_center', set_center)

	return t
end

return create


