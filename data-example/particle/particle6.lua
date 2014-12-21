local function setup_func(ps)
	ps:setEmissionRate( 107 )
	ps:setEmitterLifetime( -1 ) -- forever
	ps:setParticleLifetime( 0.436508, 0.992063 )
	ps:setDirection( -1.5708 )
	ps:setSpread( 0.0843381 )
	-- ps:setRelative( false )
	ps:setSpeed( 85.7143, 133.333 )
	ps:setLinearAcceleration( 0, 0 )
	ps:setRadialAcceleration( 0, 0 )
	ps:setTangentialAcceleration( 0, 0 )
	ps:setSizes( 0.816964, 0 ) -- there's a bug in 0.7.1 that forces us to set the size variation using its own function
	ps:setSizeVariation( 0 )
	ps:setSpin( 0, 0, 0 )
	-- ps:setColorVariation( 0 )
	-- ps:setAlphaVariation( 0 )
	ps:setColors( 82, 16, 109, 107, 139, 157, 218, 72 )
end

return setup_func
