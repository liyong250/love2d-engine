--[[
? 显示在菜单界面作为背景的一个游戏世界

]]


local function init(self)
	self:bindattr('cango', function(obj, x, y) return x, y end)
end
return
{
	coms = 
	function()
		return
		{
			--{'bk_image', Data.img.menubg.img, 'repeat_moving', {dx = 1, dy = -.6, speed = .1}}, 
			{'ui'}, 
			{'objects'},
		}
	end,
	init = init
}