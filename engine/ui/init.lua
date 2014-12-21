require("thirdparty.loveframes")
love.ui = loveframes

-- 需要被调用的loveframes函数
local funcs_need_wrap = 
{
	'update', 'draw', 'mousepressed', 
	'mousereleased', 'keypressed',
	'keyreleased', 'textinput'
}
for _, func in pairs(funcs_need_wrap) do
	if love.ui[func] then
		local old_func = love[func]
		love[func] = function(...) 
			old_func(...) 
			love.ui[func](...) end
	end
end

--[[
扩展的UI元素 
]]

-- 创建菜单
function love.ui.createMenu(world, btns, x, y, w, h)
	local grid = world:attr('create_ui', "grid")
	grid:SetPos( x or 0, y or 0 )
	grid:SetRows( #btns )
	grid:SetColumns( 1 )
	grid:SetCellWidth( w or 100 )
	grid:SetCellHeight( h or 50 )
	grid:SetCellPadding( 5 )
	grid:SetItemAutoSize( true )

	for index, btnInfo in pairs(btns) do
		local btn = world:attr('create_ui', 'button'):SetText( btnInfo[1] )
		btn.OnClick = btnInfo[2]
		grid:AddItem(btn, index, 1)
	end
end
