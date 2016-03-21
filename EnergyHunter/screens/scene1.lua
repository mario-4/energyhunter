
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called
-- -----------------------------------------------------------------------------------------------------------------

-- Local forward references should go here

-- -------------------------------------------------------------------------------


-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view


    _W = display.contentCenterX
    _H = display.contentCenterY

    local spaceship = display.newImage("assets/spaceship.png",_W-400,_H)
    spaceship.tx=0
    spaceship.ty=0
    --sceneGroup:Insert(spaceship)
    local physics=require( "physics");
    physics.start()
    physics.setGravity( 0, 0 )
    physics.addBody(spaceship )


    -------------------------------- Movement of spaceship ------------------------------------------------------------------
    spaceship.linearDamping=3
    spaceship.angularDamping=30

    spaceship.enterFrame = function(self,event)
        print(self.x,self.tx, self.y,self.ty)

        
        local area = 5
        if self.y <= self.ty + area and self.y >= self.ty - area then
            spaceship:setLinearVelocity(0,0) -- para a nave
           
        end
    end


    Runtime:addEventListener("enterFrame",spaceship)


    Runtime:addEventListener("touch",function(event)
        if event.phase == "began" or event.phase == "moved" then
            local  y = event.y
            local  ty =  y-spaceship.y -- calcula as novas coordenadas
            local sppedMultiplier = 2 -- muda a velocidade da nave

            --Seta o destino da nave
            spaceship.ty = y

            spaceship:setLinearVelocity(0,ty*sppedMultiplier) --this will set the velocity of the circle towards the computed touch coordinates on a straight path.
            --spaceship.angularVelocity=(ty*sppedMultiplier)

            --spaceship:rotate(-22)

        end
    end)


    ------------------------------------------------------ Stars ------------------------------------------------------------------
    starCtr = 0
    stars = {}
    currTransSpeed = 500
    displayHeight = display.screenOriginX
    math.randomseed( os.time() )

    local function removeMe() --remove stars after reaching end of screen
        for i=1,1100 do
            if stars[i] ~= nil then
                if stars[i].x == displayHeight then
                    display.remove( stars[i] )
                    stars[i] = nil
                end
            end
        end

        if starCtr >= 1000 then
            starCtr = 0
        end
    end

    local function loadSpace() -- create starts and move them
        for i=1,2 do
            starCtr = starCtr + 1
            local currX = math.random( 1,display.contentWidth+600)
            local currY = math.random( 1,display.contentHeight+200)
            local currRadius = math.random( 1,4)
            stars[starCtr] = display.newCircle( currX, currY, currRadius)
            transition.to( stars[starCtr], {x=display.screenOriginX - currRadius,time = currTransSpeed,onComplete = removeMe} )
        end    
    end

    local function startSpace()
        timer.performWithDelay( 1, loadSpace , -1 )
    --  timer.performWithDelay( 5000, loadPlanet , -1 )
    end

    startSpace()



    -- Initialize the scene here
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen)
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen
        -- Insert code here to make the scene come alive
        -- Example: start timers, begin animation, play audio, etc.
    end
end


-- "scene:hide()"
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen)
        -- Insert code here to "pause" the scene
        -- Example: stop timers, stop animation, stop audio, etc.
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen
    end
end


-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view

    -- Called prior to the removal of scene's view
    -- Insert code here to clean up the scene
    -- Example: remove display objects, save state, etc.
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene