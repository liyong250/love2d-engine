--[[
标准图像的实现。

标准图像指的是包含new(),getWidth(),getHeight(),draw(x,y)函数的table。
标准图像中如果包含Image对象，则必须命名为raw。
new的参数可以不同。


]]
local g =love.graphics

--[[ 
标准图像类。
drawable可以是Image对象或者图片路径。
]]
local function draw(self, ...)
	love.graphics.draw(self, ...)
end
local function hitTest(self, x, y)
	local _,_,_,a = self:getData():getPixel(x, y)
	if a > 0 then return true end 
end

love.static = {}
function love.static:new(drawable)
	if type(drawable) == 'string' then
		drawable = love.graphics.newImage(drawable)
	end
	getmetatable(drawable).draw = draw
	getmetatable(drawable).testHit = hitTest
	return drawable
end

--[[
载入存储设备上的图像。图像分成三种。

* png图片
以图像名称作为变量名，表示整张图片。

* png图片和其中的小图
如果png文件存在同名的lua文件，则lua文件中定义了小图的信息，载入这些小图。
原始整图以方式1来存储。
小图的定义方式有互斥的两种方式：
1、小图按照固定的行列分割，存储在以【整图名称+"_part"】为名称的table中，命名按照行列号，序号从1开始。例如第二行第三列的小图的名称为 r2c3；
2、定义详细的(name,x,y,w,h)信息。按照制定的name命名。


* 代码图
直接通过执行代码返回一个标准图像。
图片的获取方式可能是动态生成，载入某个地方的图片，或者draw函数中动态绘制。以lua文件的名称来命名图像。
]]
function love.static.loadImage(result, path, filename, short_name) 
	result[short_name] = love.static:new( path .. '/' .. filename )
	local img = result[short_name]
	-- 看是否需要进行分片处理
	local path = love.util.requirePath( path ) .. '.' .. short_name
	local info = try_require( path )
	if info then
		if info.n_row then
			local w, h = img:getWidth() / info.n_col, img:getHeight() / info.n_row
			result[ short_name .. '_part' ] = {}
			for r = 1, info.n_row do for c = 1, info.n_col do
				local x, y = (c - 1) * w, (r - 1) * h
				local new_data = love.image.newImageData( w, h )
				local img_data = img:getData()
				new_data:paste(img_data, 0, 0, x, y, w, h)
				result[ short_name .. '_part' ]['r' .. r .. 'c' .. c] = love.static:new( love.graphics.newImage( new_data ) )
			end end
		end

		if info.rects then
			for name, rect in pairs(rects) do
				local w, h = rect[3], rect[4]
				local x, y = rect[1], rect[2]
				local new_data = love.image.newImageData( w, h )
				local img_data = img:getData()
				new_data:paste(img_data, 0, 0, x, y, w, h)
				result[ name ] = love.graphics.newImage( new_data )
			end
		end

		if info.abandon_origin then
			result[short_name] = nil
		end
	end
end

-- 使用函数绘制图片。
-- 返回Image对象（不是标准图像）。
function love.static.drawImage(w, h, draw_func, shader)
	local canvas = g.newCanvas(w, h)
	canvas:renderTo(draw_func)

	-- 对绘制的效果应用shader效果。
	if shader then
		local canvas_shader = g.newCanvas(w, h)
		canvas_shader:clear(255, 255, 255, 0)
		g.setShader(shader)
		g.setCanvas(canvas_shader)
		g.draw(canvas, 0, 0)
		g.setCanvas()
		g.setShader()
	end

	-- 生成Image对象。
	canvas = canvas_shader or canvas
	return g.newImage(canvas:getImageData())
end
