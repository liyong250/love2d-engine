--[[
游戏状态的控制。
每个状态配置一个 事件中心 和一个 时钟。
]]

love.state = require('thirdparty.hump.gamestate')
--love.state.registerEvents()


local function InitState(modName, module)
	local oldEnter = module.enter
	local oldLeave = module.leave
	local oldUpdate = module.update
	local function newUpdate(module, dt)
		module.timer:update(dt)
		if oldUpdate then oldUpdate(module, dt) end
	end
	if oldEnter then
		module.leave =
			function(...)
				if oldLeave then oldLeave(...) 	end
				module.timer = nil
				module.event = nil
			end
		module.enter = 
			function(...)
				module.event = love.signal:new()
				module.timer = love.timer.new()
				if oldEnter then oldEnter(...) end
			end
		module.update = newUpdate
		-- 记录状态名称
		module.name = modName
	end
	return module
end

--[[
载入path标识的状态定义文件到result中。
目的是对State进行统一的初始化。
]]
function love.state.load(path, result)
	local states = assert(require(path))
	for name, state in pairs(states) do
		result[name] = state
		InitState(name, state)
	end
end