local function setup_func(ps)
	ps:setEmissionRate( 131 )
	ps:setEmitterLifetime( -1 ) -- forever
	ps:setParticleLifetime( 0.436508, 0.992063 )
	ps:setDirection( -1.5708 )
	ps:setSpread( 6.28319 )
	-- ps:setRelative( false )
	ps:setSpeed( 85.7143, 104.762 )
	ps:setLinearAcceleration( 0, 0 )
	ps:setRadialAcceleration( -71.4286, -71.4286 )
	ps:setTangentialAcceleration( 0, 0 )
	ps:setSizes( 0.988839, 0.301339 ) -- there's a bug in 0.7.1 that forces us to set the size variation using its own function
	ps:setSizeVariation( 0 )
	ps:setSpin( 19.8413, 19.8413, 0.52381 )
	-- ps:setColorVariation( 0.206349 )
	-- ps:setAlphaVariation( 0 )
	ps:setColors( 24, 204, 91, 255, 105, 40, 226, 72 )
end

return setup_func
