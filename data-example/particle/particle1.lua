local function setup_func(ps)
	ps:setEmissionRate( 27 )
	ps:setEmitterLifetime( -1 ) -- forever
	ps:setParticleLifetime( 5, 5 )
	ps:setDirection( 3.1943 )
	ps:setSpread( 0 )
	-- ps:setRelative( false )
	ps:setSpeed( 0, 19.0476 )
	ps:setLinearAcceleration( 28.5714, 28.5714 )
	ps:setRadialAcceleration( 14.2857, -28.5714 )
	ps:setTangentialAcceleration( 0, -14.2857 )
	ps:setSizes( 1.77455, 1.77455 ) -- there's a bug in 0.7.1 that forces us to set the size variation using its own function
	ps:setSizeVariation( 0.68254 )
	ps:setSpin( 3.96825, 2.38095, 0 )
	-- ps:setColorVariation( 0 )
	-- ps:setAlphaVariation( 1 )
	ps:setColors( 255, 255, 255, 107, 255, 255, 255, 52 )
end

return setup_func
