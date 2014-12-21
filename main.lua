
function love.load()
	-- 载入引擎
	require('engine')
	-- 载入数据
	Conf = require('save.config')
	Data = require('data')
	-- 设置背景色
	love.graphics.setBackgroundColor( 70, 50, 50, 255)
	-- 进入游戏
	love.graphics.setFont(Data.font.ch24)
	love.state.switch(
		Data.states.logo, -- 显示logo
		{
		},
		Data.states.menu) -- 显示菜单
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
	love.storage.save('unhandledEvents.lua', love.unhandled_events)
end
