--[[
* 实现功能描述
	entity管理模块的标准实现。如需自定义，则必须实现：
		*必须注册的方法：
			* spawn( entity_name ) 返回 entity_object
			* remove( entity_object ) 返回值自定义
		* 必须发布的事件：
			* spawn_entity( entity )
		* spanw_entity返回的entity_object必须具有的属性：
			* name 用来创建该实体的名称
* 目标Entity必须具有的属性和事件
	无
* 向目标Entity上添加的属性和事件
	spawn_entity(entity_name)
	remove_entity(entity_object)
* 其他强制要求
	该组件应当应用于“世界”实体。该实体用来管理整个游戏。
* 用法示例
	* 添加一个objects组件，其管理的object的绘制是乱序的。
		{'objects'}
	* 添加一个objects组件，其管理的object按照它们的数值属性'z'的大小来绘制
		{'objects', 'z'}
]]

local function onremove(self)
	self._entities = {}
end

local function onupdate(self, dt)
	for entity in pairs(self._entities) do
		entity:update(dt)
	end
end

local function onsave(self, t)
	for entity in pairs(self._entities) do
		t[entity.name] = t[entity.name] or {}
		local sub = {}
		table.insert(t[entity.name], sub)
		entity:save(sub)
	end
end

local function onload(self, t)
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
end

local function ondraw_normal(self)
	for prefab in pairs(self._entities) do
	if prefab.draw == nil then
		print(prefab)
		for k,v in pairs(prefab) do print(k,v) end
		os.exit(0)
	else
		prefab:draw()
	end
	end
end

local function ondraw_by_z(self)
	-- 先排序实体
	local sorttable = {}
	for prefab in pairs(self._entities) do
		table.insert(sorttable, prefab)
	end
	table.sort(sorttable, function(p1, p2) return p1:attr('z') < p2:attr('z') end)
	-- 再绘制实体
	for _, prefab in pairs(sorttable) do
		prefab:draw()
	end
end

local function create(t, draw_order_by)
	-- 定义结构体
	local res = 
	{
		_entities = {},

		onremove = onremove, 
		onupdate = onupdate,
		onsave = onsave,
		onload = onload,
	}

	if type(draw_order_by) == 'string' then
		res.ondraw = ondraw_by_z
		res.pos_attr_name = draw_order_by
	else
		res.ondraw = ondraw_normal
	end

	-- 发布事件
	local function remove(t) 
		res._entities[t] = nil
	end

	local function spawn(name, ...)
		local t = love.entity.MakeEntity(Data.prefabs[name], ...)
		res._entities[t] = true;
		-- 设置属性
		t.remove = remove
		t.name = name
		return t;
	end

    t:bindcall('spawn_entity', spawn)
    t:bindcall('remove_entity', remove)
	return res
end

return create


