-- 
--	Krzysztof Jankowski
--	P 1 X  G A M E S
--	
--	p1x.in
--	@w84death
--	
--	CYBERPUNK JAM [01.03.2014]
--

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local GO = require("libs.gameover")

local backgroundMusic = audio.loadStream( "media/sfx/menu.mp3" )
local backgroundMusicChannel = audio.play( backgroundMusic, { loops=-1 }  ) 


local function onKeyEvent( event )
	if ( event.keyName == "buttonA" and event.phase == "up") then
		storyboard.purgeAll()
		storyboard.gotoScene( "intro", "fade", 500 )		
	end
end

function scene:createScene( event )
	local group = self.view
	GO.init(group)

end

function scene:enterScene( event )
	local group = self.view	
	Runtime:addEventListener( "key" , onKeyEvent )
	audio.play( backgroundMusicChannel  ) 
end

function scene:exitScene( event )
	local group = self.view		
	Runtime:removeEventListener( "key" , onKeyEvent )
	audio.stop( backgroundMusicChannel )
end

function scene:destroyScene( event )
	local group = self.view
	intro.destroy()
	Runtime:removeEventListener( "key" , onKeyEvent )
	package.loaded[GO] = nil
end

-- EVENTS
-------------------------------------------------------------------------------
scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene