--[[
* 实现功能描述
	* 实现复杂的图形界面
* 目标Entity必须
* 属性
* 方法
	* create_ui( ui_name ) 创建ui。详见loveframes库。
* 接受的事件
* 其他强制要求
* 用法示例
]]

local function onupdate(self, dt)
	love.ui.update(dt)
end	

local  function ondraw()
	love.graphics.push()
	love.graphics.origin()
	love.ui.draw()
	love.graphics.pop()
end

local function onremove(self, obj)
	for _, obj in pairs(self.__uiobjects) do
		obj:Remove()
	end
	self.__uiobjects = nil
end

local function create(owner, skin)
	skin = skin or 'Dark'

	local res = 
	{
		onupdate = onupdate,
		ondraw = ondraw,
		onremove = onremove,

		__uiobjects = {},
	}

	owner:bindcall('create_ui', 
		function(...)
			local obj = assert(love.ui.Create(...), ...)
			table.insert(res.__uiobjects, obj)
			return obj
		end)

	love.ui.util.SetActiveSkin(skin)

	return res
end

return create
