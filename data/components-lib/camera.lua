--[[
* 实现功能描述
	* 摄像机效果的实现
* 目标Entity必须
	* visual_pos()
* 属性
	* camera_enabled RW
	* cameraPos RW
* 方法
	* camera_lookat(x, y)
	* cameraFollow( table ) 
	* screen2WorldCoords( x, y ) 屏幕坐标转世界坐标
	* world2ScreenCoords( x, y ) 世界坐标转屏幕坐标
* 接受的事件
* 其他强制要求
* 用法示例
]]
local created = false

local function onload(com, t, guid2entity)
	if t.focus then
		com.focus = guid2entity[t.focus]
	end
end

local function onsave(com, t)
	if com.focus then
		t.focus = com.focus.guid
	end
end

local function onremove(com)
	created = false
end

local function create(t, enabled)
	assert(not created, "Camera can only be created once")
	local res = 
	{
		onremove = onremove,
		onload = onload,
		onsave = onsave,
		enabled = enabled,
	}

	love.camera:init(0, 0, 1, 0)
	t:bindcall('camera_lookat',
		function(x, y)
			love.camera:lookAt(x, y)
		end)
	t:bindcall('cameraFollow',
		function(obj)
			res.focus = obj
		end)
	t:bindattr('cameraPos',
		function() return love.camera:pos() end)
	t:bindcall('screen2WorldCoords',
		function(x, y)
			return love.camera:worldCoords(x, y)
		end)
	t:bindcall('world2ScreenCoords',
		function(x, y)
			return love.camera:cameraCoords(x, y)
		end)
	
	t:bindattr('mouseWorldPos',
		function()
			return love.camera:mouseWorldPos()
		end)

	-- 将t的draw函数包装一下
	local old_draw = t.draw
	local function new_draw(...)
		love.camera:beginScene()
		if res.focus then
			love.camera:lookAt(res.focus:attr('visual_pos'))
		end
		old_draw(...)
		love.camera:endScene()
	end
	t:bindattr('camera_enabled',
		function(enabled)
			if enabled then
				res.enabled = true
				t.draw = new_draw
			else
				res.enabled = false
				t.draw = old_draw
			end
		end)
	
	
	t:attr('camera_enabled', enabled)
	created = true
	return res
end

return create
