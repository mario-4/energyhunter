local particleDesigner = {}

local json = require "json"

particleDesigner.loadParams = function( filename, baseDir )

	-- load file
	local path = system.pathForFile( filename, baseDir )

	local f = io.open( path, 'r' )

	local data = f:read( "*a" )
	f:close()

	-- convert json to Lua table
	local params = json.decode( data )

	return params
end

particleDesigner.newEmitter = function( filename, baseDir )

	local emitterParams = particleDesigner.loadParams( filename, baseDir )

	local emitter = display.newEmitter( emitterParams )


	return emitter
end


particleDesigner.init = function()

	emitterPrincipal=particleDesigner.newEmitter("assets/fire.json")
	
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
	
	local originY= display.screenOriginY + 20
	local finalY = display.contentHeight - 20

	local function move()

		local emitterY = g.y

		g:setLinearVelocity(0,math.random(-500,500))

		if(emitterY <= originY) then 
			g:applyForce(0,200,g.x,g.y)
		end  

		if(emitterY >= finalY) then 
			g:applyForce(0,-200,g.x,g.y)
		end  

	end


	timer.performWithDelay(500,move,0)

	timer.performWithDelay(math.random(4000,10000),initChildrens,0)

	return g
end 

function initChildrens()
	
	childrensGroup=display.newGroup()
	
	emitterChildren=particleDesigner.newEmitter("assets/miniFire.json")
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



return particleDesigner
