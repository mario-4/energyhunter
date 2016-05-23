module(..., package.seeall) 


math2d = require "plugin.math2d"


local energy=0
local powerActives={}
local lives=3
local MyName="starFighter"
local runtimeAcceleration = 0
 _W = display.contentCenterX
 _H = display.contentCenterY
 _CX = display.contentCenterX
 _CY = display.contentCenterY
 _OX = display.screensOriginX
 _OY = display.screensOriginY

function cleanUp()
    if(spaceship.accelerating==true) then
        Runtime:removeEventListener("enterFrame",desaccelerate)
        print("limpou space")
    end
    Runtime:removeEventListener("touch",onTouch)
    --display.remove(spaceship)
    --physics.removeBody(spaceship)
    print("limpou space")
end


function createSpaceShip(energy,score,powerActives,linearDamping,angularDamping,lives,sizeX,sizeY)

	physics.addBody( spaceship )
	spaceship.myName="starFighter"
	spaceship.linearDamping=2.3
    spaceship.angularDamping=100
    spaceship.energy=energy
    spaceship.lives=lives
    spaceship.powerActives=powerActives
    spaceship.score=score
    spaceship.died=false
	spaceship.tx=0
    spaceship.ty=0
    spaceship.x=_W-400
    spaceship.y=_H
    spaceship.isSensor=true
    spaceship.initialX=spaceship.x
    spaceship.accelerating=false
    spaceship:toFront()

    Runtime:addEventListener("touch", onTouch )
    
end

function onTouch(event)
        
    if event.phase == "began" then
        local  ty =  event.y-spaceship.y -- calcula as novas coordenadas
        local tx  =  event.x-spaceship.x
        local sppedMultiplier = 2 -- muda a velocidade da nave
        spaceship:setLinearVelocity(0,ty*sppedMultiplier)
        
        --local dest = math2d.diff(spaceship,event)
        --dest = math2d.normalize(dest)
        --dest = math2d.scale( dest, 950 )
        --spaceship:setLinearVelocity(0,dest.y)


        
    end
 end

function weDied()  -- pisca a nova nave 
    transition.to(spaceship, {alpha=1, timer=200})  
    spaceship.died=false 
end 


function accelerate()

	if spaceship.energy>0 then

		spaceship.tx = 400 
	    spaceship:setLinearVelocity(spaceship.tx*2,0)
        spaceship.accelerating=true
		spaceship.energy= spaceship.energy-0.5
        timer.performWithDelay(1000,desaccelerateCallBack,1)
        --desaccelerateCallBack()
	end

end

function desaccelerateCallBack(  )
    if(spaceship.accelerating==false) then
        Runtime:removeEventListener("enterFrame",desaccelerate)
    else
        spaceship.accelerating=true
        Runtime:addEventListener("enterFrame",desaccelerate)
        runtimeAcceleration=0
    end
end

function desaccelerate()
   
    dt=getDeltaTimeSpaceShip()
    print(spaceship)
    if (spaceship.initialX ~= nil and spaceship.x~=nil) then
        if(spaceship.initialX<=spaceship.x) then
            spaceship:translate(-0.2,0)
        else
            spaceship.accelerating=false
            Runtime:removeEventListener("enterFrame",desaccelerate)
            runtimeAcceleration=0
        end   
    end
end

function getDeltaTimeSpaceShip()
    local temp = system.getTimer()
    local dt = (temp-runtimeAcceleration) / (1000/60) 
    runtimeAcceleration = temp
    return dt
end