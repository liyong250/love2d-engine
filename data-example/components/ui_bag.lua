--[[
* 实现功能描述
	* 构建一个背包控件到游戏界面。
	* 这个组件应当被应用到游戏界面，而不是某个人物。
	* 背包的item必须是一个UI控件。
* 目标Entity必须
* 属性
* 方法
	* bag_add_item 添加item
* 接受的事件
* 其他强制要求
* 用法示例
]]

local function create(owner, row, col, x, y, cell_w, cell_h, padding)
	local bag_obj = owner:call('create_ui', "bag")
	bag_obj:SetPos(x, y)
	bag_obj:SetRows(row or 4)
	bag_obj:SetColumns(col or 4)
	bag_obj:SetCellWidth(cell_w or 80)
	bag_obj:SetCellHeight(cell_h or 50)
	bag_obj:SetCellPadding(padding or 5)
	bag_obj:SetItemAutoSize(true)

	local function add_item(item, row, col)
		if row then
			bag_obj:AddItem(item, row, col)
		else
			return bag_obj:AddToFirstEmptySlot(item, row, col)
		end
	end
	function bag_obj:OnClick(x, y, button)

		-- 左键选中物体
		if button == 'l' then
			if not bag_obj:InBagArea(x, y) then return end

			local mouseobject = owner:attr('mouseobject')
			if mouseobject then 
				local old_item = self:AddOrReplaceItem(mouseobject, x, y)
				if old_item then
					owner:emit('add_mouseobject', old_item)
				else
					owner:emit('rm_mouseobject')
				end
			else
				local item = self:GetItemByXY(x, y)
				if item then
					owner:emit('add_mouseobject', item)
				end
			end
		-- 右键释放物体
		elseif button == 'r' then
			owner:emit('rm_mouseobject')
			--[[
			local item = owner:attr('ui', 'bagitem')
			add_item(item)
			]]
		end
	end

	owner:bindattr('bag_add_item', add_item)

	return {}
end

return create