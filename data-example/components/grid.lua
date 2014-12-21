--[[
* 实现功能描述
	* 提供一个网格存储模型。可以按照行列号来存储和读取变量。
* 目标Entity必须
* 属性
	* grid_row_col(row, col) 读取grid[row][col]处的内容
	* grid_row_col(row, col, obj) 将obj存储到grid[row][col]
* 方法
* 接受的事件
* 其他强制要求
* 用法示例
]]

local function ondraw(self)
	for row = 0, self.cnt_row do
		local y = row * self.cell_h
		love.graphics.line(0, y, self.w, y)
		for col = 0, self.cnt_col do
			local x = col * self.cell_w
			love.graphics.line(x, 0, x, self.h)
			if self.grid[row] and self.grid[row][col] then
				love.graphics.rectangle('fill', y, x, self.cell_w, self.cell_h)
			end
		end
	end
end

local function create(owner, cell_w, cell_h, cnt_row, cnt_col)
	cell_h = cell_h or 32
	cell_w = cell_w or 32

	local t = 
	{
		cnt_col = cnt_col or math.ceil(love.window.getWidth() / cell_w),
		cnt_row = cnt_row or math.ceil(love.window.getHeight() / cell_h),
		grid = {},
	}
	owner:bindattr('grid_row_col',
		function(row, col, new_obj)
			if type(new_obj) == 'boolean' then
				-- setter
				t.grid[row] = t.grid[row] or {}
				t.grid[row][col] = new_obj
			else
				if t.grid[row] then
					return t.grid[row][col]
				end
			end
		end)
	owner:bindcall('grid_show_up',
		function(cell_w, cell_h)
			t.cell_w = assert(cell_w)
			t.cell_h = assert(cell_h)
			t.w = cell_w * t.cnt_col
			t.h = cell_h * t.cnt_row

			t.ondraw = ondraw
		end)

	return t
end

return create