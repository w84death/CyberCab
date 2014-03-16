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


function new()
	local this = {}
	this.landedOn = nil
	this.fuel = 		100
	this.damage = 		0
	this.density =		1.0
	this.doorOpen =		false
	this.hasClient =	false

	this.engine = {}
	this.engine.fuel = globals.fuel
	this.engine.on = true
	this.engine.power = {}
	this.engine.power.x = 0
	this.engine.power.y = 0
	this.engine.power.Sx = 0
	this.engine.power.Sy = 0
	this.k = 0.95

	function this:init(params)
		local sheetData = { 
		width=65, height=24, 
		numFrames=16, 
		sheetContentWidth=260, 
		sheetContentHeight=96 }
 		

		local mySheet = graphics.newImageSheet( "media/gfx/cab_spritesheet.png", sheetData )
		 
		local cabAnimations = {
		    { name = "idle", start=1, count=4, time=800 },
		    { name = "openDoors", frames={ 1,5,6,7,8,9,10,11,12,12,14,15,16 }, time=400, loopCount=1 },
		    { name = "closeDoors", frames={ 16,15,14,13,12,11,10,9,8,7,6,5,1 }, time=400, loopCount=1 }
		}
		 
		this.x = params.x
		this.y = params.y
		this.cab = display.newSprite( mySheet, cabAnimations )
		this.cab.x, this.cab.y = this.x, this.y		 
		this.cab:setSequence( "idle" )
		this.cab:play()

		this.cab.name = 'player'

		physics.addBody( this.cab, "dynamic", { density=this.density, friction=0, bounce=0.1 } )
		this.cab.isFixedRotation = true

		local function switchLights( event )
		 	this:switchLights(event)
		end
		this.cab:addEventListener( "sprite", switchLights )
	end

	function this:smoothEnginePower(params)
		if(params.x)then
			this.engine.power.x = params.x
		end
		if(params.y)then
			this.engine.power.y = params.y
		end
	end

	function this:runEngine()
		this.engine.power.Sx = this.k * this.engine.power.Sx + (1.0 - this.k) * this.engine.power.x
		this.engine.power.Sy = this.k * this.engine.power.Sy + (1.0 - this.k) * this.engine.power.y
		
		if(this.engine.power.x > 0)then
			this.cab.xScale = -1
		else
			this.cab.xScale = 1
		end
		this.cab:setLinearVelocity( math.floor(this.engine.power.Sx*4), math.floor(this.engine.power.Sy*4))
		globals.fuel = globals.fuel - 0.01
	end

	function this:stopCab()
		this.engine.power.x, this.engine.power.y = 0,0
		this.cab:setLinearVelocity( 0, 0)
	end

	function this:activateDoors()	
		if( this.engine.power.x == 0 and this.engine.power.y == 0)then
			if( this.doorOpen )then
				this.cab:setSequence( "closeDoors" )
				this.cab:play()
				this.doorOpen = false
			else
				this.cab:setSequence( "openDoors" )
				this.cab:play()
				this.doorOpen = true
			end	
		end	
	end

	function this:switchLights(event)
		if ( event.phase == "ended" and this.doorOpen == false) then
			local thisSprite = event.target  --"event.target" references the sprite
			thisSprite:setSequence( "idle" )  --switch to "fastRun" sequence
			thisSprite:play()  --play the new sequence; it won't play automatically!
		end
	end

	return this
end
