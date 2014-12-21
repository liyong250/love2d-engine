--[[
* 实现功能描述
	* 如果实体需要显示出来，则必须添加此组件。
* 目标Entity必须具有的属性和事件
	* pos 得到的作为图片左上角坐标，绘制图片到屏幕上
* 向目标Entity上添加的属性和事件
	* 属性
		* size	R，图片大小
		* visual_pos
* 可以接受的事件
	* changeVisual( param )
		param如果是字符串，则别当做当前动画组的新状态；如果是table，则被认为是一个新的可绘制物体，将替换当前可绘制物体。
* 其他强制要求
* 用法示例
	* 添加一个可以左右行走的人物动画
		{
			'visual', 
			{
				walk_left = animation_left,
				walk_right = animation_right,
			}
		}
	* 添加一个图片
		{'visual', picture}
]]

local function update(self, dt)
	if self.drawable.update then self.drawable:update(dt) end
end
local function draw(self)
	local w, h = self.drawable:getWidth(), self.drawable:getHeight()
	local x, y = self.owner:attr('visual_pos', w, h)
	self.drawable:draw(x, y)
end

-- 将坐标转换成绘制点
local function default_where_to_draw(pos_x, pos_y, visual_width, visual_height)
	return pos_x, pos_y
end
local function draw_to_foot(pos_x, pos_y, visual_width, visual_height)
	return pos_x - visual_width / 2, pos_y - visual_height
end
local function draw_on_grid(pos_x, pos_y, visual_width, visual_height)
	return pos_x * visual_width, pos_y * visual_height
end

--[[
drawable table类型
	必须包含：
	* draw(x,y)
	* getWidth()
	* getHeight()
	可选包含：
	* update(dt)
where_to_draw = default_implement
	函数，将位置转换成要绘制的屏幕坐标。
	参数为 pos_x, pos_y, visual_width, visual_height
]]
local function create(t, drawable, where_to_draw)
	local res =
	{
		owner = t,
		drawable = assert(drawable),

		onupdate = update,
		ondraw = draw,
	}

	where_to_draw = where_to_draw or default_where_to_draw
	if where_to_draw == 'foot' then
		where_to_draw = draw_to_foot
	elseif where_to_draw == 'grid' then
		where_to_draw = draw_on_grid
	end

	local function changeVisual(visual)
		if type(visual) == 'string' then
			if res.drawable.change then
				res.drawable:change(visual)
			end
		else
			res.drawable = visual
		end
	end
	t:listen('changeVisual', changeVisual)
	t:bindattr('size',
		function()
			return res.drawable:getWidth(), res.drawable:getHeight()
		end)
	t:bindattr('visual_pos',
		function()
			local x, y = t:attr('pos')
			return where_to_draw(x, y, res.drawable:getWidth(), res.drawable:getHeight())
		end)

	return res;
end

return create