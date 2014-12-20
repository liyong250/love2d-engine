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
		-- 自动创建ui，自动销毁ui
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

function love.state.load(path, result)
	local states = assert(require(path))
	for name, state in pairs(states) do
		result[name] = state
		InitState(name, state)
	end
end