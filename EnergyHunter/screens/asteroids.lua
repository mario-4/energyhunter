module(..., package.seeall)  


asteroidsTable = {}
local numAsteroids = 0
local maxShotAge = 1000 
local maxAsteroidAge=1000
local numShot=0
local shotTable={}
local tick=900
local runtime = 0
local group=display.newGroup()

function loadAsteroids()
    numAsteroids= numAsteroids +1 
    asteroidsTable[numAsteroids] = display.newImageRect("assets/asteroids/ast"..math.random(1,7)..".png",math.random(50,100),math.random(50,100)) 
    asteroidsTable[numAsteroids].myName="asteroid"
    physics.addBody(asteroidsTable[numAsteroids],{density=1,friction=0.4,bounce=1})

    asteroidsTable[numAsteroids].x = display.contentWidth+20
    asteroidsTable[numAsteroids].y = (math.random(display.contentHeight))
    asteroidsTable[numAsteroids].gravityScale=math.random(-2,6)
    asteroidsTable[numAsteroids].isSensor=true
    
    local asteroid=asteroidsTable[numAsteroids]
    asteroid.rotation=0.002

    group:insert(asteroid)
    asteroid:setLinearVelocity(50*2,0)


end  

function frameUpdate()
    dt=getDeltaTime()
    

    for i=1,group.numChildren do
        local child = group[i]
        if(child~=nil) then
            child:translate(-12*dt,0)
            child:rotate(dt*(math.random(0.6,1.6)))
            --child:applyLinearImpulse(dt*0.8,0,child.x,child.y)
            if child.x <= -20 then
                group:remove(child)
            
            elseif child.isDeleted then 
                group:remove(child)
                child=nil
            end
        end
        
    end
end


function getDeltaTime()
    local temp = system.getTimer()  -- Get current game time in ms
    local dt = (temp-runtime) / (1000/60)  -- 60 fps or 30 fps as base
    runtime = temp  -- Store game time
    return dt
end

local function gameLoop() 
        loadAsteroids() 
end 

function cleanUp()
    
    Runtime:removeEventListener( "enterFrame", frameUpdate )
    timer.cancel(tmrGameLoop)
    for i=1,group.numChildren do
        local child = group[i]
        if(child~=nil) then
    
            group:remove(child)
            
        end
        
    end
    for i=1,numAsteroids do
        local child = asteroidsTable[i]
        if(child~=nil) then
           display:remove(child)
           child=nil           
        end
        
    end

end

function initGame()
    tmrGameLoop=timer.performWithDelay(tick, gameLoop,0) 

    Runtime:addEventListener( "enterFrame", frameUpdate )
end