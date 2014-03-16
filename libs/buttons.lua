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
local Button = {}
local image = nil
local label = nil
Button.__index = Button

function Button.create( params )
	local self = setmetatable( {}, Button )
	self.command = params.command
	image = display.newImage( "media/gfx/button.png" )	
	image.anchorX, image.anchorY = 0,0
	image.x, image.y = params.x, params.y
	image.alpha = 0.5
	self.image = image	
	params.layer:insert( self.image )

	label = display.newText( params.layer, params.label, params.x+45,params.y, "Homenaje", 12 )    
    label.anchorX, label.anchorY = 0.5,0
   	label:setFillColor ( 0.63,0.8,0.15 )
   	if(params.table)then
   		table.insert(params.table, self)
   	end
   	return self
end

function Button.highlight( self )
	local function blink()
	    if( self.image.alpha < 1 ) then
	        transition.to( self.image, {time=490, alpha=1} )
	    else 
	        transition.to( self.image, {time=490, alpha=0.4} )
	    end
	end
	self._blink = timer.performWithDelay( 500, blink, 0 )
end

function Button.stopHighlight( self )		
	if ( self._blink ) then		
		timer.cancel(self._blink)	
	end
	self.image.alpha = 0.5
end

function Button.remove( self, layer )
	self.stopHighlight( self )
	image:removeSelf()
	label:removeSelf()
	image = nil
	label = nil
end

return Button