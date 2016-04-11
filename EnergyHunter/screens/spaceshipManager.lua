module(..., package.seeall) 


local energy=0
local powerActives={}
local lives=3
local MyName="starFighter"
local spaceshipLocal

 _W = display.contentCenterX
 _H = display.contentCenterY
 _CX = display.contentCenterX
 _CY = display.contentCenterY
 _OX = display.screensOriginX
 _OY = display.screensOriginY

function createSpaceShip(energy,score,powerActives,linearDamping,angularDamping,lives,sizeX,sizeY)

	spaceshipLocal = display.newImageRect("assets/spaceship.png",sizeX,sizeY)
	physics.addBody( spaceshipLocal )
	spaceshipLocal.myName="starFighter"
	spaceshipLocal.linearDamping=3
    spaceshipLocal.angularDamping=30
    spaceshipLocal.energy=energy
    spaceshipLocal.lives=lives
    spaceshipLocal.powerActives=powerActives
    spaceshipLocal.score=score
    spaceshipLocal.died=false
	spaceshipLocal.tx=0
	spaceshipLocal.initialX=spaceshipLocal.x
    spaceshipLocal.ty=0
    spaceshipLocal.x=_W-400
    spaceshipLocal.y=_H
    spaceshipLocal.isSensor=true

    spaceshipLocal:toFront()

    Runtime:addEventListener("touch", onTouch )
    
    return spaceshipLocal
end

function onTouch(event)
        
    if event.phase == "began" or event.phase == "moved" then
        local  y = event.y
        local  ty =  y-spaceshipLocal.y -- calcula as novas coordenadas
        local sppedMultiplier = 2 -- muda a velocidade da nave

        --Seta o destino da nave
        spaceshipLocal.ty = y

        spaceshipLocal:setLinearVelocity(0,ty*sppedMultiplier)
        
    end
 end

function weDied()  -- pisca a nova nave 
    transition.to(spaceshipLocal, {alpha=1, timer=200})  
    spaceshipLocal.died=false 
end 


function accelerate()

	if spaceshipLocal.energy>0 then

		spaceshipLocal.tx = 400 
	    spaceshipLocal:setLinearVelocity(spaceshipLocal.tx*2,0)
	    
 		--timer.performWithDelay(1000,desaccelerate,1)   
		spaceshipLocal.energy= spaceshipLocal.energy-0.5
	end
end

function dispararEvento()
	spaceshipLocal:addEventListener( "acceleration", desaccelerate )
	local eventAcceleration ={name="acceleration",target=spaceshipLocal}
	spaceshipLocal:dispatchEvent( eventAcceleration )
end

function desaccelerate(event)

	while spaceshipLocal.initialX < spaceshipLocal.x do

		speedMultiplier=3
		spaceshipLocal.tx = -50
	    spaceshipLocal:setLinearVelocity(spaceship.tx,0)
	    
	end
end

