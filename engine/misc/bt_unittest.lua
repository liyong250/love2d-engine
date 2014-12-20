local BT = require('bt')
local tree = require('bt_unittest_input')
local person = 
{
	HasMoney = function() return false end,
	Sleepy = function() return false end,
	Rest = function() print('rest') end,
	BuyCar = function() print('buy car') end,
	BuySugar = function() print('buy sugar') end,
	GoHome = function() print('go home') end,
}
for i = 1, 20 do
	BT.run(tree, person)
end