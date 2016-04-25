# Jogo EnergyHunter

- Basic Composer and Widget functions
- Working with folders
- Events and Listeners
- Creating images and texts
- Defining variables to objects
- Timers and Transitions

------------------------------- Rascunho --------------------------------------------------

function desaccelerate(event)

	while spaceshipLocal.initialX < spaceshipLocal.x do

		speedMultiplier=3
		spaceshipLocal.tx = -50
	    spaceshipLocal:setLinearVelocity(spaceship.tx,0)
	    
	end
end
