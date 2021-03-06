-- 期待32x32的白色球图案
local function get_particle_system( img )
    local ps = love.graphics.newParticleSystem(img, 10)
    local w, h = img:getWidth(), img:getHeight()
    local ww, wh = love.window.getDimensions()
   
    -- 系统
    local size = 20
    ps:setBufferSize( size )-- max particle number
   
    -- 释放器属性！！
    local life = .5
    ps:setEmissionRate( size ) -- ? particles per second
    ps:setEmitterLifetime( life ) -- seconds. -1 for forever.
    ps:setPosition( 0, 0 ) -- emitter position
    ps:setAreaSpread( 'normal', 0, 0)  -- 释放器位置是否在一定范围内随机
    ps:setInsertMode( 'top' ) -- 插入新粒子的策略
   
   
    -- 粒子属性！！
    -- 初始大小
    ps:setSizes( .6, .5, .2, .1 ) -- at most 8 size can be there
    ps:setSizeVariation( .5 ) -- full variation 初始大小在最小到最大值之间变化。0表示不变化，1表示完全变化。
    -- 初始线速度
    ps:setSpeed( 20, 20 ) -- particle speed 初始线速度的 min/max
    ps:setSpread( math.pi * 2 ) -- 线速度角度范围
    ps:setDirection( 0 ) -- 线速度角度范围的中点 向下
    -- 粒子生命
    ps:setParticleLifetime( life, life )
    -- 自旋
    ps:setSpin( 0, 0 ) -- particle spin itself per second in radians    自旋速度
    ps:setOffset( 0, 0 ) -- rotate around (x, y) of the image -- 自旋中心
    ps:setRotation( 0, 0 ) --  初始 旋转角度 的范围
    ps:setRelativeRotation( false ) -- 若为true，则旋转角度相对于速度方向确定，而不是(1,0)方向。
    -- 颜色
    ps:setColors(200, 110, 110, 100,     
        155, 0, 0, 255,           
        255, 255, 255, 255,         
        155, 155, 255, 100)-- setColors max 8 colors
    -- 加速度
    local acc = 0
    ps:setRadialAcceleration( 100, 200 ) -- acc away from emitter 轴向加速度
    ps:setTangentialAcceleration( 0, 0 ) -- acc 切向加速度
    ps:setLinearAcceleration( 0, 0, 0, 0 ) -- xmin, ymin, xmax, ymax 横向和纵向的加速度

    return ps;
end

return get_particle_system