local guid = 1

-- 存档功能的实现


local function save(self, t)
	t.guid = self.guid
	for name, com in pairs(self:getcoms()) do
		if com.onsave then -- 不保存自己，要不然就是死递归了
			t[name] = {}
			com:onsave(t[name])
		end
	end
end


local function load_root_entity(self, t)
	if not t then return false end
	-- 载入存档
	local coms = self:getcoms()
	-- * 载入游戏世界的所有entity，从而获取一个guid到entity的转换表
	local obj_storage = coms['objects']
	local guid2entity
	if obj_storage then guid2entity = obj_storage:onload(t['objects']) end
	-- * 载入世界实体的其他组件（除了objects）
	for name, com in pairs(coms) do
		if com ~= obj_storage and com.onload then -- 不载入objects，要不然就是死递归了
			if t[name] then
				com:onload(t[name], guid2entity)
			end
		end
	end
	return true
end

local function load(self, t, guid2entity)
	if not t then return false end
	if not guid2entity then
		load_root_entity(self, t)
	else
		-- 载入存档
		for name, com in pairs(self:getcoms()) do
			if com.onload then -- 不载入自己，要不然就是死递归了
				if t[name] then
					com:onload(t[name], guid2entity)
				end
			end
		end
	end
	return true
end


-- 组件功能的实现
local function com(entity, name, ...)
	-- 创建组件
	local com_init_func = Data.components[name]
	assert(com_init_func, "Error loading component " .. name)
	local com = com_init_func(entity, ...)
	assert(com, "Error init component " .. name)
	-- 记录组件
	if com.ondraw then
		table.insert(entity._vcom, com) -- 按照顺序渲染
	end
	if entity._com[name] then
		love.util.trace( "WARNING", "Components duped", name)
	end
	entity._com[name] = com
end

local function rmcom(entity, name)
	local com = entity._com[name]
	if com.onremove then com:onremove() end
	entity._com[name] = nil
	if com.draw then
		for idx, vcom in pairs(entity._vcom) do
			if vcom == com then
				entity._vcom[idx] = nil
			end
		end
	end
end

-- 渲染和刷新
local function draw(entity)
	for _, vcom in pairs(entity._vcom) do
		vcom:ondraw()
	end
end
local function update(entity, dt)
	if entity._paused then return end
	for name, com in pairs(entity._com) do
		if com.onupdate then com:onupdate(dt) end
	end
end

-- 属性组件
local function bindattr(entity, name, func)
	assert(not entity._attr[name], name)
	entity._attr[name] = func
end

local function rmattr(entity, name)
	entity._attr[name] = nil
end

-- 事件组件
local function listen(entity, name, func)
	entity._event[name] = entity._event[name] or {}
	table.insert(entity._event[name], func)
end

local function deaf(entity, name, func)
	assert(entity._event[name])
	for idx, listener in pairs(entity._event[name]) do
		if listener == func then
			entity._event[name][idx] = nil
			return
		end
	end
	error("Unable to be deaf to " .. name)
end

local function attr(entity, name, parameter, ...)
	if entity._attr[name] then 
		return entity._attr[name](parameter, ...) 
	else
		love.util.trace('warning', 'unhandled attribute', name)
	end
end

local function emit(entity, name, ...)
	if entity._paused then return end
	if not entity._event[name] then 
		-- love.util.trace('warning', 'unhandled event', name)
		return 
	end
	local return_value
	local handled = false
	for _, listener in pairs(entity._event[name]) do
		handled = true
		return_value = {listener(...)}
	end
	if not handled then
		print("WARNING", "not handled emit", name)
	end
	if return_value then
		return unpack(return_value)
	end
end

local function rmcoms(entity)
	for name, com in pairs(entity._com) do
		entity:rmcom(name)
	end
end

local function MakeEntity(getinfo)
	-- 基本的entity
	t = 
	{
		_com = {},
		_vcom = {},
		_attr = {},
		_event = {},
		_paused = false,
		guid = guid,
		
		com = com,
		rmcom = rmcom,
		rmcoms = rmcoms,
		draw = draw,
		update = update,

		-- 只允许绑定一次。调用时有返回值。
		bindattr = bindattr,
		attr = attr,
		
		bindcall = bindattr,
		call = attr,
		
		-- 允许绑定多次。调用时无返回值。
		listen = listen,
		emit = emit,
		
		load = load,
		save = save,
	}
	function t:togglePause() self._paused = not self._paused end
	function t:getcoms() return self._com end
	-- 特化
	local info = getinfo()
	-- 添加组件
	if type(info.coms) == 'function' then
		local coms = info.coms()
		assert(type(coms) == 'table')
		for _, com in pairs(coms) do
			t:com(unpack(com))
		end
	end
	-- 初始化
	if type(info.init) == 'function' then
		info.init(t)
	end
	t.name = info.name
	-- 全局ID自增
	guid = guid + 1
	return t
end

love.entity = 
{
	MakeEntity = MakeEntity,
}	