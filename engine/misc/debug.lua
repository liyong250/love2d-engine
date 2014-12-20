local info = {}

local function assembly(...)
	local strs = {}
	for _, arg in pairs({...}) do
		table.insert(strs, tostring(arg))
		table.insert(strs, " ")
	end
	return table.concat(strs)
end
local function log(...)
	table.insert(info, assembly(...))
end
local function printToConsole(...)
	Lume.trace(assembly(...))
end
local function draw()
	local x, y = 0, 0
	for _, str in pairs(info) do
		love.graphics.print(str, x, y)
		y = y + 16
	end
	info = {}
end

return
{
	log = log,
	draw = draw,
	['print'] = printToConsole,
}