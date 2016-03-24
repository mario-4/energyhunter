module(..., package.seeall)  

starCtr = 0
stars = {}
currTransSpeed = 1000
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

function startSpace()
    timer.performWithDelay( 100, loadSpace , -5 )
--  timer.performWithDelay( 5000, loadPlanet , -1 )
end
