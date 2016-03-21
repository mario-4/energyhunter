
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
    

    physics=require( "physics");
    physics.start()
    physics.setGravity( 0, 0.6)

    local particleDesigner = require( "screens.particleDesigner" )

    local asteroids = require("screens.asteroids")

    local emitter = particleDesigner.init()


    _W = display.contentCenterX
    _H = display.contentCenterY
    
    local lives=3
    local energy=0
    local score=0

    local numshot =0
    local shotTable={}

    local spaceship = display.newImageRect("assets/spaceship.png",40,40)
    
    spaceship.x=_W-400
    spaceship.y=_H
    spaceship.tx=0
    spaceship.ty=0
    spaceship.myName="starFighter"

    spaceship:toFront()
    
    --physics.setDrawMode("hybrid")
    physics.addBody(spaceship)
    spaceship.isSensor=true

    -------------------------------- Movement of spaceship ------------------------------------------------------------------
    spaceship.linearDamping=3
    spaceship.angularDamping=30
    Runtime:addEventListener("touch",function(event)
        if event.phase == "began" or event.phase == "moved" then
            local  y = event.y
            local  ty =  y-spaceship.y -- calcula as novas coordenadas
            local sppedMultiplier = 2 -- muda a velocidade da nave

            --Seta o destino da nave
            spaceship.ty = y

            spaceship:setLinearVelocity(0,ty*sppedMultiplier)
            
        end
    end)

    ------------------------------------------------------ Planets ------------------------------------------------------------------

    local planet1 = display.newImage("assets/background/planet1.png",_W+400,_H-300)
    
    planet1:toBack()

    function planet1:enterFrame()

        self:translate(-0.2,0)
        if self.x <= -50 then
            Runtime:removeEventListener( "enterFrame", self )
            display.remove(self)
        end

    end

    Runtime:addEventListener("enterFrame",planet1 )

    ------------------------------------------------------ Stars ------------------------------------------------------------------
    starCtr = 0
    stars = {}
    currTransSpeed = 3000
    displayHeight = display.screenOriginX-10
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
            local currRadius = math.random( 0.5,1.0)
            stars[starCtr] = display.newCircle( currX, currY, currRadius)
            --stars[starCtr]:toBack()
            transition.to( stars[starCtr], {x=display.screenOriginX - currRadius,time = currTransSpeed,onComplete = removeMe} )
        end    
    end

    local function startSpace()
        timer.performWithDelay( 100, loadSpace , -5 )
    --  timer.performWithDelay( 5000, loadPlanet , -1 )
    end

    startSpace()



    ------------------------------------------------------ Pontuação ------------------------------------------------------------------    

    local function newText()   
        textLives = display.newText("Lives: "..lives, 70, 30, nil, 28)
        textScore = display.newText("Score: "..score, 180, 30, nil, 28)
        textEnergy = display.newText("Energy: "..energy, 300, 30, nil, 28)
        
        textLives:setTextColor(255,255,255) 
        textScore:setTextColor(255,255,255)
        textEnergy:setTextColor(255,255,255) 
    end 

    local function updateText()
        textLives.text = "Lives: "..lives 
        textScore.text = "Score: "..score 
        textEnergy.text = "Energy: "..energy 
        
    end  

    newText()

    ------------------------------------------------- Asteroids ----------------------------------------------------

    asteroids.loadAsteroids();

    ------------------------------------------------- Colisão ----------------------------------------------------


    local function onCollision(event)    
        if((event.object1.myName=="asteroid" and event.object2.myName=="starFighter") or (event.object2.myName=="asteroid" and event.object1.myName=="starFighter")) then  
            if(died == false) then    
                died = true 
            end
            if(lives == 0) then      
                media.playEventSound("audio/explosion-02.wav")
                
                local lose = display.newText("Você falhou.", display.contentCenterX, 150, nil, 36)      
                lose:setTextColor(255,255,255)   
            else      
                media.playEventSound("audio/explosion-02.wav")      
                spaceship.alpha = 0      
                lives=lives-1      
                --cleanup()      
                timer.performWithDelay(500,weDied,1)   
            end  
        end   

        if((event.object1.myName=="asteroid" and event.object2.myName=="shot") or (event.object1.myName=="shot" and event.object2.myName=="asteroid")) then   
            --media.playEventSound("sounds/explosion.wav")   
            event.object1:removeSelf()   
            event.object1.myName=nil   
            event.object2:removeSelf()   
            event.object2.myName=nil   
            score=score+100    
        end 


        if((event.object2.myName=="emitterChildren" and event.object1.myName=="starFighter")) then  
            energy=energy+1
            event.object2.isDeleted=true
            

        end 

    end  

    function weDied()  -- pisca a nova nave 
        transition.to(spaceship, {alpha=1, timer=2000})  
        died=false 
    end 


    Runtime:addEventListener("collision",onCollision)

    timer.performWithDelay(500,updateText,0)

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