--[[
将particle封装成标准动画。
]]
local particle = {}
local function draw(self, x, y)
	self:setPosition( x, y )
	love.graphics.draw( self )
end
function particle.clone( particle )
	local cloned = particle:clone()
	particle.init( particle )
end

function particle.init( particle )
	getmetatable(particle).draw = draw
	return particle
end

function particle:new( drawable, particle_func )
	return particle.init( particle_func(drawable) )
end

return particle
