for k, v in pairs(require('thirdparty.hump.timer')) do
	love.timer[k] = v
end

love.flux = require('thirdparty.flux')
