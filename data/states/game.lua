-------------------------------------------------
local game = {}

local save_key = 'SaveSlot11'
local counter

function game:enter(last)
	game.world = love.entity.MakeEntity( Data.prefabs.game )
	game.world:bindcall('game over',
		function()
			love.state.togglePause() 
			love.storage.remove( save_key )
			love.state.switch( Data.states.gameover )
		end)

	local storage = love.storage.load( save_key )
	if storage then
		game.world:load( storage )
	else
		-- 没有存档时，按照固定方式来初始化游戏世界
	end

	counter = 3
	game.timer:add(
		1,
		function( func )
			counter = counter - 1
			if counter > 0 then
				game.timer:add( 1, func )
			else
				game.world:call( 'toggle_pause' )
			end
		end)
end

function game:draw()
	game.world:draw()
	if counter > 0 then
		local w = love.window.getWidth()
		love.graphics.setFont( Data.font.medium )
		love.graphics.printf( "get yourself ready...",
			0,-- window_width / 2 - rectangle_width / 2
			love.window.getHeight() / 2,
			w,
			'center')
		-- 倒计时的时间
		love.graphics.setColor( 100 + 155 * math.random(),
			100 + 150 * math.random(),
			200,
			255)
		love.graphics.setFont( Data.font.big )
		love.graphics.printf( tostring( counter ),
			0,
			love.window.getHeight() / 2 - 70,
			w,
			'center')

		love.graphics.setColor( 255, 255, 255, 255 )
	end
end

function game:update(dt)
	game.world:update(dt)
end

function game:leave()
	love.state.pause( false ) 
end

local function save_game()
	local t = {}
	game.world:save( t )
	love.storage.save( save_key, t )
end

local menu
function game:keypressed(key, isrepeat)
	if counter > 0 then return end -- 倒计时状态
	if key == 'escape' then
		love.state.togglePause()
		if menu then 
			menu:Remove() 
			menu = nil
		else
			menu = game.world:call('create_ui', "menu")
			menu:AddOption("Resume", nil, 
				function() 
					love.state.togglePause() 
					menu:Remove()
					menu = nil
				end)
			menu:AddOption("Save & Exit", nil, 
				function() 
					save_game() 
					love.state.togglePause() 
					menu:Remove()
					menu = nil
					game.world:rmcoms()
					love.state.switch( Data.states.menu ) 
				end)
			menu:Center()
		end
	else
		if not game.update then return end -- 暂停状态
		game.world:call( 'publishInputEvents', {'key pressed', key})
	end
end

----------------------------------------------------------------------

local gameover = {}
local postshader

function gameover:enter()
	local menu = love.ui.Create("menu")
	menu:AddOption("Restart", nil, 
		function()
			love.state.switch( Data.states.game )
			menu:Remove()
			menu = nil
		end)
	menu:AddOption("Back to menu", nil, 
		function()
			love.state.switch( Data.states.menu ) 
		end)
	menu:Center()
	gameover.menu = menu

	postshader = love.lightworld.postshader()
    postshader:toggleEffect("scanlines")
	postshader:toggleEffect("blur", 2.0, 2.0)
end

function gameover:leave()
	-- 删除世界
	game.world:rmcoms()
	gameover.menu:Remove()
end

local postshader_canvas = love.graphics.newCanvas( love.window.getWidth(), love.window.getHeight())

function gameover:draw()
	postshader_canvas:clear()
	love.graphics.setCanvas( postshader_canvas )
	game:draw() 
	love.graphics.setCanvas()

	postshader:drawWith( postshader_canvas )
end

return {game = game, gameover = gameover}
