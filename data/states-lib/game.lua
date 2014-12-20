-------------------------------------------------
local game = {}

local save_key = 'SaveSlot11'
local hero

function game:enter(last)
	love.util.trace('Enter game')
	love.world = love.entity.MakeEntity(Data.prefabs.world)

	--local storage = love.storage.load(save_key)
	if storage then
		love.util.trace('Load the world')
		-- 载入存档到世界
		love.world:loadworld(storage)
	else
		love.util.trace('Generate the world')
		-- 没有存档时，按照固定方式来初始化游戏世界
		-- * 创建英雄~
		local w = love.world
		w:call('load_tiled_map', 'map2')
		hero = w:call('spawn_entity', 'hero')
		-- * 创建追随者
		local leader = hero
		for i = 1, 2 do
			local follower = w:call('spawn_entity', 'follower')
			follower:call('set_repeat_target', leader)
			leader = follower
		end
	end
	-- 背景色改变，走起~
	love.world:call('start_changing_bk_color')
end

function game:draw()
	love.world:draw()
end

function game:update(dt)
	love.world:update(dt)
end

function game:leave()
	local t = {}
	-- 保存世界
	love.world:save(t)
	love.storage.save(save_key, t)
	-- 删除世界
	love.world:rmcoms()
	love.world = nil
end

function game:keypressed(key, isrepeat)
	if not isrepeat then
		if key == 'escape' then
			love.state.switch(Data.states.menu)
		end
	end
end

return {game = game}
