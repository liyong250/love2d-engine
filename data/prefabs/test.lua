--[[
? 显示在菜单界面作为背景的一个游戏世界

]]


local function init(self)
	self:com('input_enabled', 'publisher')
	self:com('ui')
	self:com('grid', 30, 30, 50, 50,
			5, 5, 9)

	self:bindattr('cango', function(obj, x, y) return x, y end)
end
return init
