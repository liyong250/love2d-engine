--[[
动画功能的测试
]]
local g = love.graphics

local anim_duration = .7

local function set_anim(com, anim_name)
	assert(com.config[anim_name], anim_name)
	-- call end func
	if com.name then
		local end_func = com.config[com.name][4]
		if end_func then end_func() end
	end
	-- set name
	com.name = anim_name
	-- call start func
	local start_func = com.config[anim_name][2]
	if start_func then start_func() end
end

local function onremove( com )
end

local function onsave( com, data )
end

local function ondraw( com, data )
	local x, y = com.owner:attr('pos')
	g.setColor( unpack(com.config[com.name][1]) )
	g.print(com.name..'('..math.floor(x)..','..math.floor(y)..')', x, y)
	g.setLineWidth(5)
	g.circle('fill', x, y - 20, 5)
	g.line(x, y, x, y - 20)
	g.setLineWidth(1)
	g.setColor(255,255,255)
end

local function onupdate(com, dt)
	com.timer = com.timer + dt
	if com.timer > anim_duration then
		com.timer = 0
		-- call loop func	
		local conf = com.config[com.name]
		local loop_func = conf[3]
		if loop_func then loop_func() end
	end
end


--[[
config = {
	idle = {{255,0,0}},
	walk = {{255,0,0}, walk_start, walk_loop, walk_over},
	run = {{255,0,0}, run_start, run_loop, run_over},
}
]]
local function create( owner, config, first_anim_name)
	local t = {timer = 0, config = assert(config), owner=owner,
		onupdate = onupdate,
		ondraw = ondraw,
	}
	set_anim(t, assert(first_anim_name))

	owner:bindattr('anim', 
		function(anim_name)
			if anim_name then
				set_anim(t, anim_name)
			else
				return t.name
			end
		end)
	return t
end

return create
