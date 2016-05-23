
local composer = require( "composer" )

local scene = composer.newScene()
spaceship={}
-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called
-- -----------------------------------------------------------------------------------------------------------------

-- Local forward references should go here

-- -------------------------------------------------------------------------------
particleDesigner = require( "screens.particleDesigner" )

local widget = require( "widget" )

asteroids = require("screens.asteroids")

spaceshipManager = require ("screens.spaceshipManager")

physics=require( "physics");

local function changeScene()
    composer.gotoScene( "screens.mainMenu", "crossFade", 600 )
end
-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view
    

    spaceship={}
    physics.start()
    --physics.setDrawMode("hybrid")
    physics.setGravity( 0, 0.6)

    
    spaceship = display.newImageRect("assets/spaceship.png",40,40)
    spaceshipManager.createSpaceShip(5,0,1,3,30,3,40,40)

    sceneGroup:insert(spaceship)

    local emitter = particleDesigner.init()
    sceneGroup:insert(emitter)
    _W = display.contentCenterX
    _H = display.contentCenterY
    _CX = display.contentCenterX
    _CY = display.contentCenterY
    _OX = display.screensOriginX
    _OY = display.screensOriginY
  
    ------------------------------------------------------ Planets ------------------------------------------------------------------

    local planet1 = display.newImage("assets/background/planet1.png",_W+400,_H-300)
    sceneGroup:insert(planet1)

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


    ------------------------------------------------------ Controles ------------------------------------------------------------------    


    local options = {
        width = 165,
        height = 30,
        numFrames = 2,
        sheetContentWidth = 330,
        sheetContentHeight = 30
    }
    local progressSheet = graphics.newImageSheet( "assets/gui/energybar2.png", options )

    local optionsMyEnergy = {
        width = 165,
        height = 30,
        numFrames = 2,
        sheetContentWidth = 330,
        sheetContentHeight = 30
    }
    local progressSheetMyEnergy = graphics.newImageSheet( "assets/gui/myenergybar.png", optionsMyEnergy )



    local progressView = widget.newProgressView(
        {
            sheet = progressSheetMyEnergy,
            x=233,
            y=30,
            left = 50,
            top = 200,
            width = 320,
            isAnimated = true,
            fillOuterLeftFrame = 1,
            fillOuterMiddleFrame = 1,
            fillOuterRightFrame = 1,
            fillOuterWidth = 30,
            fillOuterHeight = 30,
            fillInnerLeftFrame = 2,
            fillInnerMiddleFrame = 2,
            fillInnerRightFrame = 2,
            fillWidth = 30,
            fillHeight = 30,
            isAnimated = true
        }
    )
    sceneGroup:insert(progressView)


    local progressViewEmitter = widget.newProgressView(
        {

            sheet = progressSheet,
            x=1010,
            y=30,
            left = 342,
            top = 42,
            width = 320,
            fillOuterLeftFrame = 1,
            fillOuterMiddleFrame = 1,
            fillOuterRightFrame = 1,
            fillOuterWidth = 30,
            fillOuterHeight = 30,
            fillInnerLeftFrame = 2,
            fillInnerMiddleFrame = 2,
            fillInnerRightFrame = 2,
            fillWidth = 30,
            fillHeight = 30,
            isAnimated = true

        }
    )

    sceneGroup:insert(progressViewEmitter)

    progressView:setProgress(spaceship.energy*0.1 )

    progressView:setProgress(particleDesigner.getEmissionRate() )
    local shotButton = widget.newButton(
        {
            x= display.screenOriginY+70,
            y=display.contentHeight-70,
            defaultFile = "assets/gui/shotpw.png",
            overFile = "assets/gui/shotpwclicked.png",
            onPress = particleDesigner.shoot,
            xScale=-2,
            yScale=-2
        }
    )
    sceneGroup:insert(shotButton)
    local accelerateButton = widget.newButton(
        {
            x= display.screenOriginY+70,
            y=display.contentHeight-220,
            defaultFile = "assets/gui/capturepw.png",
            overFile = "assets/gui/accelerationpwclicked.png",
            onPress = spaceshipManager.accelerate
        }
    )
    sceneGroup:insert(accelerateButton)

    local decreaseEmitterButton = widget.newButton(
        {
            x= display.screenOriginX+620,
            y=display.screenOriginY+80,
            defaultFile = "assets/gui/centralButton.png",
            overFile = "assets/gui/centralButtonclicked.png",
            onPress =  particleDesigner.init_stop_decreasing_rate_emitter
           
        }
    )

    sceneGroup:insert(decreaseEmitterButton)
  ------------------------------------------------------ Pontuação ------------------------------------------------------------------    
   
    local function newText()
        imageLives= display.newImage("assets/gui/lives.png")
        imageLives.x=490
        imageLives.y=40
        imageScores = display.newImage("assets/gui/scores.png") 
        imageScores.x=745
        imageScores.y=40
        sceneGroup:insert(imageLives)
        sceneGroup:insert(imageScores)
        
        textLives = display.newText(spaceship.lives, 490, 40, nil, 28)
        textScore = display.newText(spaceship.score, 745, 40, nil, 28)
        --textEnergy = display.newText("Energy: "..spaceship.energy, 380, 30, nil, 28)
        sceneGroup:insert(textLives)
        sceneGroup:insert(textScore)
        
        textLives:setTextColor(255,255,255) 
        textScore:setTextColor(255,255,255)
       -- textEnergy:setTextColor(255,255,255) 
    end 

    local function updateText()
        textLives.text = spaceship.lives 
        textScore.text = spaceship.score 
       
        progressView:setProgress(spaceship.energy*0.1 )
        progressViewEmitter:setProgress(particleDesigner.getEmissionRate() )

        if (particleDesigner.checkProgress()) then
            --win = display.newText("Parabéns!", display.contentCenterX, 150, nil, 36)
            --sceneGroup:insert(win)
            composer.removeScene( "screens.scene1" )
            timer.cancel(tmrPontuacao)
            composer.gotoScene( "screens.conclusao", "crossFade", 1500 )
        end
         
    end  

    newText()

    ------------------------------------------------- Asteroids ----------------------------------------------------

    asteroids.initGame();

    ------------------------------------------------- Colisão ----------------------------------------------------


    function onCollision(event)    
        if((event.object1.myName=="asteroid" and event.object2.myName=="starFighter") or (event.object2.myName=="asteroid" and event.object1.myName=="starFighter")) then  
            if(spaceship.died == false) then    
                spaceship.died = true 
            end
            if(spaceship.lives == 0) then      
                media.playEventSound("audio/explosion-02.wav")
                event.object2.isDeleted=true  
                timer.cancel(tmrPontuacao)
                composer.gotoScene( "screens.derrotado", "crossFade", 1200 )  
            else      
                media.playEventSound("audio/explosion-02.wav")      
                spaceship.alpha = 0      
                spaceship.lives=spaceship.lives-1
                event.object2.isDeleted=true
                system.vibrate()      
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
    tmrPontuacao=timer.performWithDelay(500,updateText,0)

    function weDied()  -- pisca a nova nave 
        transition.to(spaceship, {alpha=1, timer=250})  
        spaceship.died=false 
    end 

end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen)
    elseif ( phase == "did" ) then
       -- composer.removeScene( "screens.mainMenu" )
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
        --spaceshipManager.cleanUp()
        --particleDesigner.cleanUp()
        --Runtime:removeEventListener("collision",onCollision)
        --asteroids.cleanUp()
        --physics.removeBody(spaceship)
        Runtime:removeEventListener("collision",onCollision)
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen
         composer.removeScene( "screens.scene1" )
    end
end

-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view

      spaceshipManager.cleanUp()
      particleDesigner.cleanUp()
      
      asteroids.cleanUp()
      Runtime:removeEventListener("collision",onCollision)
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

----------------------------------------------------------------------------------

return scene