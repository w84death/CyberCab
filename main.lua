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
