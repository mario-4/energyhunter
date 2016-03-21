module(..., package.seeall)  


asteroidsTable = {}
local numAsteroids = 0
local maxShotAge = 1000 
local maxAsteroidAge=1000
local tick=600
function loadAsteroids()
    numAsteroids= numAsteroids +1 
    asteroidsTable[numAsteroids] = display.newImageRect("assets/meteor3.png",50,50) 
    asteroidsTable[numAsteroids].myName="asteroid"
    physics.addBody(asteroidsTable[numAsteroids],{density=1,friction=0.4,bounce=1})

    asteroidsTable[numAsteroids].x = display.contentWidth+20
    asteroidsTable[numAsteroids].y = (math.random(display.contentHeight))
    asteroidsTable[numAsteroids].gravityScale=math.random(-1,1)
    local asteroid=asteroidsTable[numAsteroids]
    asteroid.rotation=0.002
    asteroid:setLinearVelocity(-100*2,0)
    function asteroid:enterFrame()
        
        self:rotate(math.random(0.6,1.6))
        self:translate(-4,0)
        if self.x <= -20 then
            Runtime:removeEventListener( "enterFrame", self )
            display.remove(self)
            self=nil
        end
    end

    Runtime:addEventListener( "enterFrame", asteroid )
end  

local function gameLoop() 
    
    loadAsteroids() 

end 


timer.performWithDelay(tick, gameLoop,0) 