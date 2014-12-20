--[[
此状态用来展示游戏启动时的logo
]]

local t = {}
local FADE_DURATION = .9

function t.fade_in()
	t.timer:tween(
		FADE_DURATION,
		t.alpha,
		{255},
		'linear',
		function()
			t.timer:addPeriodic(
				t.duration,
				t.fade_out,
				1)
		end
		)
end
function t.fade_out()
	t.timer:tween(
		FADE_DURATION,
		t.alpha,
		{0},
		'linear',
		function()
			if t.drawable_index == #t.drawable_list then
				love.state.switch(t.next_state)
			else
				t.drawable_index = t.drawable_index + 1
				t.drawable = t.drawable_list[t.drawable_index]
				t.fade_in()
			end
		end
		)
end

function t:draw()
	love.graphics.setColor(255, 255, 255, self.alpha[1])

	local w, h = t.drawable:getWidth(), t.drawable:getHeight()
	local x = (love.window.getWidth() - w) / 2
	local y = (love.window.getHeight() - h) / 2
	t.drawable:draw(x, y)

	love.graphics.setColor(255, 255, 255, 255)
end

function t:update(dt)
	if t.drawable.update then
		t.drawable:update(dt)
	end
end

function t:enter(pre, drawable_list, next_state, duration)
	if #drawable_list == 0 then
		love.util.trace("WARNING", "No fading-pictures specified")
		love.state.switch(next_state)
	else
		t.next_state = next_state
		t.duration = duration or 1
		t.drawable_list = drawable_list
		t.drawable_index = 1
		t.drawable = drawable_list[1]
		t.alpha = {0}

		t.fade_in()
	end
end

function t:keypressed()
	love.state.switch(t.next_state)
end


return {logo = t}