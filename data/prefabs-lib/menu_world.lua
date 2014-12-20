--[[
? 显示在菜单界面作为背景的一个游戏世界

]]



return
{
	coms = 
	function()
		return
		{
			-- 可视化组件
			--{'objects'},	-- 管理游戏中的事物
			{'bk_image', Data.img.menubg.img, 'repeat_moving', {dx = 1, dy = -1, speed = 1}}, -- 以图片作为背景
			{'ui'}, -- 使用图形界面控件
			--{'ui_bag', 5, 5}, -- 创建背包
			--{'mouseobject'}, -- 鼠标上可以放一个物体

			-- 逻辑组件
		}
	end
}