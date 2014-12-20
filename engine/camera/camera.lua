Class = require('lib.class')

local camera = Class{}

-- constructor
function camera:init(x, y, zoom, rot)
	self.x, self.y  = x or love.graphics.getWidth() / 2, y or love.graphics.getHeight() / 2
	self.scale = zoom or 1
	self.rot  = rot or 0
end

-- The (x,y) of the world will be at the center of the screen.
-- (x, y) can be your hero's position!
function camera:lookAt(x, y)
	self.x, self.y = x,y
	return self
end

-- Move the camera  a little by (dx, dy).
-- Your can shake the screen by generate random (dx, dy).
function camera:move(x, y)
	self.x, self.y = self.x + x, self.y + y
	return self
end

-- Get the world position or screen center
function camera:pos()
	return self.x, self.y
end

function camera:rotate(phi)
	self.rot = self.rot + phi
	return self
end

function camera:rotateTo(phi)
	self.rot = phi
	return self
end

function camera:zoom(mul)
	self.scale = self.scale * mul
	return self
end

function camera:zoomTo(zoom)
	self.scale = zoom
	return self
end

-- Called when you want camera to take effects in draw().
function camera:beginScene()
	local cx,cy = love.graphics.getWidth()/(2*self.scale), love.graphics.getHeight()/(2*self.scale)
	love.graphics.push()
	love.graphics.scale(self.scale)
	love.graphics.translate(cx, cy)
	love.graphics.rotate(self.rot)
	love.graphics.translate(-self.x, -self.y)
end

-- Called when you want camera to be disabled in draw().
function camera:endScene()
	love.graphics.pop()
end

-- Convert world position to screen coordinates.
function camera:cameraCoords(x,y)
	-- x,y = ((x,y) - (self.x, self.y)):rotated(self.rot) * self.scale + center
	local w,h = love.graphics.getWidth(), love.graphics.getHeight()
	local c,s = math.cos(self.rot), math.sin(self.rot)
	x,y = x - self.x, y - self.y
	x,y = c*x - s*y, s*x + c*y
	return x*self.scale + w/2, y*self.scale + h/2
end

-- Convert screen coordinates to world position.
function camera:worldCoords(x,y)
	-- x,y = (((x,y) - center) / self.scale):rotated(-self.rot) + (self.x,self.y)
	local w,h = love.graphics.getWidth(), love.graphics.getHeight()
	local c,s = math.cos(-self.rot), math.sin(-self.rot)
	x,y = (x - w/2) / self.scale, (y - h/2) / self.scale
	x,y = c*x - s*y, s*x + c*y
	return x+self.x, y+self.y
end

function camera:mouseWorldPos()
	return self:worldCoords(love.mouse.getPosition())
end

return camera
