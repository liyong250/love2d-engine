local function setup_func(ps)
	ps:setEmissionRate( 13 )
	ps:setEmitterLifetime( -1 ) -- forever
	ps:setParticleLifetime( 0.436508, 0.992063 )
	ps:setDirection( -1.5708 )
	ps:setSpread( 6.28319 )
	-- ps:setRelative( false )
	ps:setSpeed( 9.5238, 9.5238 )
	ps:setLinearAcceleration( 0, 0 )
	ps:setRadialAcceleration( -0.634921, -0.634921 )
	ps:setTangentialAcceleration( 0, 0 )
	ps:setSizes( 1.3817, 2.04464 ) -- there's a bug in 0.7.1 that forces us to set the size variation using its own function
	ps:setSizeVariation( 0.428571 )
	ps:setSpin( 0, 0, 0 )
	-- ps:setColorVariation( 0.206349 )
	-- ps:setAlphaVariation( 0 )
	ps:setColors( 46, 145, 255, 46, 248, 139, 44, 72 )
end

return setup_func
