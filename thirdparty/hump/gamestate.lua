--[[
Copyright (c) 2010-2013 Matthias Richter

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

Except as contained in this notice, the name(s) of the above copyright holders
shall not be used in advertising or otherwise to promote the sale, use or
other dealings in this Software without prior written authorization.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
]]--

local function __NULL__() end

 -- default gamestate produces error on every callback
local state_init = setmetatable({leave = __NULL__},
		{__index = function() error("Gamestate not initialized. Use Gamestate.switch()") end})
local stack = {state_init}

local GS = {}
function GS.new(t) return t or {} end -- constructor - deprecated!

function GS.togglePause()
	local st = stack[#stack]
	if st.old_update_func then
		st.update = st.old_update_func
		st.old_update_func = nil
	else
		st.old_update_func = st.update
		st.update = nil
	end
end

function GS.pause( bool )
	local st = stack[#stack]

	if bool == true and not st.old_update_func then
		st.old_update_func = st.update
		st.update = nil
	elseif bool == false and st.old_update_func then
		st.update = st.old_update_func
		st.old_update_func = nil
	end
end

function GS.switch_real(to, ...)
	assert(to, "Missing argument: Gamestate to switch to")
	assert(to ~= GS, "Can't call switch with colon operator")
	local pre = stack[#stack]
	;(pre.leave or __NULL__)(pre)
	;(to.init or __NULL__)(to)
	to.init = nil
	stack[#stack] = to
	return (to.enter or __NULL__)(to, pre, ...)
end

function GS.switch(to, ...)
	-- delay the register_events to the timepoint of calling 'switch'
	GS.registerEvents()
	GS.switch = GS.switch_real
	GS.switch(to, ...)
end

function GS.push(to, ...)
	assert(to, "Missing argument: Gamestate to switch to")
	assert(to ~= GS, "Can't call push with colon operator")
	local pre = stack[#stack]
	;(to.init or __NULL__)(to)
	to.init = nil
	stack[#stack+1] = to
	return (to.enter or __NULL__)(to, pre, ...)
end

function GS.pop(...)
	assert(#stack > 1, "No more states to pop!")
	local pre = stack[#stack]
	stack[#stack] = nil
	;(pre.leave or __NULL__)(pre)
	return (stack[#stack].resume or __NULL__)(pre, ...)
end

function GS.current()
	return stack[#stack]
end

local all_callbacks = {
	'draw', 'errhand', 'focus', 'keypressed', 'keyreleased', 'mousefocus',
	'mousepressed', 'mousereleased', 'quit', 'resize', 'textinput',
	'threaderror', 'update', 'visible', 'gamepadaxis', 'gamepadpressed',
	'gamepadreleased', 'joystickadded', 'joystickaxis', 'joystickhat',
	'joystickpressed', 'joystickreleased', 'joystickremoved',
	-- GG
	--'postdraw', 'postupdate',
}

function GS.registerEvents(callbacks)
	local registry = {}
	callbacks = callbacks or all_callbacks
	local i = 0;
	for _, f in ipairs(callbacks) do
		if string.sub(f, 1, 4) == 'post' then
			local funcname = string.sub(f, 5, -1)
			registry[f] = love[funcname] or __NULL__
			love[funcname] = function(...)
				registry[f](...)
				GS[f](...)
			end
		else
			registry[f] = love[f] or __NULL__
			love[f] = function(...)
				GS[f](...)
				registry[f](...)
			end
		end
	end
end

-- forward any undefined functions
setmetatable(GS, {__index = function(_, func)
	return function(...)
		return (stack[#stack][func] or __NULL__)(stack[#stack], ...)
	end
end})

return GS
