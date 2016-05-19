local particleDesigner = {}

local json = require "json"
local pex = require "libraries.pex"
local particle = pex.load("assets/particles/particle.pex","assets/particles/texture.png")
local timerMove
local timerDecrease
local initialEmissionRate
isAbsorbing=false
local canAbsorve=false

numShot=0

particleDesigner.loadParams = function( filename, baseDir )

	local path = system.pathForFile( filename, baseDir )
	local f = io.open( path, 'r' )
	local data = f:read( "*a" )
	f:close()	
	local params = json.decode( data )

	return params
end

particleDesigner.newEmitter = function( filename, baseDir )

	local emitterParams = particleDesigner.loadParams( filename, baseDir )
	local emitter = display.newEmitter( emitterParams )
	return emitter
end

particleDesigner.init = function()

	emitterPrincipal=particleDesigner.newEmitter("assets/particles/fire.json")
	
	g = display.newGroup()
    g.x = 1000
    g.y = 400
 
	g:insert(emitterPrincipal)
	
	physics.addBody( g,"dynamic",{friction=0.25,bounce=0.95,radius=5,density=1} )
	g.anchorChildren = true
	g.isSensor=true
	g.gravityScale=0
	g.linearDamping=6
	g.angularDamping=60
	g.isFixedRotation=true
	
	originY= display.screenOriginY + 20
	finalY = display.contentHeight - 20

	initMovement()
	initialEmissionRate=emitterPrincipal.emissionRateInParticlesPerSeconds
	timer.performWithDelay(math.random(4000,10000),initChildrens,0)

	return g
end

particleDesigner.shoot = function()
	
	if(spaceship.energy>0) then
		childrensFireshot=display.newGroup()
		childrensFireshot.x=spaceship.x
		childrensFireshot.y=spaceship.y
		emitterFireshot=particleDesigner.newEmitter("assets/particles/fireshot.json")
		emitterFireshot.x=childrensFireshot.x
		emitterFireshot.y=childrensFireshot.y
		numShot = numShot+1  
		childrensFireshot:insert(emitterFireshot)

		physics.addBody(childrensFireshot, {density=1, friction=0})  
		childrensFireshot.isbullet = true  
		childrensFireshot.anchorChildren = true
		childrensFireshot.gravityScale=0

		transition.to(childrensFireshot, {x=display.contentWidth+150, time=500})  
		--media.playEventSound("audio/tir.mp3")  
		childrensFireshot.myName="shot"  
		childrensFireshot.age=0 
		spaceship.energy=spaceship.energy-0.25
	end
end 

particleDesigner.init_stop_decreasing_rate_emitter = function()
	if(canAbsorve) then
		if(not isAbsorbing) then
			radial = display.newEmitter(particle)
	    	stopMovement()
			radial.x=g.x-80
	    	radial.y=g.y
			timerDecrease = timer.performWithDelay(500,decrease_rate,0)
			print(g)
			isAbsorbing=true
		else
			timer.cancel(timerDecrease)
			display.remove(radial)
			radial=null
			initMovement()
			isAbsorbing=false
		end

	end
end

function checkDistance()
	local xDistance = g.x-spaceship.x
	local yDistance = g.y-spaceship.y
	--print(xDistance,yDistance)
	if(xDistance<150 and xDistance>-30 and yDistance<50 and yDistance>-50) then
		canAbsorve=true
	
	else
		canAbsorve=false
		if(isAbsorbing) then 
			timer.cancel(timerDecrease)
			display.remove(radial)
			radial=null
			initMovement()
			isAbsorbing=false
		end	
		
	end

end

function decrease_rate( )
	rateDecrease=emitterPrincipal.emissionRateInParticlesPerSeconds * 0.4
	emitterPrincipal.emissionRateInParticlesPerSeconds= emitterPrincipal.emissionRateInParticlesPerSeconds-rateDecrease
end

particleDesigner.getEmissionRate = function ()
	print(emitterPrincipal.emissionRateInParticlesPerSeconds/initialEmissionRate)
	return emitterPrincipal.emissionRateInParticlesPerSeconds/initialEmissionRate
end


particleDesigner.checkProgress = function ()
	local res=false
	if (emitterPrincipal.emissionRateInParticlesPerSeconds/initialEmissionRate<=0.05) then
		res=true; 	
	end 

	return res
end

function move()

	local emitterY = g.y

	g:setLinearVelocity(0,math.random(-500,500))

	if(emitterY <= originY) then 
		g:applyForce(0,200,g.x,g.y)
	end  

	if(emitterY >= finalY) then 
		g:applyForce(0,-200,g.x,g.y)
	end  

end

function initChildrens()
	if(emitterPrincipal.emissionRateInParticlesPerSeconds/initialEmissionRate>0.05) then
		childrensGroup=display.newGroup()
		
		emitterChildren=particleDesigner.newEmitter("assets/particles/miniFire.json")
		childrensGroup.myName="emitterChildren"
		childrensGroup.x=g.x
		childrensGroup.y=g.y
		
		childrensGroup:insert(emitterChildren)

		physics.addBody( childrensGroup ,"dynamic",{friction=0.25,bounce=0.95,radius=5,density=1} )
		childrensGroup.anchorChildren = true
		childrensGroup.isSensor=true
		childrensGroup.gravityScale=0
		childrensGroup.linearDamping=6
		childrensGroup.angularDamping=60
		childrensGroup.isFixedRotation=true

		function childrensGroup:enterFrame()
	        
	        --self:rotate(math.random(0.6,1.6))
	        self:translate(-12,0)
	        if self.x <= -20 then
	            Runtime:removeEventListener( "enterFrame", self )
	            display.remove(self)
	            self=nil
	        
	        elseif self.isDeleted then 
	        	Runtime:removeEventListener( "enterFrame", self )
	        	display.remove(self)
	        	self=nil
	        end
	        
	    end

	    Runtime:addEventListener( "enterFrame", childrensGroup )
	end
end

function initMovement()
	timerMove = timer.performWithDelay(1000,move,0)
end

function stopMovement()
    timer.cancel(timerMove)
end

Runtime:addEventListener( "enterFrame", checkDistance )

particleDesigner.cleanUp=function ( )
	
	
	Runtime:removeEventListener( "enterFrame", checkDistance )

end

return particleDesigner
