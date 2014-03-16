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

-- GLOBAL VIRABLES
-----------------------------------------------------------------------------------------

function newMeter(params)
	local this = {}	
	this.ai = {}
	this.ai.right = 	0
	this.ai.left = 		0
	this.ai.idle = 		0
	this.horizontal = 	false
	this.vertical = 	false
	this.fuel = 		false
	this.damage = 		false

	function this:init(params)

		local url = nil
		local sheetData = nil

		if(params.horizontal)then
			this.horizontal = true
			url = "media/gfx/engine_power_horizontal.png"
			sheetData = { 
				width=38, height=25, 
				numFrames=10, 
				sheetContentWidth=190, 
				sheetContentHeight=50 }
		end
		if(params.vertical)then
			this.vertical = true
			url = "media/gfx/engine_power_vertical.png"
			sheetData = { 
				width=25, height=38, 
				numFrames=10, 
				sheetContentWidth=125, 
				sheetContentHeight=76 }
		end
		if(params.fuel)then
			this.fuel = true
			url = "media/gfx/fuel_damage.png"
			sheetData = { 
				width=110, height=10, 
				numFrames=10, 
				sheetContentWidth=110, 
				sheetContentHeight=110 }
		end
		if(params.damage)then
			this.fuel = true
			url = "media/gfx/fuel_damage.png"
			sheetData = { 
				width=110, height=10, 
				numFrames=11, 
				sheetContentWidth=110, 
				sheetContentHeight=110 }
		end

		local mySheet = graphics.newImageSheet( url, sheetData )
		 
		local counterAnimations = {
		    { name = "0", frames={1},time=100 },
		    { name = "1", frames={2},time=100 },
		    { name = "2", frames={3},time=100 },
		    { name = "3", frames={4},time=100 },
		    { name = "4", frames={5},time=100 },
		    { name = "5", frames={6},time=100 },
		    { name = "6", frames={7},time=100 },
		    { name = "7", frames={8},time=100 },
		    { name = "8", frames={9},time=100 },
		    { name = "9", frames={10},time=100 },
		    { name = "10", frames={11},time=100 },
		}
		 
		this.counter = display.newSprite( mySheet, counterAnimations )
		this.counter.anchorX, this.counter.anchorY = 0,0
		this.counter.x, this.counter.y = params.x,params.y
		this.counter:setSequence( "1" )
		params.layer:insert( this.counter )	
	end

	function this:setValue(params)
		this.counter:setSequence( params.frame )
	end

	return this
end