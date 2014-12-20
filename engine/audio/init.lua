local funcs = {'play', 'pause', 'stop', 'resume', 'rewind'}
local oldfuncs = {}
for _, func in pairs(funcs) do
	oldfuncs[func] = love.audio[func]
end

local function EMPTY_FUNCTION() end
function love.audio.enable()
	for _, func in pairs(funcs) do
		love.audio[func] = oldfuncs[func]
	end
end
function love.audio.disable()
	for _, func in pairs(funcs) do
		love.audio[func] = EMPTY_FUNCTION
	end
end