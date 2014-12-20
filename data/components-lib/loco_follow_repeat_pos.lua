--[[
* 实现功能描述
	* 精确地复制某个entity的上一个位置
* 目标Entity必须
	* emit: moved( old_x, old_y )
	* attr-write: pos( x, y )
* 属性
* 方法
	* set_repeat_target( target )
* 接受的事件
* 发布的事件
* 其他强制要求
* 用法实例
]]

local function onsave(com, data)
	data.guid = com.target.guid
end
local function onload(com, data, guid2entity)
	if data.guid then
		com.target = guid2entity(data.guid)
	end
end

local function create(owner)
	local res = {
		owner = owner,

		onload = onload,
		onsave = onsave,
	}

	owner:bindcall('set_repeat_target',
		function(target)
			res.target = target
			target:listen('moved',
				function(oldx, oldy)
					owner:attr('pos', oldx, oldy)
				end)
		end)

	return res
end

return create