local function setup_func(ps)
	ps:setEmissionRate( 181 )
	ps:setEmitterLifetime( -1 ) -- forever
	ps:setParticleLifetime( 0.396825, 0.992063 )
	ps:setDirection( -1.5708 )
	ps:setSpread( 6.28319 )
	-- ps:setRelative( false )
	ps:setSpeed( 104.762, 104.762 )
	ps:setLinearAcceleration( 128.571, 142.857 )
	ps:setRadialAcceleration( -142.857, -142.857 )
	ps:setTangentialAcceleration( -0.793652, -0.793652 )
	ps:setSizes( 0.129464, 1.79911 ) -- there's a bug in 0.7.1 that forces us to set the size variation using its own function
	ps:setSizeVariation( 0.150794 )
	ps:setSpin( 10.3175, 10.3175, 0 )
	-- ps:setColorVariation( 0.333333 )
	-- ps:setAlphaVariation( 0 )
	ps:setColors( 236, 255, 255, 244, 93, 26, 167, 28 )
end

return setup_func
