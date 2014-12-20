local function setup_func(ps)
	ps:setEmissionRate( 30 )
	ps:setEmitterLifetime( -1 ) -- forever
	ps:setParticleLifetime( 0.595238, 2.2619 )
	ps:setDirection( -1.5708 )
	ps:setSpread( 6.28319 )
	-- ps:setRelative( false )
	ps:setSpeed( 61.9048, 66.6667 )
	ps:setLinearAcceleration( 0, 0 )
	ps:setRadialAcceleration( -71.4286, -71.4286 )
	ps:setTangentialAcceleration( -14.2857, -14.2857 )
	ps:setSizes( 0.252232, 1.89732 ) -- there's a bug in 0.7.1 that forces us to set the size variation using its own function
	ps:setSizeVariation( 0.428571 )
	ps:setSpin( 0, 0, 0 )
	-- ps:setColorVariation( 0.206349 )
	-- ps:setAlphaVariation( 0 )
	ps:setColors( 46, 145, 255, 216, 248, 139, 44, 97 )
end

return setup_func
