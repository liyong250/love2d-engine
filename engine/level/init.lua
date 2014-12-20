-- 关卡的实现
local level = {}
love.level = level
function level.init(initLevel, cntLevels)
	level.curLevelIndex = initLevel
	lovel.cnt = cntLevels
end
function level.cur(newLevel)
	if newLevel then
		level.curLevelIndex = newLevel
	end
	return level.curLevelIndex
end
function level.next()
	if level.curLevelIndex < level.cnt then
		level.curLevelIndex = level.curLevelIndex + 1
		return level.curLevelIndex
	else
		return false
	end
end
function level.hasNext()
	return level.curLevelIndex < level.cnt
end