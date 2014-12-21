--[[
? 显示在菜单界面作为背景的一个游戏世界

]]


local function init(self)
	self:com('ui')
	self:com('objects')

	self:bindattr('cango', function(obj, x, y) return x, y end)
end
return init
