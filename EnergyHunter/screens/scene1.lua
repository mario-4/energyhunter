
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

    local spaceshipManager = require ("screens.spaceshipManager")

    spaceship=spaceshipManager.createSpaceShip(1,0,1,3,30,3,40,40)

    local emitter = particleDesigner.init()

    _W = display.contentCenterX
    _H = display.contentCenterY
    _CX = display.contentCenterX
    _CY = display.contentCenterY
    _OX = display.screensOriginX
    _OY = display.screensOriginY
  
    ------------------------------------------------------ Planets ------------------------------------------------------------------

    local planet1 = display.newImage("assets/background/planet1.png",_W+400,_H-300)
    
    planet1:toBack()

    function planet1:enterFrame()

        self:translate(-0.1,0)
        if self.x <= -self.width then
            Runtime:removeEventListener( "enterFrame", self )
            display.remove(self)
        end

    end

    Runtime:addEventListener("enterFrame",planet1 )

    ------------------------------------------------------ Stars ------------------------------------------------------------------

    local stars = require("screens.stars")

    stars.startSpace()



    ------------------------------------------------------ Pontuação ------------------------------------------------------------------    

    local function newText()   
        textLives = display.newText("Lives: "..spaceship.lives, 70, 30, nil, 28)
        textScore = display.newText("Score: "..spaceship.score, 220, 30, nil, 28)
        textEnergy = display.newText("Energy: "..spaceship.energy, 380, 30, nil, 28)
        
        textLives:setTextColor(255,255,255) 
        textScore:setTextColor(255,255,255)
        textEnergy:setTextColor(255,255,255) 
    end 

    local function updateText()
        textLives.text = "Lives: "..spaceship.lives 
        textScore.text = "Score: "..spaceship.score 
        textEnergy.text = "Energy: "..spaceship.energy 
        
    end  

    newText()

    ------------------------------------------------- Asteroids ----------------------------------------------------

    asteroids.loadAsteroids();

    spaceship:addEventListener("tap", particleDesigner.shoot)
    ------------------------------------------------- Colisão ----------------------------------------------------


    local function onCollision(event)    
        if((event.object1.myName=="asteroid" and event.object2.myName=="starFighter") or (event.object2.myName=="asteroid" and event.object1.myName=="starFighter")) then  
            if(spaceship.died == false) then    
                spaceship.died = true 
            end
            if(spaceship.lives == 0) then      
                media.playEventSound("audio/explosion-02.wav")
                local lose = display.newText("Você falhou.", display.contentCenterX, 150, nil, 36)      
                lose:setTextColor(255,255,255)
                event.object2.isDeleted=true    
            else      
                media.playEventSound("audio/explosion-02.wav")      
                spaceship.alpha = 0      
                spaceship.lives=spaceship.lives-1
                event.object2.isDeleted=true      
                --cleanup()      
                timer.performWithDelay(200,weDied,1)   
            end  
        end   

        if((event.object1.myName=="asteroid" and event.object2.myName=="shot") or (event.object1.myName=="shot" and event.object2.myName=="asteroid")) then   
            media.playEventSound("audio/explosion-02.wav")
            event.object1:removeSelf()   
            event.object1.myName=nil   
            event.object2:removeSelf()   
            event.object2.myName=nil   
            spaceship.score=spaceship.score+100    
        end 


        if((event.object2.myName=="emitterChildren" and event.object1.myName=="starFighter")) then  
            spaceship.energy=spaceship.energy+1
            event.object2.isDeleted=true
            

        end 

    end  

    Runtime:addEventListener("collision",onCollision)

    timer.performWithDelay(500,updateText,0)

    function weDied()  -- pisca a nova nave 
        transition.to(spaceship, {alpha=1, timer=250})  
        spaceship.died=false 
    end 

end
function weDied()  -- pisca a nova nave 
    transition.to(spaceshipLocal, {alpha=1, timer=200})  
    spaceshipLocal.died=false 
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