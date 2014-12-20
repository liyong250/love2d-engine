
-------------------------------------------------
local menu = {}


local function loadUI( world )
	local w, h = love.window.getDimensions()
	world:call('create_ui', "menu")
	:AddOption("Begin", nil, function() love.state.switch( Data.states.game ) end)
	:AddOption("Exit", nil, function(x, y) love.event.quit() end)
	:SetPos( w / 2, h / 2 )
end
function menu:enter()
	-- 创建世界
	menu.world = love.entity.MakeEntity( Data.prefabs.menu )
	-- 创建UI
	loadUI( menu.world )
end
function menu:leave()
	-- 销毁游戏世界
	menu.world:rmcoms()
end
function menu:draw()
	-- 画背景世界
	menu.world:draw()
	-- 写字
	local oldFont = love.graphics.getFont()
	love.graphics.setFont(Data.font.big)
	love.graphics.printf("Tetris", 0, love.window.getHeight() / 3, love.window.getWidth(), 'center')
	love.graphics.setFont(Data.font.medium)
	love.graphics.printf("Block Busting Babes Premium!", 0, 
		love.window.getHeight() / 3 + 60, love.window.getWidth(), 'center')
	love.graphics.setFont(oldFont)
end
function menu:update(dt)
	menu.world:update(dt)
end
function menu:keypressed(key, r)
end
function menu:mousereleased(x, y, button)
end




return {menu = menu}
