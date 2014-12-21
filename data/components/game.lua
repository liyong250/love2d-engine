local t = {}
local basic_color = {150, 10, 150, 255}
local grid_canvas

local SCORES_PER_LEVEL = 7 -- 每多少分增加一级

local function onsave(com, data)
	data.score = com.score
	data.level = com.level

	for r = 1, com.n_row do
		for c = 1, com.n_col do
			if com.grid[r] and com.grid[r][c] then
				com.grid[r][c] = true
			end
		end
	end
	data.grid = com.grid

	com.cur.girl = nil
	data.cur = com.cur
	
	com.coming.girl = nil
	data.coming = com.coming
end


local function get_girl( idx )
	return Data.img[ 'cell (' .. idx .. ')' ]
end
local function get_random_girl()
	return get_girl( math.random(8) )
end

local function onload(com, data, id2ent)
	com.score = data.score
	t.set_level( com, data.level )

	com.grid = data.grid
	for r = 1, com.n_row do
		for c = 1, com.n_col do
			if data.grid[r] and data.grid[r][c] then
				com.grid[r][c] = get_random_girl()
			end
		end
	end

	com.cur = data.cur
	com.cur.girl = {}
	for i = 1, 4 do
		com.cur.girl[i] = get_random_girl()
	end

	com.coming = data.coming
	com.coming.girl = {}
	for i = 1, 4 do
		com.coming.girl[i] = get_random_girl()
	end
end

local function draw_cell( img, r, c)
	r = r + 1
	c = c + 1
	img:draw( c * w_cell, r * h_cell )
end

local kinds =
{
line = 
{
	{{0, -2}, {0, -1}, {0, 0}, {0, 1}},
	{{-2, 0}, {-1, 0}, {0, 0}, {1, 0}},
},
block = 
{
	{{0, 0}, {0, 1}, {1, 1}, {1, 0}},
},
raised = 
{
	{{-1,0},{0,0},{1,0},{0,-1}},
	{{-1,0},{0,0},{0,1},{0,-1}},
	{{-1,0},{0,0},{1,0},{0,1}},
	{{1,0},{0,0},{0,1},{0,-1}},
},
left_check = 
{
	{{-1,1},{-1,0},{0,0},{1,0}},
	{{0,-1},{0,0},{0,1},{1,1}},
	{{1,-1},{1,0},{0,0},{-1,0}},
	{{-1,-1},{0,-1},{0,0},{0,1}},
},
right_check = 
{
	{{-1,-1},{-1,0},{0,0},{1,0}},
	{{0,-1},{0,0},{0,1},{-1,1}},
	{{1,1},{-1,0},{0,0},{1,0}},
	{{1,-1},{0,-1},{0,0},{0,1}},
},


left_snack = 
{
	{{-1,0},{0,0},{0,-1},{1,-1}},
	{{0,-1},{0,0},{1,0},{1,1}},
},
right_snack = 
{
	{{-1,-1},{0,-1},{0,0},{1,0}},
	{{1,-1},{1,0},{0,0},{0,1}},
},
}
local kind_list = {}
for k, v in pairs( kinds ) do
	table.insert( kind_list, k )
end
function clone_kind( kind_tab )
	local res = {}
	for idx, cell in pairs(kind_tab) do
		res[idx] = {}
		res[idx][1] = cell[1]
		res[idx][2] = cell[2]
	end
	return res
end

local function generate_block( com )
	local kind = kind_list[ math.random( #kind_list ) ]
	local index = math.random( #kinds[ kind ] )
	local res = {}
	res.data = kinds[ kind ][ index ]
	res.kind = kinds[ kind ]
	res.index = index
	local max_row = 0
	for _, cell in pairs( res.data ) do
		if cell[1] > max_row then max_row = cell[1] end
	end
	res.row = -max_row - 1
	res.col = math.floor( com.n_col / 2 )
	res.girl = {}
	for i = 1, 4 do
		res.girl[i] = get_random_girl()
	end
	return res
end

local function get_cell(com, row, col)
	if com.grid[row] and com.grid[row][col] then return com.grid[row][col] end
end

local function cell_is_valid_and_empty( com, row, col )
	if col >= 0 and row < com.n_row and col < com.n_col and not get_cell( com, row, col ) then return true end
end

local function set_cell(com, row, col, value)
	com.grid[row] = com.grid[row] or {}
	com.grid[row][col] = value
end

local function rotate_block( com )
	local new_data, new_index
	if com.cur.index == #com.cur.kind then
		new_index = 1
	else
		new_index = com.cur.index + 1
	end

	new_data = com.cur.kind[ new_index ]
	-- 可以旋转吗？
	for _, cell in pairs( new_data ) do
		local r, c = unpack( cell )
		r = r + com.cur.row
		c = c + com.cur.col
		if not cell_is_valid_and_empty( com, r, c ) then
			return false
		end
	end
	-- 可以旋转
	com.cur.data = new_data
	com.cur.index = new_index
end

local function ondraw(com)
	-- 画网格
	love.graphics.draw( grid_canvas, com.w_cell, com.h_cell )

	for r = 0, com.n_row - 1 do for c = 0, com.n_col - 1 do
		local x, y = c * com.w_cell, r * com.h_cell
		-- 画已经堆积的方块
		local girl = get_cell( com, r, c )
		if girl then
			love.graphics.setColor(
				255 - basic_color[1],
				255 - basic_color[2],
				255 - basic_color[3],
				basic_color[4])
			draw_cell( girl, r, c)
		end
	end end
	-- 显示当前
	love.graphics.setColor( 255 ,255, 255 * math.random(), 255 )
	local data
	data = com.cur.data
	for idx, cell in pairs(data) do
		local r, c = unpack(cell)
		draw_cell( com.cur.girl[ idx ], com.cur.row + r, com.cur.col + c )
	end
	-- 显示下一个
	love.graphics.setColor( 255, 190, 190, 255 )
	data = com.coming.data
	for idx, cell in pairs(data) do
		local r, c = unpack(cell)
		r = r + 3
		c = c + com.n_col + 3
		draw_cell( com.coming.girl[ idx ], r, c )
	end
	-- 显示分数
	local x, y = 620, 300
	love.graphics.setColor( 255, 255, 255, 255 )
	love.graphics.setFont( Data.font.medium )
	love.graphics.print("SCORE   " .. com.score, x, y)
	love.graphics.print("LEVEL   " .. com.level, x, y + 50)
end

function t.is_complete_row( com, row )
	for col = 0, com.n_col - 1 do
		if not get_cell( com, row, col ) then return end
	end
	return true
end

function t.cannot_move_down( com )
	for idx, cell in pairs(com.cur.data) do
		local row, col = unpack(cell)
		row = row + com.cur.row
		col = col + com.cur.col
		set_cell(com, row, col, com.cur.girl[ idx ])
	end

	-- 检查是否可以消除
	local row_to_remove = {}
	for _, cell in pairs(com.cur.data) do
		local row, col = unpack(cell)
		row = row + com.cur.row
		col = col + com.cur.col
		if t.is_complete_row( com, row ) then 
			table.insert( row_to_remove, row )
		end
	end
	t.remove_multi_rows( com, row_to_remove ) 

	-- 检查是否游戏结束
	local cnt_row_removed = #row_to_remove
	for _, cell in pairs(com.cur.data) do
		local row, col = unpack(cell)
		row = row + com.cur.row
		col = col + com.cur.col
		if row - cnt_row_removed <= 0 then
			com.owner:call( 'toggle_pause' )
			com.owner:call( 'game over' )
			return
		end
	end

	com.cur = com.coming
	com.coming = generate_block( com )
end

function t.move_current_block_by( com, offset_row, offset_col )
	for _, cell in pairs( com.cur.data ) do
		local new_row, new_col = com.cur.row + cell[1] + offset_row, com.cur.col + cell[2] + offset_col
		if not cell_is_valid_and_empty( com, new_row, new_col ) then
			return
		end
	end
	com.cur.row = com.cur.row + offset_row
	com.cur.col = com.cur.col + offset_col
end

function t.update_grid( com )
	local cannot_move_down_called = false
	for _, cell in pairs(com.cur.data) do
		local row, col = unpack(cell)
		row = row + com.cur.row
		col = col + com.cur.col
		if get_cell(com, row + 1, col) or row + 1 == com.n_row then
			if not cannot_move_down_called then
				t.cannot_move_down( com )
				cannot_move_down_called = true
			end
		end
	end
	-- 下移一格
	com.cur.row = com.cur.row + 1
end

local function get_speed( com )
	local level = com.level
	return .8 - math.sqrt( math.sqrt( level ) ) * 0.3
end

function t.set_level( com, level )
	local timer = love.state.current().timer

	com.level = level
	-- 使用新的速度重启定时器
	if com.timer_handler then
		timer:cancel( com.timer_handler )
		com.timer_handler = nil
		com.timer_handler = timer:addPeriodic( get_speed( com ), function() t.update_grid( com ) end )
	end
end

function t.increase_level( com )
	t.set_level( com, com.level + 1 )
end
function t.decrease_level( com )
	t.set_level( com, com.level - 1 )
end

function t.remove_one_row( com, row )
	com.score = com.score + 1
	for r = row, 1, -1 do
		for c = 0, com.n_col - 1 do
			set_cell( com, r, c, get_cell( com, r - 1, c ))
		end
	end
	if com.score % SCORES_PER_LEVEL == 0 then
		t.increase_level( com )
	end
end

function t.move_down_rows_above( com, row )
	for r = row, 1, -1 do
		for c = 0, com.n_col - 1 do
			set_cell( com, r, c, get_cell( com, r - 1, c) )
		end
	end
end

function t.remove_multi_rows( com, rows )
	if #rows == 0 then return end

	rows = love.util.set( rows ) -- 移除重复行号
	table.sort( rows ) -- 按照行号从大到小排序，即从上面的行排到下面的行~

	-- 消除
	for _, row in pairs( rows ) do
		for col = 0, com.n_col - 1 do
			set_cell( com, row, col, nil)
		end
	end
	-- 下移
	for _, row in pairs( rows ) do
		t.move_down_rows_above( com, row )
	end

	-- 增加分数
	com.score = com.score + #rows
	if com.score % SCORES_PER_LEVEL == 0 then
		t.increase_level( com )
	end
end

function t.toggle_pause( com )
	local timer = love.state.current().timer
	if com.timer_handler then
		timer:cancel( com.timer_handler )
		com.timer_handler = nil
	else
		com.timer_handler = timer:addPeriodic( get_speed( com ), function() t.update_grid( com ) end )
	end
end

local function onremove( com )
	com.timer_handler = nil
end

local function change_basic_color()
	local timer = love.state.current().timer
	timer:tween(
		1,
		basic_color,
		{ 100 * math.random(), 100 * math.random(), 100 * math.random(), 200 + 55 * math.random() },
		'linear',
		change_basic_color)
end

local function create(owner, n_row, n_col, w, h, draw_cell_func)
	n_row = n_row or 20
	n_col = n_col or 10
	w_cell = w or 20
	h_cell = h or w_cell
	w_cell = w_cell + 2
	h_cell = h_cell + 2
	draw_cell = draw_cell_func or draw_cell

	local com = {
		owner = owner, n_row = n_row, n_col = n_col, w_cell = w_cell, h_cell = h_cell, 
		grid = {}, score = 0, level = 0,

		ondraw = ondraw, onsave = onsave, onload = onload, onupdate = onupdate, onremove = onremove,
	}
	com.cur = generate_block( com )
	com.coming = generate_block( com )

	grid_canvas = love.graphics.newCanvas( n_col * w_cell, n_row * h_cell )
	love.graphics.setCanvas( grid_canvas )
	for r = 0, com.n_row - 1 do for c = 0, com.n_col - 1 do
		local x, y = c * com.w_cell, r * com.h_cell
		-- 画网格
		if math.random() > .1 then
			love.graphics.setColor( 100, 150, 100, 210 + 20 * math.random())
		else
			love.graphics.setColor( 100, 150, 100, 225)
		end
		love.graphics.rectangle( 'fill', x, y, w, h)
	end end
	love.graphics.setCanvas()

	change_basic_color();


	owner:listen( 'key pressed',
		function( key )
			if key == 'left' then
				t.move_current_block_by( com, 0, -1 )
			elseif key == 'right' then
				t.move_current_block_by( com, 0, 1 )
			elseif key == 'down' then
				t.move_current_block_by( com, 1, 0 )
			elseif key == 'up' then
				rotate_block( com )
			elseif key == 'w' then
				t.increase_level( com )
			elseif key == 's' then
				t.decrease_level( com )
			end
		end)

	owner:bindcall('toggle_pause', function() t.toggle_pause( com ) end)

	return com
end

return create
