local function loadUI( next_state )
	if not World then return end
	local w, h = love.window.getDimensions()
	local m = World:call('create_ui', "menu")
	m:AddOption("下一个测试", nil, function() love.state.switch( next_state ) end)
	m:AddOption("退出", nil, function(x, y) love.event.quit() end)
	m:CenterX()
	m:SetY(h - 120)
end

function love.load()
	-- 载入引擎
	require('engine')
	-- 载入数据
	Conf = require('save.config')
	Data = require('data')
	-- 设置背景色
	love.graphics.setBackgroundColor( 70, 50, 50, 255)

	-- test cases
	local test_states = {
		Data.states.test_launch_bullet,
		Data.states.test_mouse_on_image,
	}
	for index, state in ipairs(test_states) do
		local next_index = index + 1
		if index == #test_states then
			next_index = 1
		end
		local next_state = test_states[next_index]
		local old_enter = state.enter or (function()end)
		function state.enter(...)
			old_enter(...)
			World = love.entity.MakeEntity( Data.prefabs.test )
			loadUI(next_state)
		end
	end

	-- 进入游戏
	love.graphics.setFont(Data.font.ch18)
	love.state.switch(
		Data.states.logo, -- 显示logo
		{
		},
		Data.states.test,--test_states[1],
		nil) -- 显示菜单
end

function love.update(dt)
end
function love.draw()
end
function love.mousepressed(x, y, button)
end
function love.mousereleased(x, y, button)
end
function love.keypressed(key, isrepeat)
end
function love.keyreleased(key, isrepeat)
end
function love.textinput(text)
end
function love.resize(w, h)
end
function love.focus(f)
end
function love.quit()
	-- 调试使用
	if love.unhandledEvents then
		love.storage.save('unhandledEvents.lua', love.unhandled_events)
	end
end
