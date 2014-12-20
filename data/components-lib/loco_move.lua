-- loco_move.lua
--[[
attr-RW: pos
]]

local function onupdate(com)
	com.owner:attr('pos', com.pos[1], com.pos[2])
end

local function create(owner, speed, pattern)
	speed = speed or 10
	pattern = pattern or 'linear'

	local t =
	{
		speed = speed,
		pattern = pattern,
		owner = owner,
	}

	local function move_cancel(prefix)
		local handler_name = prefix .. '_handler'
		if not t[handler_name] then return false end
		love.state.current().timer:cancel(t[handler_name])

		local func_name = prefix .. '_canceled_function'
		if t[func_name] then
			t[func_name]()
		end

		t[func_name] = nil
		t[handler_name] = nil
		t.pos = nil
		t.onupdate = nil
		
		return true
	end
	local function moveto_cancel()
		move_cancel('moveto')
	end
	local function moveby_cancel()
		move_cancel('moveby')
	end


	local function move_common(target_x, target_y, speed, pattern, after_function)
		moveby_cancel()
		-- 默认值
		speed = speed or t.speed
		pattern = pattern or t.pattern
		-- 计算参数
		local timer = love.state.current().timer
		local vector = love.math.vector
		local x, y = owner:attr('pos')
		local distance = vector(target_x - x, target_y - y):len()
		local time_span = distance / speed

		t.pos = {x, y}
		t.onupdate = onupdate
		
		return timer.tween(
				time_span,
				t.pos,
				{target_x, target_y},
				t.pattern,
				after_function
			)
	end
	local function moveby(offset_x, target_y, speed, pattern, after_function, canceled_function)
		local x, y = owner:attr('pos')
		t.moveby_handler = move_common(x + offset_x, y + offset_y, speed, pattern, after_function, canceled_function)
		t.moveby_canceled_function = canceled_function
	end
	local function moveto(target_x, target_y, speed, pattern, after_function, canceled_function)
		t.moveto_handler = move_common(target_x, target_y, speed, pattern, after_function, canceled_function)
		t.moveto_canceled_function = canceled_function
	end


	owner:bindcall('moveto', moveto)
	owner:bindcall('moveby', moveby)
	owner:bindcall('moveto_cancel', moveto_cancel)
	owner:bindcall('moveby_cancel', moveby_cancel)

	return t
end

return create