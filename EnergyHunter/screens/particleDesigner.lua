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
	emitter:start()
	physics.addBody(emitter)
	emitter.linearDamping=6



	g = display.newGroup()

    g.x = 1000
    g.y = 400
	g.anchorX = 0
    g.anchorY = 0
    emitter:toFront()
	g:insert(emitter)
	physics.addBody( g,"dynamic",{friction=0,bounce=0.3,radius=5,density=1} )
	g.anchorChildren = true
	g.isSensor=true
	g.gravityScale=0
	g.linearDamping=6
	g.angularDamping=60
	g:toFront()
	function move()
        
       g:setLinearVelocity(0,math.random(-500,500))

    end

    timer.performWithDelay(500,move,0)


	return g
end

return particleDesigner
