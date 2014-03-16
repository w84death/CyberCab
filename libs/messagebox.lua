-- 
--	Krzysztof Jankowski
--	P 1 X  G A M E S
--	
--	p1x.in
--	@w84death
--	
--	CYBERPUNK JAM [01.03.2014]
--
module(..., package.seeall)
local button = require("libs.buttons")

-- GLOBAL VIRABLES
-----------------------------------------------------------------------------------------
local background = nil
local messageText = nil
local closebutton = nil
local layer = nil
-- AUDIO
-------------------------------------------------------------------------------
local clickAudio = audio.loadSound( "media/sfx/click.wav" )

-- FUNCTIONS
-------------------------------------------------------------------------------

function newButton()
	local buttonParams = {}
   	buttonParams.layer = layer
   	buttonParams.x, buttonParams.y = 400, 250
   	buttonParams.label = 'CLOSE'
   	buttonParams.command = 'closeMessage'
   	closebutton = button.create( buttonParams )
   	closebutton:highlight()
   	globals.messageBoxActive = true   	
end

function newMessage(params)	
	layer = params.layer
	background = display.newImage( "media/gfx/message_box.png" )
	background.anchorX, background.anchorY = 0,0
	background.x, background.y = 0, 0
	background.alpha = 0
	params.layer:insert( background )

	messageText = display.newText( params.layer, params.message, 150, 90, 340, 160, "Homenaje", 12 )    
    messageText.anchorX, messageText.anchorY = 0,0
   	messageText:setFillColor ( 0.26,0.53,0.1 )
   	messageText.alpha = 0

   	transition.to( background, {time=490, alpha=1} )
	transition.to( messageText, {time=490, alpha=1} )
   	timer.performWithDelay( 500, newButton, 1 )
end

function destroy()
	background:removeSelf()
	messageText:removeSelf()
	background = nil
	messageText = nil
	globals.messageBoxActive = false
end

function closeMessage()	
	transition.to( background, {time=490, alpha=0} )
	transition.to( messageText, {time=490, alpha=0} )	
	closebutton:remove( layer )
	closebutton = nil
	timer.performWithDelay( 500, destroy, 1 )
end