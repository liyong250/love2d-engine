local g =love.graphics
love.static = Class{
	init = function(self, drawable, scale, rotation)
		if type(drawable) == 'string' then
			self.img = love.graphics.newImage(drawable)
		else
			self.img = drawable
		end
		self.scale = scale or 1
		self.rotation = rotation or 0
	end,
	draw = function(self, x, y)
		love.graphics.draw(self.img, x, y, self.rotation, self.scale, self.scale)
	end,
	getWidth = function(self) return self.img:getWidth() end,
	getHeight = function(self) return self.img:getHeight() end,
}

function love.static.loadImage(result, path, filename, short_name) 
	result[short_name] = love.static:new( path .. '/' .. filename )
	local img = result[short_name].img
	-- 看是否需要进行分片处理
	local path = love.util.requirePath( path ) .. '.' .. short_name
	local info = require( path )
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
				result[ short_name .. '_part' ][ name ] = love.graphics.newImage( new_data )
			end
		end

		if info.abandon_origin then
			result[short_name] = nil
		end
	end
end

-- 使用代码绘制图片
-- 返回Image对象
function love.static.drawImage(w, h, draw_func, shader)
	local canvas = g.newCanvas(w, h)
	canvas:renderTo(draw_func)

	local canvas2 = g.newCanvas(w, h)
	canvas2:clear(255, 255, 255, 0)
	g.setShader(shader)
	g.setCanvas(canvas2)
	g.draw(canvas, 0, 0)
	g.setCanvas()
	g.setShader()

	return g.newImage(canvas2:getImageData())
end
