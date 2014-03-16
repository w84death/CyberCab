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

local DEVELOPER_ID = "a088e804-017e-4a03-ac49-3bf30eb87034";
audio.setVolume( 0.75 )

-- LIBS
-------------------------------------------------------------------------------
simulatorController = require( "simulatorController" )
globals = require "libs.globals"
local storyboard = require "storyboard"

-- SETTINGS
-------------------------------------------------------------------------------
display.setDefault( "magTextureFilter", "nearest" )
display.setDefault( "minTextureFilter", "linear" )

-- FUNCTIONS
-------------------------------------------------------------------------------
storyboard.gotoScene( "game" )
