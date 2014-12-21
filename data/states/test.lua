
-------------------------------------------------
local menu = {}
local targetx, targety = 200, 200
local move_anim = "walk"

function menu:enter()
	World = love.entity.MakeEntity( Data.prefabs.test )
end
function menu:leave()
	World:rmcoms()
end
function menu:draw()
	World:draw()
	love.graphics.setColor(255,255,255)
	love.graphics.print("【鼠标left键】 move!\n【Right] toggle walk/run;\n[space] spawn a hero", 10, 10)
end
function menu:update(dt)
	World:update(dt)
	if love.mouse.isDown('l') then
		local mx, my = love.mouse.getPosition()
		World:call('publishInputEvents', {'move to', mx, my})
	end
end
function menu:keypressed(key, r)
	if r then return end
	if not hero and key == ' ' then
		local mx, my = love.mouse.getPosition()
		hero = World:call('spawn_entity', 'hero', mx, my, 200)
	end
	if hero then
		if key == 'p' then
			World:call('publishInputEvents', {'plant'})
		elseif key == 'c' then
			World:call('publishInputEvents', {'chop'})
		end
	end
end
function menu:mousereleased(x, y, button)
end

function menu:mousepressed(x, y, btn)
	if not hero then return end
	local mx, my = love.mouse.getPosition()
	if btn == 'r' then
		World:call('publishInputEvents', {'move change'})
	end
end



return {test = menu}
