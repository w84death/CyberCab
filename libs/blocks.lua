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

function newBounds()
	local this = {}	
	this.left = nil
	this.top = nil
	this.right = nil

	function this:init(params)
		
		this.left = display.newImage( "media/gfx/bounds.png" )					
		this.left.anchorX, this.left.anchorY = 1,1
		this.left.x, this.left.y = 0,params.y

		this.right = display.newImage( "media/gfx/bounds.png" )					
		this.right.anchorX, this.right.anchorY = 0,1
		this.right.x, this.right.y = params.x,params.y

		this.top = display.newImage( "media/gfx/bound_top.png" )					
		this.top.anchorX, this.top.anchorY = 0,1
		this.top.x, this.top.y = 0,-384

		physics.addBody( this.left, "static", { density=1, friction=0, bounce=0 } )
		physics.addBody( this.right, "static", { density=1, friction=0, bounce=0 } )
		physics.addBody( this.top, "static", { density=1, friction=0, bounce=0 } )
	end	

	return this
end

function newPlatform()
	local this = {}	
	this.platform = 	nil
	this.hasClient =	false
	this.flip =			false

	function this:init(params)
		local sheetData = { 
		width=127, height=15, 
		numFrames=4, 
		sheetContentWidth=127, 
		sheetContentHeight=60 }
 		

		local sheet = graphics.newImageSheet( "media/gfx/platform.png", sheetData )		
		local animations = {
		    { name = "idle", start=1, count=4, time=500 }
		}
		
		this.platform = display.newSprite( sheet, animations )		
		this.platform.anchorX, this.platform.anchorY = 0,0
		this.platform.x, this.platform.y = params.x, params.y		 
		this.platform:setSequence( "idle" )
		this.platform:play()

		this.platform.name = "platform"
		this.platform.letter = params.letter		
		this.platform.flip = this.flip
		
		local shape = { -63,-4, 63,-4, 63,0, -63,0 }

		if(params.flip)then
			this.flip = true
			this.platform.flip = true
			this.platform.anchorX, this.platform.anchorY = 1,0
			this.platform.xScale = -1
			shape = { 63,-4, 127+63,-4, 127+63,0, 63,0 }
		end
		
		physics.addBody( this.platform, "static", { shape=shape, density=1, friction=0, bounce=0 } )
	end	

	return this
end

function newSidewalk()
	local this = {}	
	this.sidewalk = nil

	function this:init(params)
		local sheetData = { 
		width=512, height=48, 
		numFrames=3, 
		sheetContentWidth=512, 
		sheetContentHeight=144 }
 		

		local sheet = graphics.newImageSheet( "media/gfx/sidewalk.png", sheetData )		
		local animations = {
		    { name = "idle", start=1, count=3, time=500 }
		}
		
		this.sidewalk = display.newSprite( sheet, animations )		
		this.sidewalk.anchorX, this.sidewalk.anchorY = 0,1
		this.sidewalk.x, this.sidewalk.y = params.x, params.y		 
		this.sidewalk:setSequence( "idle" )
		this.sidewalk:play()
		
		local shape = { -256,-4, 256,-4, 256,24, -256,24 }
		physics.addBody( this.sidewalk, "static", { shape=shape, density=1, friction=0, bounce=0 } )
	end	

	return this
end

function newSidewalkBack()
	local this = {}	
	this.sidewalk = nil

	function this:init(params)
		this.sidewalk = display.newImage( "media/gfx/sidewalk_back.png" )					
		this.sidewalk.anchorX, this.sidewalk.anchorY = 0,1
		this.sidewalk.x, this.sidewalk.y = 0,params.y
	end	

	return this
end

function newSign()
	local this = {}	
	this.letter =	'A'
	this.sign = 	nil

	function this:init(params)
		local sheetData = { 
		width=24, height=24, 
		numFrames=12, 
		sheetContentWidth=48, 
		sheetContentHeight=144 }
 		
 		this.letter = params.letter

		local sheet = graphics.newImageSheet( "media/gfx/signs.png", sheetData )		
		local animations = {
		    { name = "A", frames={1,2,2,1,2}, time=500 },
		    { name = "B", frames={3,4,4,3,4}, time=500 },
		    { name = "C", frames={5,6,6,5,6}, time=500 },
		    { name = "D", frames={7,8,8,7,8}, time=500 },
		    { name = "E", frames={9,10,10,9,10}, time=500 },
		    { name = "F", frames={11,12,12,11,12}, time=500 },
		}
		
		this.sign = display.newSprite( sheet, animations )		
		this.sign.anchorX, this.sign.anchorY = 0,0
		this.sign.x, this.sign.y = params.x, params.y		 
		this.sign:setSequence( this.letter )
		this.sign:play()		
	end	

	return this
end

function newSkyscraper()
	local this = {}	
	this.skyscraper = 	nil

	function this:init(params)
		this.skyscraper = display.newImage( "media/gfx/skyscraper_"..params.type..".png" )					
		this.skyscraper.anchorX, this.skyscraper.anchorY = 0,1
		this.skyscraper.x, this.skyscraper.y = params.x, params.y
		if( params.body )then
			local shape = { -56,-232, 56,-232, 58,208, -58,208 }
			if( params.type == "blue" )then
				shape = { -86,-224, 85,-224, 85,220, -86,220 }
			end			
			physics.addBody( this.skyscraper, "static", {shape=shape, density=1, friction=0, bounce=0 } )
		end
	end		

	return this
end

function newColaBanner()
	local this = {}	
	this.cola = 	nil

	function this:init(params)
		local sheetData = { 
		width=160, height=116, 
		numFrames=8, 
		sheetContentWidth=320, 
		sheetContentHeight=464 }
 		 		
		local sheet = graphics.newImageSheet( "media/gfx/cola_banner.png", sheetData )		
		local animations = {
		    { name = "idle", frames={1,1,2,3,4,5,6,7,7,7,7,7,7,7,7,7,7,7,7,8}, time=2000 }
		}
		
		this.cola = display.newSprite( sheet, animations )		
		this.cola.anchorX, this.cola.anchorY = 0,0
		this.cola.x, this.cola.y = params.x, params.y		 
		this.cola:setSequence( "idle" )
		this.cola:play()		
	end	

	return this
end

function newChineseStall()
	local this = {}	
	this.stall = 	nil

	function this:init(params)
		local sheetData = { 
		width=62, height=59, 
		numFrames=4, 
		sheetContentWidth=124, 
		sheetContentHeight=118 }
 		 		
		local sheet = graphics.newImageSheet( "media/gfx/chinese_stall.png", sheetData )		
		local animations = {
		    { name = "idle", frames={1,2,3,4}, time=800 }
		}
		
		this.stall = display.newSprite( sheet, animations )		
		this.stall.anchorX, this.stall.anchorY = 0,1
		this.stall.x, this.stall.y = params.x, params.y		 
		this.stall:setSequence( "idle" )
		this.stall:play()		
	end	

	return this
end

function newShop()
	local this = {}	
	this.shop = 	nil

	function this:init(params)
		local sheetData = { 
		width=132, height=58, 
		numFrames=4, 
		sheetContentWidth=132, 
		sheetContentHeight=232 }
 		 		
		local sheet = graphics.newImageSheet( "media/gfx/shop"..params.id..".png", sheetData )		
		local animations = {
		    { name = "idle", frames={1,2,3,4}, time=800 }
		}
		
		this.shop = display.newSprite( sheet, animations )		
		this.shop.anchorX, this.shop.anchorY = 0,1
		this.shop.x, this.shop.y = params.x, params.y		 
		this.shop:setSequence( "idle" )
		this.shop:play()		
	end	

	return this
end
