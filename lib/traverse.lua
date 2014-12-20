-- ±È¿˙±Ì°£
traverse = {}
traverse.ShowMetatable = false
traverse.ShowChildTable = true
function traverse.ShowIntent( level)
	for i = 1,level do
		io.write("  ")
	end
	io.write(level..":")
end
function traverse.Show( tab, level)
	if level == nil then
		io.write("[ROOT]"..tostring(tab))
		io.write('\n')
		level = 1
	end
	if type(tab) ~= "table" then
		traverse.ShowIntent(level)
		io.write("nil")
		io.write('\n')
		return
	end
	for k,v in pairs(tab) do
		traverse.ShowIntent(level)
		if type(v) == "table" then
			io.write( tostring(k)..":["..tostring(v).."]")
			io.write('\n')
			if traverse.ShowChildTable then
				traverse.Show( v, level + 1)
			end
		else
			io.write( tostring(k)..":"..tostring(v))
			io.write('\n')
		end
	end
	if traverse.ShowMetatable == true then
		traverse.ShowIntent(level)
		local mt = getmetatable( tab)
		io.write( "metatable:["..tostring( mt).."]")
		io.write('\n')
		if mt then
			traverse.Show( mt,level+1)
		end
	end
end
--[[
-- ≤‚ ‘
tab = {1,"ok",u={"xx","jj"}}
traverse.Show(tab)
]]

return traverse