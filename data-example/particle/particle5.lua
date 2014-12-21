local function setup_func(ps)
	ps:setEmissionRate( 37 )
	ps:setEmitterLifetime( -1 ) -- forever
	ps:setParticleLifetime( 0.436508, 0.833333 )
	ps:setDirection( -1.5708 )
	ps:setSpread( 0.253014 )
	-- ps:setRelative( false )
	ps:setSpeed( 42.8571, 42.8571 )
	ps:setLinearAcceleration( 442.857, 557.143 )
	ps:setRadialAcceleration( 0, 0 )
	ps:setTangentialAcceleration( -0.158731, -0.158731 )
	ps:setSizes( 2.70759, 0.325893 ) -- there's a bug in 0.7.1 that forces us to set the size variation using its own function
	ps:setSizeVariation( 0.238095 )
	ps:setSpin( 0, 0, 0 )
	-- ps:setColorVariation( 0.047619 )
	-- ps:setAlphaVariation( 0.0952381 )
	ps:setColors( 174, 16, 109, 101, 115, 141, 218, 46 )
end

return setup_func
