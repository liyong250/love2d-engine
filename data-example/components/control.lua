--[[
* 实现功能描述
	* 允许物体接受控制（AI控制或玩家控制）
	* 将输入（自动控制或者玩家输入）转换成游戏系统可以理解的事件
* 目标Entity必须
	* emit:move( dx, dy )
* 属性
* 方法
* 接受的事件
	* input_dir( dx, dy )	输入方向键的时候触发。例如往右行走为 input_dir(1,0)
* 其他强制要求
* 用法实例
]]


local function create(t)
	local function input_dir(dx, dy)
		t:call('periodic_move_direction', dx, dy)
	end
	t:listen('input_dir', input_dir)
	return {}
end

return create