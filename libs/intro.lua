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

local function drawIntro()	
	local background = display.newImage( "media/gfx/menu_background.png" )
	background.anchorX, background.anchorY = 0,0
	background.x, background.y = 0, 0

	local pressStart = display.newText( layerGUI, "PRESS O TO START", _C,220, "Homenaje", 14 )
	pressStart:setFillColor( 0.26,0.53,0.1 )
	pressStart.alpha = 0

	local credits = display.newText( layerGUI, "CODE & DESIGN: KRZYSZTOF JANKOWSKI", 20,330, "Homenaje", 12 )
	credits.anchorX = 0
	credits:setFillColor ( 0.26,0.53,0.1 )

	local copyright = display.newText( layerGUI, "©2014 P1X GAMES", _C,330, "Homenaje", 12 )
	copyright:setFillColor ( 0.26,0.53,0.1 )

	local credits2 = display.newText( layerGUI, "MUSIC: NOSOAPRADIO.US", _W-20,330, "Homenaje", 12 )
    credits2.anchorX = 1
    credits2:setFillColor( 0.26,0.53,0.1 )
	
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
	layerGUI:insert( copyright )
	layerGUI:insert( credits )
	layerGUI:insert( credits2 )
end

function init(group)	
	group:insert(layerBackground)
	group:insert(layerGUI)
	drawIntro()
end

function destroy()
	pressStart_blink = nil
end

-- EVENTS
-------------------------------------------------------------------------------

