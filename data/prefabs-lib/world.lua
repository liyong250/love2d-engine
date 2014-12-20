
local function init(world, map_name)
	world:emit('loadmap', map_name)
end

local function loadworld(self, t)
	if not t then return false end
	-- 载入存档
	local coms = self:getcoms()
	-- * 载入游戏世界的所有entity，从而获取一个guid到entity的转换表
	local obj_storage = coms['objects']
	local guid2entity = obj_storage:onload(t['objects'])
	-- * 载入世界实体的其他组件（除了objects）
	for name, com in pairs(coms) do
		if com ~= obj_storage and com.onload then -- 不载入objects，要不然就是死递归了
			if t[name] then
				com:onload(t[name], guid2entity)
			end
		end
	end
	return true
end

local function removeworld(self)

end



return 
{
	coms = 
	function()
		return
		{
			-- 可视化组件
			{'tmap', true, 'data/map/'},		-- 游戏地图
			{'objects'},	-- 管理游戏中的事物
			{'bk_color'},	-- 改变背景色

			{'ui'}, -- 使用图形界面控件
			-- 逻辑组件
			{'input_enabled', 'publisher'},	-- 使得游戏可以接受输入
			{'grid'},
		}
	end,
	init =
	function(t)
		t:listen('init', init)

		t.loadworld = loadworld

		t:bindcall('screen2WorldCoords',
			function(x, y) return x, y end)
		t:listen('game_over',
			function()
				print('game over')
			end)
	end
}
