local TimerUtil = Timer
local shine = {}

-- 终止
function shine.cancel(handle)
	if handle then TimerUtil.cancel(handle) end
end

-- 终止，但是会调用finalFunc
function shine.cancelWithFinalize(handle)
	if handle then TimerUtil.cancelWithFinalize(handle) end
end

-- must:
-- drawable必须包含draw函数
-- colors 每种color都是一个table，例如不透明的红色{255,0,0,255}
-- optional:
-- finalFunc是停止变颜色的时候被调用的函数
-- duration表示隔几秒变一下颜色
-- totalSeconds表示隔了多久之后停止变换颜色
-- finalFuncParam finalFunc的唯一参数
-- return:
-- 一个handle，可以传递给cancel函数以取消闪烁
function shine.shine(drawable, colors, 
		finalFunc, duration, totalSeconds, finalFuncParam) -- colors
	-- 默认值
	duration = duration or .1
	totalSeconds = totalSeconds or 1
	-- 初始化
	local oldDraw = drawable.draw
	local colorIndex = 1
	drawable.draw = 
		function(...)
			local oldColor = {love.graphics.getColor()}
			love.graphics.setColor(unpack(colors[colorIndex]))
			oldDraw(...)
			love.graphics.setColor(unpack(oldColor))
		end
	local timer = 0
	return TimerUtil.do_for(
						totalSeconds, 
						function(dt)
							timer = timer + dt
							if timer > duration then
								timer = 0
								colorIndex = colorIndex + 1
								if colorIndex > #colors then
									colorIndex = 1
								end
							end
						end,
						function()
							drawable.draw = oldDraw
							if finalFunc then
								finalFunc(finalFuncParam)
							end
						end
					)
end

return shine
--[[
example:

shine.shine(
		image,
		{
			{255, 0, 0, 255},
			{0, 255, 0, 255},
		}
	)
]]