--[[
高分榜的实现。
]]

local function cmp(s1, s2)
	return s1.score > s2.score
end
local function sort( com )
	table.sort( com.scores, cmp)
end
local function addScore( com, name, score )
	if name == nil then name = 'user' + score end
	table.insert( com.scores, {name = name, score = score} )
	sort()
	if #com.scores > max_count then
		table.remove( com.scores ) -- remove the last element
	end
end

local function onload( com, data )
	for _, score in pairs( data ) do
		table.insert( com.scores, score )
	end
	sort()
end

local function onremove( com )
	love.storage.save( com.key )
end

local function onsave( com, data )
	for _, score in pairs( com.scores ) do
		table.insert( data, score )
	end
end

local function create( owner, key_for_storage, max_count )
	key_for_storage = key_for_storage or 'score_rank'
	max_count = max_count or 50

	local t = 
	{
		key = key_for_storage,
		scores = {},	
		max_cnt = max_count,

		onsave = onsave,
		onload = onload,
		onremove = onremove,
	}
	owner:bindcall('add score', function( name, score ) addScore( t, name, score ) end)
	return t
end

return create