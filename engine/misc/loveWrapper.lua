-- 对Love功能的改造（没有增强）

-- 增加禁止键盘输入功能，因为model框显示的时候主角不能动
local oldIsDown = love.keyboard.isDown
love.keyboard.disabled = false
love.keyboard.isDown = 
	function(...)
		if love.keyboard.disabled then
			return false
		end
		return oldIsDown(...)
	end

-- 自动渲染很更新
local autoUpdateFuncs = {}
local autoDrawFuncs = {}
function love.autoUpdate(param)
	if type(param) == 'function' then
		table.insert(autoUpdateFuncs, param)
	else-- type(param) == 'number'
		for _, func in pairs(autoUpdateFuncs) do
			func(param)
		end
	end
end
function love.autoDraw(param)
	if param then
		table.insert(autoDrawFuncs, param)
	else
		for _, func in pairs(autoDrawFuncs) do
			func()
		end
	end
end

