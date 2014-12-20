--[[
* 实现功能描述
	* 给物体打Tag。例如，用于给物体分类。
* 目标Entity必须
* 属性
* 方法
	* addtag( tag )
	* rmtag( tag )
	* hastag()
* 接受的事件
* 其他强制要求
* 用法示例
]]

--[[
tags = {}
	例如 {'animal', 'wild', 'alive'}
]]

local function onsave(com, data)
	data.tags = com.tags
end
local function onload(com, data, guid2entity)
	if data.tags then
		com.tags = com.tags
	end
end

local function create(owner, tags)
	local res =
	{
		tags = {},
	}

	owner:bindcall('addtag',
		function(tag)
			res.tags[tag] = true
		end)
	owner:bindcall('rmtag',
		function(tag)
			res.tags[tag] = nil
		end)
	owner:bindcall('hastag',
		function(tag)
			return res.tags[tag]
		end)

	for _, tag in pairs(tags) do
		res.tags[tag] = true
	end

	return res
end

return create