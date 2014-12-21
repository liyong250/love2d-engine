--[[
* 实现功能描述
	* 载入并显示TiledMap
	* 支持tag组件，如果有'through'这个tag，则cango和cango_grid始终返回可走。
* 目标Entity必须
	* call: screen2WorldCoords( x, y ) 因为需要知道屏幕左上角在地图的哪里，从而避免绘制屏幕外的图像。
* 属性
	* cango( obj, x, y )  返回obj是不是可以走到(x,y)处
* 方法
	* load_tiled_map( map_name )
* 接受的事件
* 其他强制要求
* 用法示例
]]


local function onupdate(com, dt)

end

local function ondraw(com)
	local x, y = com.owner:call('screen2WorldCoords', 0, 0)
	com.map:autoDrawRange(-math.floor(x), -math.floor(y), 1, pad)
	com.map:draw()
end

local function loadmap(com, map_name)
	if map_name then 
		com.map_name = map_name
		com.map = love.tmap.load(map_name)
	end
end

local function onsave(com, t)
	t.map_name = com.map_name
end

local function onload(com, t)
	com.map_name = t.map_name
	loadmap(com, t.map_name)
end

local function create(t, loco_based_on_grid, map_path, map_name)
	if map_path then
		love.tmap.path = map_path
	end
	assert(love.tmap.path and love.tmap.path ~= '')

	local res =
	{
		owner = t,

		ondraw = ondraw,
		onupdate = onupdate,
		onsave = onsave,
		onload = onload,
	}
	res.map = loadmap(res, map_name)

	local function cango(obj, x, y)
		-- if obj and obj:call('hastag', 'through') then return x, y end
		local row, col = math.floor(y / res.map.tileHeight), math.floor(x / res.map.tileWidth)
		local forbidden = res.map('forbidden')
		if forbidden and forbidden(col, row) then
			return false
		else
			return x, y
		end
	end
	local function cango_row_col(obj, x, y)
		-- if obj and obj:call('hastag', 'through') then return x, y end
		local forbidden = res.map('forbidden')
		if forbidden and forbidden(x, y) then
			return false
		else
			return x, y
		end
	end

	if loco_based_on_grid then
		t:bindattr('cango', cango_row_col)
	else
		t:bindattr('cango', cango)
	end

	t:bindcall('load_tiled_map', 
		function(map_name)
			loadmap(res, map_name)
		end)

	return res
end

return create