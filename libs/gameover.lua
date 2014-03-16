-------------------------------------------------------------------------------
--
--	Krzysztof Jankowski
--	P 1 X  G A M E S
--	
--	p1x.in
--	@w84death
--	
--	CYBERPUNK JAM [01.03.2014]
--
-------------------------------------------------------------------------------

module(..., package.seeall)
-- GLOBAL VIRABLES
-------------------------------------------------------------------------------
local _W = display.contentWidth
local _H = display.contentHeight
local _C = display.contentWidth * 0.5

-- LAYERS
-------------------------------------------------------------------------------

local layerBackground = display.newGroup( )
local layerGUI = display.newGroup( )

-- AUDIO
-------------------------------------------------------------------------------
--local clickAudio = audio.loadSound( "media/sfx/click.wav" )

-- FUNCTION LIST
-------------------------------------------------------------------------------

local drawMenu = nil
local killEvents = nil
local drawButton = nil
init = nil

-- FUNCTIONS
-------------------------------------------------------------------------------

local function drawGameOver()	
	local background = display.newImage( "media/gfx/gameover_background.png" )
	background.anchorX, background.anchorY = 0,0
	background.x, background.y = 0, 0

	local pressStart = display.newText( layerGUI, "PRESS O TO START OVER", 220,70, "Homenaje", 10 )
	pressStart:setFillColor( 0.18,0.28,0.30 )
	pressStart.alpha = 0

	local title = display.newText( layerGUI, "GAME OVER", _C,150, "Homenaje", 24 )
	title.anchorX = 0.5
	title:setFillColor ( 0.64,0.81,0.15 )

	local daysText = 'DAYS'
	if (globals.days==1)then
		daysText = 'DAY'
	end
	local options = {
	    parent = layerGUI,
	    text = "\" YOU HAVE ONLY BEEN A\nTAXI DRIVER FOR ".. globals.days .." ".. daysText ..",\n\nYOU SHOUD NEVER RUN\nA TAXI AGAIN \"",     
	    x = _C,
	    y = 230,
	    width = 140,
	    font = "Homenaje",   
	    fontSize = 14,
	    align = "center"
	}
	local lastMessage = display.newText( options )
	lastMessage:setFillColor ( 0.18,0.28,0.30 )
	
	local function blink()
	    if(pressStart.alpha < 1) then
	        transition.to( pressStart, {time=490, alpha=1})
	    else 
	        transition.to( pressStart, {time=490, alpha=0.1})
	    end
	end
	pressStart_blink = timer.performWithDelay(500, blink, 0)

	layerBackground:insert( background )
	layerGUI:insert( pressStart )
	layerGUI:insert( lastMessage )
	layerGUI:insert( title )
end

function init(group)	
	group:insert(layerBackground)
	group:insert(layerGUI)
	drawGameOver()
end

function destroy()
	pressStart_blink = nil
end

-- EVENTS
-------------------------------------------------------------------------------

