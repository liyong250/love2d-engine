local function setup_func(ps)
	ps:setEmissionRate( 138 )
	ps:setEmitterLifetime( -1 ) -- forever
	ps:setParticleLifetime( 0.47619, 1.03175 )
	ps:setDirection( -1.5708 )
	ps:setSpread( 0.674704 )
	-- ps:setRelative( false )
	ps:setSpeed( 300, 300 )
	ps:setLinearAcceleration( 428.571, 728.571 )
	ps:setRadialAcceleration( -0.793652, -0.793652 )
	ps:setTangentialAcceleration( -0.158731, -0.158731 )
	ps:setSizes( 1.67634, 0.154018 ) -- there's a bug in 0.7.1 that forces us to set the size variation using its own function
	ps:setSizeVariation( 0.444444 )
	ps:setSpin( -50, 8.73016, 0.0634921 )
	-- ps:setColorVariation( 0.412698 )
	-- ps:setAlphaVariation( 0.507937 )
	ps:setColors( 240, 46, 24, 155, 255, 204, 18, 30 )
end

return setup_func
