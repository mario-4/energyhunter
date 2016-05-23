-- screens.mainMenu

local composer = require ("composer")       -- Include the Composer library. Please refer to -> http://docs.coronalabs.com/api/library/composer/index.html
local scene = composer.newScene()           -- Created a new scene

local widget = require ("widget")			-- Included the Widget library for buttons, tabs, sliders and many more
											-- Please refer to -> http://docs.coronalabs.com/api/library/widget/index.html

local stars = require("screens.stars")

stars.startSpace()

local mainGroup         -- Our main display group. We will add display elements to this group so Composer will handle these elements for us.
-- For more information about groups, please refer to this guide -> http://docs.coronalabs.com/guide/graphics/group.html


local function onButtonRelease (event)		-- This function will be called when the buttons are pressed
	if ( event.phase == "began" ) then
		print "event began"
	elseif ( event.phase == "moved" ) then
		print "event moved"
    elseif ( event.phase == "ended" or event.phase == "cancelled" ) then 		-- Check if the tap ended or cancelled
    	print "event ended"

        if ( event.target.id == "newGame" ) then
            composer.gotoScene( "screens.mainMenu", "crossFade", 1000 )

        elseif ( event.target.id == "credits" ) then
            composer.gotoScene( "screens.creditScreen", "crossFade", 1000 )
        end
    end
    return true 		-- To prevent more than one click

    -- For more information about events, please refer to the following documents
    -- http://docs.coronalabs.com/api/event/index.html
    -- http://docs.coronalabs.com/guide/index.html#events-and-listeners
end

function scene:create( event )
    local mainGroup = self.view         -- We've initialized our mainGroup. This is a MUST for Composer library.

    --[[
    Remember to insert the background image before other objects on the scene or it will overlapse the other objects

    local menubg = display.newImageRect( "assets/backgroundMenu.jpg", 1280, 720 )
    menubg.x = display.contentCenterX
    menubg.y = display.contentCenterY
    mainGroup:insert(menubg)
    ]]--
     local message =display.newImage("assets/gui/levels.png")
    message.x=display.contentCenterX
    message.y=display.contentCenterY-280

    mainGroup:insert(message)

    local buttonLevel1 = widget.newButton{		-- Creating a new button
        id="newGame",
        x= display.contentCenterX,
        y=600,
        defaultFile = "assets/gui/level.png",
        overFile = "assets/gui/level.png",
        onEvent = onButtonRelease		-- This function will be called when the button is pressed
    }

    mainGroup:insert(buttonLevel1)

    local buttonLevel2 = widget.newButton{		-- Creating a new button
        id = "level2",			-- Give an ID to identify the button in onButtonRelease()
        
        x= display.contentCenterX-180,
        y=410,
        defaultFile = "assets/gui/level2.png",
        overFile = "assets/gui/level2.png",
        onEvent = onButtonRelease   		-- This function will be called when the button is pressed
    }

    mainGroup:insert(buttonLevel2)


    local buttonLevel3 = widget.newButton{      -- Creating a new button
        id = "level3",          -- Give an ID to identify the button in onButtonRelease()
        
        x= display.contentCenterX-20,
        y=270,
        defaultFile = "assets/gui/level3.png",
        overFile = "assets/gui/level3.png",
        onEvent = onButtonRelease           -- This function will be called when the button is pressed
    }
    mainGroup:insert(buttonLevel3)
    local buttonCredits = widget.newButton{      -- Creating a new button
        id = "credits",          -- Give an ID to identify the button in onButtonRelease()
        
        x= display.contentCenterX+500,
        y=80,
        defaultFile = "assets/gui/pause.png",
        overFile = "assets/gui/pause.png",
        onEvent = onButtonRelease           -- This function will be called when the button is pressed
    }


    mainGroup:insert(buttonCredits)



end


function scene:show( event )
    local phase = event.phase

    if ( phase == "will" ) then         -- Scene is not shown entirely

    elseif ( phase == "did" ) then      -- Scene is fully shown on the screen

    	--You can remove other scenes but use it if you know what you're doing.
    	--composer.removeScene( "screens.gameLevel" )		-- This will destroy "gameLevel" scene.
    	--composer.removeScene( "screens.creditScreen" )	-- This will destroy "creditScreen" scene.
    end
end


function scene:hide( event )
    local phase = event.phase

    if ( phase == "will" ) then         -- Scene is not off the screen entirely

    elseif ( phase == "did" ) then      -- Scene is off the screen

    end
end

function scene:destroy( event )
	-- Called before the scene is removed
end

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene

-- You can refer to the official Composer template for more -> http://docs.coronalabs.com/api/library/composer/index.html#template