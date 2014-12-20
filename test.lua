local timer = require('timer')
local t = timer:new()

local h = t:addPeriodic(1, function()print('ok') end)
