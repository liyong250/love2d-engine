--[[
* 实现功能描述
	* 添加此组件publisher功能才能使游戏可以接受输入
	* 添加此组件listener的物体才能接受IO输入
* 目标Entity必须
	* emit: move( dx, dy )
	* attr-read: pos()
* 属性
* 方法
* 接受的事件
	* publishInputEvents( events )
		events的格式为 {event_name={parameters}, event_name2={parameters2}, ...}
* 发布的事件
	* update中进行检测并发布的事件
* 其他强制要求
	* 必须根据实际需求修改update，确认需要发布哪些输入事件
	* publisher must be the World
* 用法实例
]]


local created = false

local function publish_events(self, ...)
	for _, event in pairs( {...} ) do
		for listener in pairs(self.listeners) do
			listener:emit( unpack( event ) )
		end
	end	
end

local function update(self, dt)
	-- 生成输入
	local events = {}
	-- 发布输入
	--publish_events(self, unpack(events))
end

local function onremove_publisher(com)
	created = false
end

local function publisher(t)
	assert(not created, "The component input_enabled for publisher can only be used once!")

	local res =
	{
		onupdate = update,
		onremove = onremove_publisher,
		
		owner = t,
		listeners = {},
	}

	t:listen('!addInputListener', 
		function (listener)
			res.listeners[listener] = true
		end)
	t:listen('!removeInputListener',
		function (listener)
			res.listeners[listener] = false
		end)
	t:bindcall('publishInputEvents',
		function( ... )
			publish_events(res, ...)
		end)

	created = true
	return res
end

local function onremove_listener(com)
	com.owner:emit('!removeInputListener', com.owner)
end

local function listener(t)
	World:emit('!addInputListener', t)	-- 让属主可以监听事件
	return 
		{
			owner = t,

			onremove = onremove_listener,
		}
end

local function publisher_and_listener(t)
	local res = publisher(t)
	t:emit('!addInputListener', t)	-- 让属主可以监听事件
	function res.remove(com)
		onremove_publisher(com)
		onremove_listener(com)
	end
	return res
end

local function create(t, role)
	if role == 'publisher' then
		return publisher(t)
	elseif role == 'listener' then
		return listener(t)
	elseif role == 'publisher and listener' then
		return publisher_and_listener(t)
	end
	error("Unknown role for component input_enabled <" .. role .. ">")
end

return create
