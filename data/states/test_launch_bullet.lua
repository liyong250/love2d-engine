
-------------------------------------------------
local menu = {}
local targetx, targety = 200, 200

function menu:leave()
	World:rmcoms()
end
function menu:draw()
	World:draw()
	love.graphics.setColor(255,255,255)
	love.graphics.rectangle('line', targetx - 20, targety - 20, 60, 60)
	love.graphics.print("【鼠标右键】 设置攻击目标\n【其他鼠标按键】 发射子弹(launch bullets)", 10, 10)
end
function menu:update(dt)
	World:update(dt)
end
function menu:keypressed(key, r)
end
function menu:mousereleased(x, y, button)
end

function menu:mousepressed(x, y, btn)
	local mx, my = love.mouse.getPosition()
	if btn == 'r' then
		targetx, targety = mx, my
	else
		World:call('spawn_entity', 'bullet', mx, my, targetx, targety, 250 + 200 * math.random())
	end
end



return {test_launch_bullet = menu}
