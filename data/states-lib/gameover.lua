--[[
author: God Guy
date: 2014/10/1
]]
local gameover = {}
local text = "GG~"
local btnBack, btnRestart, btnNext
function gameover:resize(w, h)
	btnBack:Remove()
	btnRestart:Remove()
	btnNext:Remove()

	gameover:load()
end
function gameover:loadUI()
	local x = love.window.getWidth() / 2
	local y = love.window.getHeight() / 2
	local btnGap = 30
	local btnWidth, btnHeight = 150, 50
	local textY = love.window.getHeight() / 2 - btnHeight / 2 - 10

	btnBack = loveframes.Create("button")
		:SetSize(btnWidth, btnHeight):SetText("Back")
	btnBack.OnClick = function(object, dt)
		    GameState.switch(States.menu)
		end
	btnRestart = loveframes.Create('button')
		:SetSize(btnWidth, btnHeight):SetText("Restart")
	btnRestart.OnClick = function(object, dt)
		    GameState.switch(States.pregame)
		end
	btnNext = loveframes.Create('button')
		:SetSize(btnWidth, btnHeight):SetText("Next Level")
	btnNext.OnClick = function(object, dt)
			if gameover.moreLevel then
			    GameState.switch(States.pregame)
			else
			    GameState.switch(States.msgbox, "How extraordinary YOU are!\n\nMore levels are comming...\nPress enter to quit", "^_^", "quit")
			end
		end

	loveframes.GridPlacer(
		love.window.getWidth() / 2 - btnWidth * 1.5 - 10, love.window.getHeight() / 2,
		btnWidth, btnHeight,
		3,
		10, 10,
		btnBack, btnRestart, btnNext)
end
function gameover:enter(last_state, param)
	if type(param) == 'string' then -- pressed a key
		GameState.switch(States.menu)
		return
	end
	local gamescore = param
	text = "You got " .. gamescore .. " people!\n\n"
	local passpoint = Levels.CurLevel().passpoint
	if gamescore >= passpoint then
		text = text .. "Congratulation!"
		btnNext:SetEnabled(true)
		love.audio.play(Snd.win)
		gameover.moreLevel = Levels.Next()
	else
		text = text .. "But less than " .. passpoint .. ", try again!"
		love.audio.play(Snd.gameover)
		btnNext:SetEnabled(false)
	end
end
function gameover.leave()
	love.audio.stop(Snd.gameover)
end
function gameover:draw()
	love.graphics.printf(text, 0, love.window.getHeight() / 2 - 100, love.window.getWidth(), 'center')
end

function gameover:update()
end
function gameover:mousepressed(x, y, button)
end

return {gameover = gameover}