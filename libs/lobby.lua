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

local button = require("libs.buttons")
local messageBox = require("libs.messagebox")

-- GLOBAL VIRABLES
-------------------------------------------------------------------------------
local _W = display.contentWidth
local _H = display.contentHeight
local _C = display.contentWidth*0.5
buttonList = {{},{}}
activeButton = {}
activeButton.row = 1
activeButton.col = 1
local startbutton = nil
local repairbutton = nil
local refuelButton = nil

-- LAYERS
-------------------------------------------------------------------------------

local layerBackground = display.newGroup( )
local layerGUI = display.newGroup( )
local layerMessage = display.newGroup( )


-- AUDIO
-------------------------------------------------------------------------------
--local musicAudio = audio.loadSound( "media/sfx/menu.mp3" )
--local clickAudio = audio.loadSound( "media/sfx/click.wav" )

-- FUNCTION LIST
-------------------------------------------------------------------------------

init = nil
local drawLobby = nil
destroy = nil

-- FUNCTIONS
-------------------------------------------------------------------------------

function drawLobby()
	local background = display.newImage( "media/gfx/lobby_background.png" )
	background.anchorX, background.anchorY = 0,0
	background.x, background.y = 0, 0

	-- INFO PANEL
	corporationMessage = "IT IS YOUR FIRST DAY . SHOW US HOW GOOD YOU ARE .\n\nGOOD LUCK ."

	local welcomeText = display.newText( layerGUI, corporationMessage, 420,75, 200,135, "Homenaje", 12 )    
    welcomeText.anchorX, welcomeText.anchorY = 0,0
   	welcomeText:setFillColor ( 0.26,0.53,0.1 )

   	-- MAP

   	local mapText1 = display.newText( layerGUI, 'MAP OF THE CYBER CAB REGION', 50,111, "Homenaje", 12 )    
    mapText1.anchorX, mapText1.anchorY = 0,0
   	mapText1:setFillColor ( 0.26,0.53,0.1 )

   	local mapText2 = display.newText( layerGUI, 'DRIVER REGION', 210,111, "Homenaje", 12 )    
    mapText2.anchorX, mapText2.anchorY = 0,0
   	mapText2:setFillColor ( 0.26,0.53,0.1 )

   	local mapText3 = display.newText( layerGUI, 'START LOCATION', 295,111, "Homenaje", 12 )    
    mapText3.anchorX, mapText3.anchorY = 0,0
   	mapText3:setFillColor ( 0.26,0.53,0.1 )

	-- DRIVER

	local driverText1 = display.newText( layerGUI, 'LICENCE ID: '..'123-04-2114', 125,40, "Homenaje", 12 )    
    driverText1.anchorX, driverText1.anchorY = 0,0
   	driverText1:setFillColor ( 0.26,0.53,0.1 )

   	local driverText2 = display.newText( layerGUI, 'NAME: '..'JOHN', 125,60, "Homenaje", 12 )    
    driverText2.anchorX, driverText2.anchorY = 0,0
   	driverText2:setFillColor ( 0.26,0.53,0.1 )

   	local driverText3 = display.newText( layerGUI, 'SURNAME: '..'SMITH', 125,80, "Homenaje", 12 )    
    driverText3.anchorX, driverText3.anchorY = 0,0
   	driverText3:setFillColor ( 0.26,0.53,0.1 )

	local driverText4 = display.newText( layerGUI, 'AGE: '..'21', 260,40, "Homenaje", 12 )    
    driverText4.anchorX, driverText4.anchorY = 0,0
   	driverText4:setFillColor ( 0.26,0.53,0.1 )

   	local driverText5 = display.newText( layerGUI, 'LOCATION: '..'NEW YORK', 260,60, "Homenaje", 12 )    
    driverText5.anchorX, driverText5.anchorY = 0,0
   	driverText5:setFillColor ( 0.26,0.53,0.1 )

   	local driverText6 = display.newText( layerGUI, 'MARRIED: '..'FALSE', 260,80, "Homenaje", 12 )    
    driverText6.anchorX, driverText6.anchorY = 0,0
   	driverText6:setFillColor ( 0.26,0.53,0.1 )

   	-- GARAGE
   	local workedTimeText = display.newText( layerGUI, 'WORKED HOURS: 00 H', 420,230, "Homenaje", 12 )    
    workedTimeText.anchorX, workedTimeText.anchorY = 0,0
   	workedTimeText:setFillColor ( 0.26,0.53,0.1 )

   	local realTimeText = display.newText( layerGUI, 'TIME: 08:00 AM', 620,230, "Homenaje", 12 )    
    realTimeText.anchorX, realTimeText.anchorY = 1,0
   	realTimeText:setFillColor ( 0.26,0.53,0.1 )

   	local cashText = display.newText( layerGUI, 'CASH: 0.00 BTC', 420,250, "Homenaje", 12 )    
    cashText.anchorX, cashText.anchorY = 0,0
   	cashText:setFillColor ( 0.26,0.53,0.1 )

	local fuelText = display.newText( layerGUI, 'FUEL: 100 %', 420,300, "Homenaje", 12 )    
    fuelText.anchorX, fuelText.anchorY = 0,0
   	fuelText:setFillColor ( 0.63,0.8,0.15 )   	

   	local damageText = display.newText( layerGUI, 'DAMAGE: 0 %', 620,300, "Homenaje", 12 )    
    damageText.anchorX, damageText.anchorY = 1,0
   	damageText:setFillColor ( 0.63,0.8,0.15 )

   	local params = {}
   	params.layer = layerGUI
   

   	params.x, params.y = 530, 180
   	params.label = 'START WORK DAY'
   	params.command = 'startGame'
   	params.table = buttonList[1]
   	startButton = button.create( params )   	

   	params.x, params.y = 420, 320
   	params.label = 'REFUEL : 0 BTC'
   	params.command = 'refuel'
   	params.table = buttonList[2]
   	refuelButton = button.create( params )

   	params.x, params.y = 530, 320
   	params.label = 'REPAIR : 0 BTC'
   	params.command = 'repair'
   	params.table = buttonList[2]
   	repairButton = button.create( params) 


	local msg = "MESSAGE FROM: Krzysztof Jankowski, CEO, Cyber Cab Corp.\n"..
		"TITLE: Welcome to the corporation! Here's a little info to help you start.\n"..
    "We are a cab company for the rich business people. We transport them directly from their offices in the highest skyscrapers. Sometimes they want to move quickly from one floor to another, but most of the time they take a ride to the same floor in a different skyscraper. This saves them time and money, so travel time here is very important.\n"..
    "Of course you can never forget about their safety, there are lots of other flying cars out there.\n"..
    "Avoid damaging the vehicle, and remember that cabs don't run on air so save fuel. "..
    "Repair and refuel will be taken from your paycheck."	
    showMessageBox(msg)

    layerBackground:insert( background )
    layerGUI:insert( welcomeText )
end

function init( group )
	--audio.play(musicAudio)		
	drawLobby()
	group:insert(layerBackground)
	group:insert(layerGUI)
end

function stopButtonsHighlights()
	for i=1,#buttonList do
		for j=1,#buttonList[i] do
			buttonList[i][j]:stopHighlight()
		end
	end
end

function highlightActiveButton()
	stopButtonsHighlights()
	buttonList[activeButton.row][activeButton.col]:highlight()
end

function executeButton()
	local cmd = buttonList[activeButton.row][activeButton.col].command
	if( cmd == 'startGame' )then		
		return 'game'
	end
	if( cmd == 'refuel' )then
		showMessageBox("REFUELING THE CAR..")
	end
	if( cmd == 'repair' )then
		showMessageBox("REPAIRING..")
	end
	return false
end

function showMessageBox(message)
	if ( globals.messageBoxActive == false ) then
		stopButtonsHighlights()
		local messageParams = {}
		messageParams.layer = layerMessage
		messageParams.message = message
		messageBox.newMessage(messageParams)
	end
end

function activateLobby()
	if ( globals.messageBoxActive == false ) then
		highlightActiveButton()
	end
end

function removeMessageBox()
	messageBox.closeMessage()	
	timer.performWithDelay( 500, activateLobby, 1 )
	--activateLobby()
end

function destroy()

end

-- EVENTS
-------------------------------------------------------------------------------

