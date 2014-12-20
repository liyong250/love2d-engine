
-------------------------------------------------
local menu = {}

function menu:loadUI(world)

	
	local btns = 
		{ -- 按钮文本和点击事件
			{
				'Begin',
				function()
					love.state.switch(Data.states.game)
					love.audio.stop(Data.sound.menu_background)
				end
			},
			{
				'Help',
				function()
					love.state.switch(Data.states.setup)
				end
			},
			{	
				'Exit',
				function(x, y)
					love.event.quit()
				end
			},
		}


	local grid = world:attr('create_ui', "grid")
	grid:SetPos(love.window.getWidth() - 100 - 50, love.window.getHeight() - 4 * 50 - 100)
	grid:SetRows(#btns)
	grid:SetColumns(1)
	grid:SetCellWidth(100)
	grid:SetCellHeight(50)
	grid:SetCellPadding(5)
	grid:SetItemAutoSize(true)

	for index, btnInfo in pairs(btns) do
		local btn = world:attr('create_ui', 'button'):SetText(btnInfo[1])
		btn.OnClick = btnInfo[2]
		grid:AddItem(btn, index, 1)
	end


	local btn = world:attr('create_ui', 'button'):SetText('Music On'):SetPos(10, 10):SetSize(120, 30)
	function btn.OnClick(x, y)
		if Conf.music_on then
			Conf.music_on = false
			btn:SetText('Music On')
		else
			Conf.music_on = true
			btn:SetText('Music Off')
		end
	end
end
function menu:enter()
	love.util.trace('Entering menu')
	Data.sound.menu_background:setLooping(true)
	Data.sound.menu_background:play()

	-- 创建世界
	local world = love.entity.MakeEntity(Data.prefabs.menu_world)
	menu.menuworld = world
	menu:loadUI(world)
end
function menu:leave()
	Data.sound.menu_background:stop()

	-- 销毁游戏世界
	menu.menuworld:rmcoms()
	menu.menuworld = nil
end

function menu:draw()
	-- 画背景世界
	menu.menuworld:draw()
	-- 写字
	local oldFont = love.graphics.getFont()
	love.graphics.setFont(Data.font.big)
	love.graphics.printf("Extreme Snakie", 0, love.window.getHeight() / 3, love.window.getWidth(), 'center')
	love.graphics.setFont(Data.font.medium)
	love.graphics.printf("Collect as many people as you can!", 0, 
		love.window.getHeight() / 3 + 60, love.window.getWidth(), 'center')
	love.graphics.setFont(oldFont)
end
function menu:update(dt)
	menu.menuworld:update(dt)
end
function menu:mousepressed(x, y, button)
end
function menu:mousereleased(x, y, button)
end

-------------------------------------------------

local setup = {}

function setup:loadUI()
end
function setup:enter()
	Data.sound.menu_background:setLooping(true)
	love.audio.play(Data.sound.menu_background)
end
function setup:leave()
end
function setup:draw()
end
function setup:update(dt)
end
function setup:mousepressed(x, y, button)
	love.state.switch(Data.states.menu)
end

return {setup = setup, menu = menu}
