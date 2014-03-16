-- 
--	Krzysztof Jankowski
--	P 1 X  G A M E S
--	
--	p1x.in
--	@w84death
--	
--	CYBERPUNK JAM [01.03.2014]
--

-- LIBS
-------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local game = require("libs.game")
local backgroundMusic = audio.loadStream( "media/sfx/game.mp3" )
local backgroundMusicChannel = audio.play( backgroundMusic, { loops=-1 }  )

-- FUNCTIONS
-------------------------------------------------------------------------------
local function onKeyEvent( event )	
	if( event.phase == "up" ) then		
		if ( event.keyName == "buttonA" ) then
		end
		if ( event.keyName == "buttonB" ) then			
			game.steerCab({hover=true})
		end
		if ( event.keyName == "buttonX" ) then
		end
		if ( event.keyName == "buttonY" ) then
		end
		if ( event.keyName == "menu") then	
			storyboard.gotoScene( 'lobby', "fade", 500 )			
		end
	end
	--if( event.phase == "down" ) then
		if ( event.keyName == "up" ) then
			game.steerCab({up=true})			
		end
		if ( event.keyName == "down" ) then
			game.steerCab({down=true})		
		end
		if ( event.keyName == "left" ) then
			game.steerCab({left=true})
		end
		if ( event.keyName == "right" ) then
			game.steerCab({right=true})
		end
	--end]]--
end

local function onAxisEvent( event )    
    local AXIS_SCALER = 100;

	local valAxis = event.normalizedValue;
	if (math.abs(valAxis) < 0.1) then
		valAxis = 0;
	elseif (valAxis < 0) then
		valAxis = (valAxis + 0.1) / 0.7;
	elseif (valAxis > 0) then
		valAxis = (valAxis - 0.1) / 0.7;
	end
	game.steerCab({axis=true, number=event.axis.number, value=valAxis*AXIS_SCALER})
	
end

local function onCollision( event )
    if ( event.phase == "began" ) then    	

    	if(event.object2.name == "player")then
	    	local vx, vy = event.object2:getLinearVelocity()		
			local dmg = math.max(vx,vy)
			if(dmg>50)then
				game.shakeamount = 15
	    		game.collision({damage=dmg*0.1})
	    		game.pushBack({x=vx, y=vy})
	    	else

		    	if(event.object1.name == "platform")then
		    		local position = {}
		    		position.x = event.object1.x
		    		position.y = event.object1.y
		        	game.playerLandedOnPlatform({landed=true, position=position, letter=event.object1.letter, flip=event.object1.flip})
		    	end
		    end
		end

    elseif ( event.phase == "ended" ) then
    	if(event.object1.name == "platform")then
        	game.playerLandedOnPlatform({exit=true})
        end
    end
end
local function onEveryFrame()
	game.runEngine()
	game.shake()
end

function scene:createScene( event )
	local group = self.view
	game.init(group)
end

function scene:enterScene( event )
	local group = self.view	
	Runtime:addEventListener( "key" , onKeyEvent )
	Runtime:addEventListener( "axis", onAxisEvent )
	Runtime:addEventListener( "enterFrame", onEveryFrame )
	audio.play( backgroundMusicChannel, { loops=-1 }  )
end

function scene:exitScene( event )
	local group = self.view	
	Runtime:removeEventListener( "key" , onKeyEvent )	
	Runtime:removeEventListener( "axis", onAxisEvent )
	Runtime:removeEventListener( "enterFrame", onEveryFrame )
	audio.stop( backgroundMusicChannel )
end

function scene:destroyScene( event )
	local group = self.view
	game.destroy()
	Runtime:removeEventListener( "key" , onKeyEvent )
	Runtime:removeEventListener( "axis", onAxisEvent )
	Runtime:removeEventListener( "enterFrame", onEveryFrame )
end

-- EVENTS
-------------------------------------------------------------------------------
scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )
Runtime:addEventListener( "collision", onCollision )

-----------------------------------------------------------------------------------------

return scene