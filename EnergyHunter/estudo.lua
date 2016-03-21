
local background = display.newImage("backgroundspace2.png")
background.anchorX=0

background.x = 0
background.y = 480

local background2 = display.newImage( "backgroundspace2.png" )
background2.anchorX=0
background2.x = 800
background2.y = 480



local tPrevious = system.getTimer()
local function move(event)
	local tDelta = event.time - tPrevious
	tPrevious = event.time


	local xOffset = ( 0.6 * tDelta )


	background.x = background.x - xOffset
	background2.x = background2.x - xOffset
	
	if (background.x + background.contentWidth) < 0 then
		background:translate( 800 * 2, 0)
	end
	if (background2.x + background2.contentWidth) < 0 then
		background2:translate( 800 * 2, 0)
	end

end

Runtime:addEventListener( "enterFrame", move );
