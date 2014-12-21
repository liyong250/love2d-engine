local function setup_func(ps)
	ps:setEmissionRate( 67 )
	ps:setEmitterLifetime( -1 ) -- forever
	ps:setParticleLifetime( 0.357143, 1.11111 )
	ps:setDirection( -1.5708 )
	ps:setSpread( 0.759043 )
	-- ps:setRelative( false )
	ps:setSpeed( 114.286, 190.476 )
	ps:setLinearAcceleration( 0, 0 )
	ps:setRadialAcceleration( 0, 0 )
	ps:setTangentialAcceleration( 0, 0 )
	ps:setSizes( 1.52902, 0.03125 ) -- there's a bug in 0.7.1 that forces us to set the size variation using its own function
	ps:setSizeVariation( 0.277778 )
	ps:setSpin( 0, 0, 0 )
	-- ps:setColorVariation( 0 )
	-- ps:setAlphaVariation( 0.484127 )
	ps:setColors( 255, 188, 0, 230, 145, 0, 62, 14 )
end

return setup_func
