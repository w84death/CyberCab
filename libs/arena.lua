module(..., package.seeall)
-----------------------------------------------------------------------------------------
--
-- PROGRAMS WARS by Krzysztof Jankowski
--
-- (c)2012 Synergy-IT
--
-----------------------------------------------------------------------------------------

-- EXTERNAL LIBS
-----------------------------------------------------------------------------------------
local widget = require( "widget" )
local programs = require( "libs.programs" )
local conf = require( "libs.conf" )

-- GLOBAL VIRABLES
-----------------------------------------------------------------------------------------
local _W = display.contentWidth
local _H = display.contentHeight
local memory = {}
local memID = 0
local memIcon = {}
local memTempIcon = {}
local pID = 1
local program = {}
local selectedProgram = -1
speed = 200


-- LAYERS
-----------------------------------------------------------------------------------------

local layerBackground = display.newGroup( )
local layerPrograms = display.newGroup( )
local layerGUI = display.newGroup( )

-- AUDIO
-----------------------------------------------------------------------------------------
local clickAudio = audio.loadSound( "assets/sfx/click.wav" )


-- FUNCTION LIST
-----------------------------------------------------------------------------------------
logMsg = nil
local changeSelectedProgram = nil
local loadProgramMemory = nil
local newProgram = nil
local reprogram = nil
local onButtonEvent = nil
local newGUI = nil
newArena = nil
local moveSelection = nil
executePrograms = nil
local clearLocalMemory = nil


-- FUNCTIONS
-----------------------------------------------------------------------------------------
function logMsg( msg )
    
    logText.text = msg    
    logText:setReferencePoint( display.CenterLeftReferencePoint )
    logText.x, logText.y = 12, _H - 68
    
end


function changeSelectedProgram(id)
    
    local memTemp = {}
    selectedProgram = id
    selectedID.text = id  
    moveSelection()

    for i=0,program[selectedProgram].memoryBanks-1 do
        memTemp[i] = program[selectedProgram].memory[i]
    end                       
    loadProgramMemory({
        memoryBanks = program[selectedProgram].memoryBanks,
        memory = memTemp,
        layer = layerGUI })
        
end

function loadProgramMemory()       
        
    for i=0, 7 do        
        if( memIcon[i] ~= nil )then
            memIcon[i]:removeSelf( )
            memIcon[i] = nil
        end
    end    
    
    if( selectedProgram > -1 )then
        for i=0, program[selectedProgram].memoryBanks-1 do           
            url = "assets/gfx/GUI/"..program[selectedProgram].memory[i].."_off.png"
            memIcon[i] = display.newImageRect( layerGUI, url, 40, 40 )           
            memIcon[i].x, memIcon[i].y = 20 + 40*i, _H-20
        end
    end
    
end

function addTempIcon( params )    
    url = "assets/gfx/GUI/"..params.command.."_on.png"
    memTempIcon[params.id] = display.newImageRect( layerGUI, url, 40, 40 )           
    memTempIcon[params.id].x, memTempIcon[params.id].y = 20 + 40*params.id, _H-60
end

function clearTempIcons()
    local function removeMe(self)
        self:removeSelf( )
        self = nil
    end
    
    for i=0, 7 do        
        if( memTempIcon[i] ~= nil )then
            transition.to( memTempIcon[i], { time=200, y=memTempIcon[i].y+40, onComplete=removeMe} )
        end
    end
end

 

function newBullet( params )
    program[pID] = programs.newProgram({ 
                id = pID,
                layer = layerPrograms,
                skin = "bullet",
                col = params.col,
                row = params.row,
                memoryBanks = 1,
                orientation = params.orientation,
                defaultProgram = {"go"} })
    pID = pID + 1
end

function newProgram( params )
    
    program[pID] = programs.newProgram({ 
                id = pID,
                layer = layerPrograms,
                skin = params.skin,
                col = 3,
                row = 10,
                memoryBanks = params.memoryBanks,
                orientation = "right" })
                
    -- TOUCH EVENT FOR SELECTING
    local function selectProgram(self)            
        changeSelectedProgram(self.id)            
    end
    program[pID].touch = selectProgram
    program[pID]:addEventListener( "touch", program[pID] )
    
    selectedProgram = pID
    loadProgramMemory()
    
    
    -- NEXT PROGRAM ID
    pID = pID + 1
    
end


function clearLocalMemory()

    -- CLEAR LOCAL MEMORY
    for i=0, 7 do                
        memory[i] = "stop"       
    end
    
    -- RESET COUNTER
    memID = 0

end

function reprogram(memory)
    
    -- INSERT MEMORY TO PROGRAM
    for i=0, program[selectedProgram].memoryBanks-1 do
        program[selectedProgram].memory[i] = memory[i]
    end
    program[selectedProgram].currentMemory = 0

    -- REFRESH GUI AND CLEAR
    loadProgramMemory()
    clearLocalMemory()
    clearTempIcons()

    -- LOG
    logMsg("Reprogram program ["..selectedProgram.."]")

end  

function onButtonEvent( event )
    
    local btn = event.target
    if( event.phase == "press" )then

        if( btn.id == "run" and selectedProgram > -1)then

            --INSERT MEMORY TO PROGRAM            
            reprogram(memory)                        

        elseif( btn.id == "add4" )then                                
            -- MAKE SAMPLE PROGRAM WITH 4 MEM
            newProgram({               
                skin = "blue",                
                memoryBanks = 4 })      
            
        elseif( btn.id == "add8" )then 

            -- MAKE SAMPLE PROGRAM WITH 8 MEM
            newProgram({               
                skin = "green",                
                memoryBanks = 8 })      

        elseif( selectedProgram > -1 )then

            -- CHECK IF MEMORY FULL
            if( memID > program[selectedProgram].memoryBanks-1 )then
                -- EXIT
                return true
            end

            memory[memID] = btn.id  
            addTempIcon({ 
                id = memID,
                command = btn.id })

            logMsg("Added ["..btn.id.."] to memory ["..memID.."] for program ["..selectedProgram.."]")

            -- NEXT MEMORY BANK
            memID = memID + 1                                
        end
        audio.play(clickAudio)
    end

end
    
function newGUI()
       
    
    -- LOG AREA
    logText = display.newText( layerGUI, "..", 0,0, "Helvetica", 12 )
    logText:setReferencePoint( display.CenterLeftReferencePoint )
    logText.x, logText.y = 12, _H - 68
    logText:setTextColor ( 185 )
    
     -- SELECT ID  
    selectedID = display.newText( layerGUI, "none", 0,0, "Helvetica", 12 )
    selectedID:setReferencePoint( display.CenterReferencePoint )
    selectedID.x, selectedID.y = _W-20, 258
    selectedID:setTextColor ( 185 )
    
    -- MAKE BUTTONS
    local buttonGo = widget.newButton{
        id = "go",
        default = "assets/gfx/GUI/go_off.png",
        over = "assets/gfx/GUI/go_on.png",
        width = 40, height = 40,
        onEvent = onButtonEvent}
        
    local buttonWait = widget.newButton{
        id = "wait",
        default = "assets/gfx/GUI/wait_off.png",
        over = "assets/gfx/GUI/wait_on.png",
        width = 40, height = 40,
        onEvent = onButtonEvent}
    
    local buttonStop = widget.newButton{
        id = "stop",
        default = "assets/gfx/GUI/stop_off.png",
        over = "assets/gfx/GUI/stop_on.png",
        width = 40, height = 40,
        onEvent = onButtonEvent}
    
    local buttonRotateLeft = widget.newButton{
        id = "rotateLeft",
        default = "assets/gfx/GUI/rotateLeft_off.png",
        over = "assets/gfx/GUI/rotateLeft_on.png",
        width = 40, height = 40,
        onEvent = onButtonEvent}
    
    local buttonRotateRight = widget.newButton{
        id = "rotateRight",
        default = "assets/gfx/GUI/rotateRight_off.png",
        over = "assets/gfx/GUI/rotateRight_on.png",
        width = 40, height = 40,
        onEvent = onButtonEvent}
    
    local buttonFire = widget.newButton{
        id = "fire",
        default = "assets/gfx/GUI/fire_off.png",
        over = "assets/gfx/GUI/fire_on.png",
        width = 40, height = 40,
        onEvent = onButtonEvent}
    
    local buttonRun = widget.newButton{
        id = "run",
        default = "assets/gfx/GUI/ok_off.png",
        over = "assets/gfx/GUI/ok_on.png",
        width = 40, height = 40,
        onEvent = onButtonEvent}
    
    local buttonAdd4 = widget.newButton{
        id = "add4",
        default = "assets/gfx/GUI/add_off.png",
        over = "assets/gfx/GUI/add_on.png",
        width = 40, height = 40,
        onEvent = onButtonEvent}
    
    local buttonAdd8 = widget.newButton{ 
        id = "add8",
        default = "assets/gfx/GUI/add_off.png",
        over = "assets/gfx/GUI/add_on.png",
        width = 40, height = 40,
        onEvent = onButtonEvent}
    
    
    layerGUI:insert( buttonGo )
    layerGUI:insert( buttonWait )
    layerGUI:insert( buttonStop )
    layerGUI:insert( buttonRotateLeft )
    layerGUI:insert( buttonRotateRight )
    layerGUI:insert( buttonFire )
    layerGUI:insert( buttonRun )
    layerGUI:insert( buttonAdd4 )
    layerGUI:insert( buttonAdd8 )
    
    buttonGo.x,             buttonGo.y =            _W-20,20
    buttonRotateLeft.x,     buttonRotateLeft.y =    _W-20,60
    buttonRotateRight.x,    buttonRotateRight.y =   _W-20,100    
    buttonWait.x,           buttonWait.y =          _W-20,140
    buttonStop.x,           buttonStop.y =          _W-20,180    
    buttonFire.x,           buttonFire.y =          _W-20,220
    buttonRun.x,            buttonRun.y =           _W-20,300
    
    buttonAdd4.x,            buttonAdd4.y =           20,20
    buttonAdd8.x,            buttonAdd8.y =           20,60
    
    local buttonAdd4ext = display.newText( layerGUI, "4", buttonAdd4.x+8,buttonAdd4.y, "Helvetica", 12 )
    local buttonAdd8ext = display.newText( layerGUI, "8", buttonAdd8.x+8,buttonAdd8.y, "Helvetica", 12 )
    buttonAdd4ext:setTextColor ( 185 )
    buttonAdd8ext:setTextColor ( 185 )
                
end

function newArena( params )
    
    -- GROUPS INTO DIRECTOR
    params.layer:insert( layerBackground )
    params.layer:insert( layerPrograms )
    params.layer:insert( layerGUI )

    -- BACKGROUND
    local background = display.newRect( 0,0,_W,_H )
    background:setFillColor( 255,255,255, 255 )
    layerBackground:insert( background )
    
    -- SELECTION BOX
    selectionBox = display.newRect( layerBackground, -50, -50, 16, 16 )
    selectionBox:setFillColor( 185 )
    
    -- INITIATE GUI
    newGUI()
    
    -- CLEAR LOCAL MEMORY
    clearLocalMemory()
    programs.generateMap({ 
        name="Test Field",
        layer = layerBackground,
        cols = 31,
        rows = 19,
        blocksPercent = 5})
    
end

function moveSelection() 
    
    selectionBox.x, selectionBox.y = program[selectedProgram].x, program[selectedProgram].y
    
end
    
function executePrograms()
    
    -- RUN EACH ACTIVE PROGRAM
    for i=1,pID do
        if( program[i] ~= nil ) then
            if ( program[i].alive ) then
                if( programs.runProgram( program[i] ) == "bullet" ) then
                    newBullet({
                        col = program[i].col,
                        row = program[i].row,
                        memoryBanks = 1,
                        orientation = program[i].orientation})
                        print "bullet"            
                end
            else
                program[i]:removeSelf( )
                program[i] = nil 
            end
    
        end            
    end

end

function movePrograms(tDelta)
    for i=1,pID do
        if( program[i] ~= nil ) then
            
            if( program[i].x > program[i].col*conf.block+conf.offsetX )then
                program[i].x = program[i].x - tDelta*0.04
                moveSelection()
            end
            
            if( program[i].x < program[i].col*conf.block+conf.offsetX )then
                program[i].x = program[i].x + tDelta*0.04
                moveSelection()
            end
            
            if( program[i].y > program[i].row*conf.block+conf.offsetY )then
                program[i].y = program[i].y - tDelta*.04
                moveSelection()                
            end
            
            if( program[i].y < program[i].row*conf.block+conf.offsetY )then
                program[i].y = program[i].y + tDelta*0.04
                moveSelection()
            end
        end            
    end
end

