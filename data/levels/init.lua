-- 关卡的实现
local levels = {

{
	name = "abc",
	map = "map1",
	time = 30,
	passpoint = 8,
},
{
	name = "abc",
	map = "map5",
	time = 40,
	passpoint = 10,
},
{
	name = "big_zero",
	map = "map4",
	time = 100,
	passpoint = 40,
},
{
	name = "abc",
	map = "map6",
	time = 100,
	passpoint = 50,
},
{
	name = "abc",
	map = "map2",
	time = 40,
	passpoint = 10,
},
{
	name = "abc",
	map = "map3",
	time = 80,
	passpoint = 14,
},
{
	name = "abc",
	map = "map7",
	time = 200,
	passpoint = 100,
},
}
local level = {
	curLevelIndex = 1,
}
function level.CurLevel(newLevel)
	if newLevel then
		level.curLevelIndex = newLevel
	end
	return levels[level.curLevelIndex]
end
function level.Next()
	if level.curLevelIndex < #levels then
		level.curLevelIndex = level.curLevelIndex + 1
		return true
	else
		return false
	end
end

return level