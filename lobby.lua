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
local lobby = require("libs.lobby")

local backgroundMusic = audio.loadStream( "media/sfx/lobby.mp3" )
local backgroundMusicChannel = audio.play( backgroundMusic, { loops=-1 }  )

local function onKeyEvent( event )	
	if( event.phase == "up" ) then
		if( globals.messageBoxActive == false ) then
			if ( event.keyName == "menu" ) then								
				storyboard.gotoScene( 'intro', "fade", 500 )						
			end
			if ( event.keyName == "buttonA" ) then				
				local goTo = lobby.executeButton()
				if( goTo ~= false )then
					storyboard.gotoScene( goTo, "fade", 500 )
				end
			end
			if (event.keyName == "buttonB") then
				lobby.showMessageBox()
			end

			if ( event.keyName == "down" ) then
				if( lobby.activeButton.row < #lobby.buttonList )then
					lobby.activeButton.row = lobby.activeButton.row + 1
					if( #lobby.buttonList[lobby.activeButton.row] < lobby.activeButton.col ) then
						lobby.activeButton.col = 1
					end
					lobby.highlightActiveButton()
				end
			end

			if ( event.keyName == "up" ) then
				if( lobby.activeButton.row > 1 )then
					lobby.activeButton.row = lobby.activeButton.row - 1
					if( #lobby.buttonList[lobby.activeButton.row] < lobby.activeButton.col ) then
						lobby.activeButton.col = 1
					end
					lobby.highlightActiveButton()
				end
			end

			if ( event.keyName == "right" ) then
				if( lobby.activeButton.col < #lobby.buttonList[lobby.activeButton.row] )then
					lobby.activeButton.col = lobby.activeButton.col + 1
					lobby.highlightActiveButton()
				end
			end

			if ( event.keyName == "left" ) then
				if( lobby.activeButton.col > 1 )then
					lobby.activeButton.col = lobby.activeButton.col - 1
					lobby.highlightActiveButton()
				end
			end

		end
		if( globals.messageBoxActive == true ) then
			if ( event.keyName == "buttonA") then
				lobby.removeMessageBox()		
			end
		end
	end
end

function scene:createScene( event )
	local group = self.view

	lobby.init(group)

end

function scene:enterScene( event )
	local group = self.view	
	Runtime:addEventListener( "key" , onKeyEvent )
	lobby.activateLobby()
	audio.play( backgroundMusicChannel )	
end

function scene:exitScene( event )
	local group = self.view	
	Runtime:removeEventListener( "key" , onKeyEvent )
	audio.stop( backgroundMusicChannel )		
end

function scene:destroyScene( event )
	local group = self.view	
	Runtime:removeEventListener( "key" , onKeyEvent )
	lobby.destroy()
	package.loaded[lobby] = nil
end

-- EVENTS
-------------------------------------------------------------------------------
scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene