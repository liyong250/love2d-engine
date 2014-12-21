
-------------------------------------------------
local menu = {}


local function loadUI( world )
	local w, h = love.window.getDimensions()
	world:call('create_ui', "menu")
	:AddOption("Begin", nil, function() love.state.switch( Data.states.logo, {}, Data.states.menu ) end)
	:AddOption("Exit", nil, function(x, y) love.event.quit() end)
	:SetPos( w / 2, h / 2 )
end
function menu:enter()
	-- 创建世界
	World = love.entity.MakeEntity( Data.prefabs.menu )
	menu.world = World
	love.world = World
	-- 创建UI
	loadUI( menu.world )
end
function menu:leave()
	-- 销毁游戏世界
	World:rmcoms()
end
function menu:draw()
	-- 画背景世界
	World:draw()
end
function menu:update(dt)
	World:update(dt)
end
function menu:keypressed(key, r)
end
function menu:mousereleased(x, y, button)
end
function menu:mousepressed()
	local mx, my = love.mouse.getPosition()
	World:call('spawn_entity', 'bullet', mx, my, 200, 100, 450 + 100 * math.random())
end



return {menu = menu}
