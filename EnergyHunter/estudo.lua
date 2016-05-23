
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

function onTouch(event)
        
    if event.phase == "began" then
        local  ty =  event.y-spaceshipLocal.y -- calcula as novas coordenadas
        --local tx  =  event.x-spaceshipLocal.x
        --local sppedMultiplier = 2 -- muda a velocidade da nave
        --spaceshipLocal:setLinearVelocity(0,ty*sppedMultiplier)
        
        local dest = math2d.diff(spaceshipLocal,event)
        dest = math2d.normalize(dest)
        dest = math2d.scale( dest, 950 )
        spaceshipLocal:setLinearVelocity(0,dest.y)
        
        local circ = display.newCircle( event.x, event.y, 1 )

        spaceshipLocal.enterFrame = function( self )

            
            self.rotation=0
            self.angularDamping=1
            local vec = math2d.diff( self.x,self.y,event.x,ty,true) 
            local ay=0
            local rotation = math2d.vector2Angle( vec ) 
            
            if self.y<event.y then 
                self.rotation=rotation*(0.5)
                ay=event.y-100
            else
                self.rotation=rotation*(0.5)*(-1)
                ay=event.y+100
            end

            if ay==math.floor(self.y) then
                
                print("aconteceu")
                self.rotation=0
                local circ2 = display.newCircle( self.x, self.y+100, 5 )
                local vec2 = math2d.diff( circ2.x,circ2.y,self.x,self.y,true) 
                local rotation2 = math2d.vector2Angle( vec2 ) 

                if self.y<event.y then 
                    self.rotation=rotation2
                else
                    self.rotation=rotation2*(-1)
                end
                Runtime:removeEventListener("enterFrame",spaceshipLocal)

            end       
            --print(rotation)
        end
        
        Runtime:addEventListener( "enterFrame", spaceshipLocal )
        
    end
 end


Runtime:addEventListener( "enterFrame", move );
