local Anim8 = require('thirdparty.anim8.anim8')

love.anim = Anim8
love.anim.shine = require(... .. '.shine').shine
love.anim.loadAnims = require(... .. '.animLoader')
love.anim.animGroup = require(... .. '.animGroup')

-- 转场动画的实现
love.anim.trans = require(... .. '.transition')

-- 粒子系统的实现
love.anim.particle = require(... .. '.particle')