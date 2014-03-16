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
local physics = require( "physics" )
local Player = require("libs.player")
local NPC = require("libs.npc")
local level = require("libs.levels")
local Counters = require("libs.counters")
local Perspective=require("libs.perspective")
local camera=Perspective.createView()


-- GLOBAL VIRABLES
-----------------------------------------------------------------------------------------
local _W = display.contentWidth
local _H = display.contentHeight
local spawnClientDelay = 12000
player = nil
cbRadio = nil
routeFrom = '-'
routeTo = '-'
fromText = nil
toText = nil
engineXText = nil
engineYText = nil
engineFuel = nil
fuelValueText = nil
unitDamage = nil
damageValueText = nil
cbRadioTextToBrodcast = {}
spawner = nil
cashText = nil
local clients = {}

-- LAYERS
-----------------------------------------------------------------------------------------
local layerBackground = display.newGroup( )
local layerGame = display.newGroup( )
local layerGUI = display.newGroup( )

-- FUNCTIONS
-----------------------------------------------------------------------------------------
local function drawGUI()	

	local background = display.newImage( "media/gfx/game_background.png" )
	local background2 = display.newImage( "media/gfx/game_background.png" )

	background.anchorX, background.anchorY = 0,0
	background.x, background.y = 0, 0
	background2.anchorX, background2.anchorY = 0,0
	background2.x, background2.y = 512, 0

	camera:add(background, 6, false)
	camera:add(background2, 6, false)

	level.init({layer=layerGame, camera=camera})

	local gui = display.newImage( "media/gfx/gui_game.png" )
	gui.anchorX, gui.anchorY = 0,0
	gui.x, gui.y = 0, 0
	layerGUI:insert( gui )

	
	-- TIME

   	local dayText = display.newText( layerGUI, 'DAY', 420,15, "Homenaje", 12 )    
    dayText.anchorX, dayText.anchorY = 0,0
   	dayText:setFillColor ( 0.26,0.53,0.1 )

   	local daysText = display.newText( layerGUI, '1', 450,15, "Homenaje", 24 )    
    daysText.anchorX, daysText.anchorY = 0,0
   	daysText:setFillColor ( 0.64,0.81,0.15 )
	
	local timeLeftText = display.newText( layerGUI, 'TIME LEFT', 490,15, "Homenaje", 12 )    
    timeLeftText.anchorX, timeLeftText.anchorY = 0,0
   	timeLeftText:setFillColor ( 0.26,0.53,0.1 )

	local realTimeText = display.newText( layerGUI, '0m 00s', 550,15, "Homenaje", 24 )    
    realTimeText.anchorX, realTimeText.anchorY = 0,0
   	realTimeText:setFillColor ( 0.64,0.81,0.15 )


   	-- ENGINE

   	local enginePowerText = display.newText( layerGUI, 'ENGINE POWER', 420,65, "Homenaje", 10 )    
    enginePowerText.anchorX, enginePowerText.anchorY = 0,0
   	enginePowerText:setFillColor ( 0,0.34,0.52 )

   	engineXText = display.newText( layerGUI, '0', 435,102, "Homenaje", 14 )    
    engineXText.anchorX, engineXText.anchorY = 0,0
   	engineXText:setFillColor ( 1,1,1 )

	engineYText = display.newText( layerGUI, '0', 485,88, "Homenaje", 14 )    
    engineYText.anchorX, engineYText.anchorY = 0,0
   	engineYText:setFillColor ( 1,1,1 )

   	enginePowerVertical = Counters:newMeter()
   	enginePowerVertical:init({vertical=true, x=420, y=82})
	

   	enginePowerHorizontal = Counters:newMeter()
   	enginePowerHorizontal:init({horizontal=true, x=460, y=95})


   	local fuelText = display.newText( layerGUI, 'FUEL', 510,65, "Homenaje", 10 )    
    fuelText.anchorX, fuelText.anchorY = 0,0
   	fuelText:setFillColor ( 0,0.34,0.52 )

	fuelValueText = display.newText( layerGUI, math.floor(globals.fuel), 615,60, "Homenaje", 14 )    
    fuelValueText.anchorX, fuelValueText.anchorY = 1,0
   	fuelValueText:setFillColor ( 1,1,1 )

   	engineFuel = Counters:newMeter()
   	engineFuel:init({fuel=true, x=510, y=80})

   	local damageText = display.newText( layerGUI, 'DAMAGE', 510,95, "Homenaje", 10 )    
    damageText.anchorX, damageText.anchorY = 0,0
   	damageText:setFillColor ( 0,0.34,0.52 )

   	damageValueText = display.newText( layerGUI, math.floor(globals.damage), 615,90, "Homenaje", 14 )    
    damageValueText.anchorX, damageValueText.anchorY = 1,0
   	damageValueText:setFillColor ( 1,1,1 )

   	unitDamage = Counters:newMeter()
   	unitDamage:init({damage=true, x=510, y=110})

   	-- GPS

   	local routeText = display.newText( layerGUI, 'ROUTE', 490,155, "Homenaje", 12 )    
    routeText.anchorX, routeText.anchorY = 0,0
   	routeText:setFillColor ( 0.26,0.53,0.1 )

   	fromText = display.newText( layerGUI, routeFrom, 495,180, "Homenaje", 14 )    
    fromText.anchorX, fromText.anchorY = 0,0
   	fromText:setFillColor ( 0.64,0.81,0.15 )

   	toText = display.newText( layerGUI, routeTo, 535,170, "Homenaje", 24 )    
    toText.anchorX, toText.anchorY = 0,0
   	toText:setFillColor ( 0.64,0.81,0.15 )

   	-- CASH

	local btcText = display.newText( layerGUI, 'BTC', 580,155, "Homenaje", 12 )    
    btcText.anchorX, btcText.anchorY = 0,0
   	btcText:setFillColor ( 0.26,0.53,0.1 )

	cashText = display.newText( layerGUI, globals.cash, 580,170, "Homenaje", 24 )    
    cashText.anchorX, cashText.anchorY = 0,0
   	cashText:setFillColor ( 0.64,0.81,0.15 )   	

   	-- SYSTEM LOG
   	systemLog = display.newText( layerGUI, 'SYSTEM LOG', 420,225, "Homenaje", 14 )    
   	systemLog.anchorX, systemLog.anchorY = 0,0
   	systemLog:setFillColor ( 0.18,0.28,0.30 )
	cbRadio = display.newText( layerGUI, 'LOADING..', 420,250, 200,125, "Homenaje", 10 )    
    cbRadio.anchorX, cbRadio.anchorY = 0,0
   	cbRadio:setFillColor ( 0.18,0.28,0.30 )
end

function steerCab(params)
	if(player.doorOpen == false)then
		if(params.axis)then
			if(params.number == 1 or params.number == 4)then
				player:smoothEnginePower({x=params.value})
			end
			if(params.number == 2 or params.number == 5)then
				player:smoothEnginePower({y=params.value})
			end
		else
			if(params.engine)then
				if(player.engine.on)then
					player.engine.on = false
					player.engine.power.x, player.engine.power.y = 0,0
				else
					player.engine.on = true
				end
			end
			if(params.up)then
				player:smoothEnginePower({y=-30})
			end
			if(params.down)then
				player:smoothEnginePower({y=30})
			end
			if(params.left)then
				player:smoothEnginePower({x=-30})
			end
			if(params.right)then
				player:smoothEnginePower({x=30})
			end
			if(params.hover)then
				player:smoothEnginePower({x=0,y=0})
			end
		end
	end
end

function openCab()
	player:activateDoors()
end

function lockCab()
	player:stopCab()
	player.engine.on = false	
end

function cbRadioBrodcast()
	local msg = ''
	for i=#cbRadioTextToBrodcast,#cbRadioTextToBrodcast-6, -1 do
		if(cbRadioTextToBrodcast[i])then
			msg = msg .. " > " .. cbRadioTextToBrodcast[i] .. "\n"
		end
	end
	cbRadio.text = msg
end

function refreshGUI()
	fromText.text = routeFrom
	toText.text = routeTo
	cashText.text = globals.cash
end

function clearClientsTable()
	for i=1,#clients do
		if(clients[i] == nil)then
			table.remove( clients, i )
		end
	end
end

function calculateCash(params)
	local distance = math.sqrt((params.a.x-params.b.x)^2+(params.a.y-params.b.y)^2)
	function round(num, idp)
	  local mult = 10^(idp or 0)
	  return math.floor(num * mult + 0.5) / mult
	end
	return round(distance*0.001,2) + 0.2
end

function playerLandedOnPlatform( params )
	if( params.landed )then

		player.landedOn = params.letter
		steerCab( {hover=true} )

		if( params.position.y > player.cab.y and math.abs(params.position.x - player.cab.x) < 100 )then
			if( player.hasClient )then
				if( player.hasClient.destination == params.letter )then
					local cash = calculateCash({a = player.hasClient.client, b = player.hasClient.platform.platform})
					globals.cash = globals.cash + cash
					routeFrom = '-'
					routeTo = '-'
					refreshGUI()
					table.insert(cbRadioTextToBrodcast, "YOU EARNED "..cash.." BTC!")
					cbRadioBrodcast()
					openCab()
					player.hasClient.client:toLayer(4)
					player.hasClient:exitCab(params.flip)
					timer.performWithDelay( 450, openCab, 1 )
					clearClientsTable()
				end
			else
				for i=1,#clients do		
					if(clients[i].client and clients[i].platform.platform.letter == params.letter)then
						lockCab()
						clients[i].client:toLayer(1)
						local distance = math.abs(player.cab.x-clients[i].client.x)
						clients[i]:goToCab({time=distance*20})
						routeFrom = params.letter
						routeTo = clients[i].destination
						table.insert(cbRadioTextToBrodcast,"TRANSPORT CLIENT TO PLATFORM -- ".. clients[i].destination)
						timer.performWithDelay( (distance*20)+100, cbRadioBrodcast, 1 )
						timer.performWithDelay( (distance*20)+100, refreshGUI, 1 )						
					end			
				end
			end
		end

	end
	if(params.exit)then

		player.landedOn = false

	end
end

function collision(params)
	print(globals.damage)
	print(params.damage)
	globals.damage = globals.damage + params.damage
end

function pushBack(params)
	player.engine.power.x, player.engine.power.Sx = 0,player.engine.power.Sx * -0.5
	player.engine.power.y, player.engine.power.Sy = 0,player.engine.power.Sy * -0.5
	--player.cab:applyLinearImpulse( params.x * -1.5, params.y * -1.5, player.cab.x, player.cab.y)
end

function runEngine()
	if(player.engine.on)then
		player:runEngine()				
	end

	local sXpower = math.floor(math.abs(player.engine.power.Sx))
	local sYpower = math.floor(math.abs(player.engine.power.Sy))

	engineXText.text = sXpower
	engineYText.text = sYpower

	local sxPercentage = math.floor( (sXpower / 60) * 10 )
	local syPercentage = math.floor( (sYpower / 60) * 10 )
	local sFuel = math.floor( (globals.fuel / 100) * 10 )
	local sDamage = math.floor( (globals.damage / 100) * 10 )

	enginePowerHorizontal:setValue({frame=tostring(syPercentage)})
	enginePowerVertical:setValue({frame=tostring(sxPercentage)})
	
	engineFuel:setValue({frame=tostring(sFuel)})
	fuelValueText.text = tostring(math.floor(globals.fuel))

	unitDamage:setValue({frame=tostring(sDamage)})
	damageValueText.text = tostring(math.floor(globals.damage))

end

local function initPhysics()
	physics.start()
	physics.setGravity( 0, 40 )
	physics.setScale( 30 )
	physics.setPositionIterations( 16 )
	physics.setVelocityIterations( 6 )

	--physics.setDrawMode( "hybrid" )

end

local function initPlayer()	
	player = Player:new()
	player:init({x=320,y=360})	
	camera:add(player.cab, 2, false)
	camera:setFocus(player.cab)
end

local function spawnClient()
	local emptyPlatforms = {}

	for i=1,#level.platforms do
		if(level.platforms[i].hasClient == false)then
			table.insert( emptyPlatforms, level.platforms[i] )
		end		
	end	

	if(#emptyPlatforms > 1)then
		local rnd = math.random(#emptyPlatforms)
		local platform = emptyPlatforms[rnd];
		table.remove( emptyPlatforms, rnd )

		local rnd = math.random(#emptyPlatforms)

		local newId = #clients+1
		clients[newId] = NPC:newClient()
		clients[newId]:init({platform=platform, destination=emptyPlatforms[rnd].platform.letter, player=player})	
		camera:add(clients[newId].client, 4, false)

		table.insert( cbRadioTextToBrodcast, 'CLIENT ON PLATFORM -- '.. platform.platform.letter ..' -- IS WATING' )
		cbRadioBrodcast()
	end
end


function setCamera()
	camera.x, camera.y=-96, 0
	camera:layer(6).parallaxRatio=0.7
	camera:layer(5).parallaxRatio=0.9
	camera:setBounds(214,846,-196,342)
end


function init( group )
	initPhysics()
	setCamera()
	drawGUI()
	initPlayer()
	spawnClient()
	spawner = timer.performWithDelay( spawnClientDelay, spawnClient, 0 )
	camera:track()
	--[[
	camera.x, camera.y=64, 64
	camera.xScale, camera.yScale = 0.5,0.5
	layerGUI.alpha = 0
	--]]--
   	group:insert(camera)
   	group:insert(layerGUI)
end

function destroy()
end

