--[[
* 实现功能描述
	* 给物体添加颜色
* 目标Entity必须
* 属性
* 方法
* 接受的事件
* 其他强制要求
* 用法实例
]]


--[[
mode
	添加颜色的样式，目前支持
	* colored 改变颜色
param
	不同的mode对应不同的param定义，分别是：
	* colored
		{red = ?, green = ?, blue = ?, alpha = ?}
]]
local function create(t, mode, param)
	if mode ~= 'colored' then
		error("Unknown colored mode")
	end

	local r, g, b, a = param.red, param.green, param.blue, param.alpha
	local old_draw = t.draw
	function t.draw(...)
		love.graphics.setColor(r, g, b, a)
		old_draw(...)
		love.graphics.setColor(255, 255, 255, 255)
	end
	return {}
end

return create