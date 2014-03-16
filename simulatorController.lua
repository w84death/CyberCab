-- simulatorController for Corona SDK
-- Copyright (c) 2013 Jason Schroeder

--[[ Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE. ]]--

-- create our "simulator controller" display group:
local simulatorController = display.newGroup()
	simulatorController.x = 160
	simulatorController.y = display.contentHeight-50
	simulatorController.isVisible = false
	
local displayBG = display.newRoundedRect(0,0,280,50,12)
	displayBG:setFillColor(255,255,255,150)
	displayBG:setStrokeColor(255,255,255,255)
	displayBG.strokeWidth = 5
	displayBG.x, displayBG.y = 0, 0
	simulatorController:insert(displayBG)

local displayText = display.newText("", 0, 0, native.systemFont, 24)
	displayText.x, displayText.y = 0, 0
	displayText:setFillColor(0,0,0)
	simulatorController:insert(displayText)

-- align our mapped keystrokes to the corresponding button keyName (these must match up with the button map in Joystick Mapper):
local buttonMap = {
	["1"] = "up", -- D-Pad up
	["2"] = "down", -- D-Pad down
	["3"] = "left", -- D-Pad left
	["4"] = "right", -- D-Pad right
	["a"] = "buttonA", -- Ouya: O, PS3: X
	["b"] = "buttonB", -- Ouya: A, PS3: circle
	["x"] = "buttonX", -- Ouya: U, PS3: square
	["y"] = "buttonY", -- Ouya: Y, PS3: triangle
	["0"] = "buttonMode", -- console logo button (power on/off)
	["6"] = "leftShoulderButton1", -- L1
	["7"] = "leftShoulderButton2", -- L2
	["8"] = "rightShoulderButton1", -- R1
	["9"] = "rightShoulderButton2", -- R2
	["l"] = "leftJoyStickButton", -- L3 (left analog click)
	["r"] = "rightJoyStickButton", -- R3 (right analog click)
	["["] = "buttonSelect", -- Ouya: n/a, PS3: select
	["]"] = "buttonStart", -- Ouya: n/a, PS3: start
}

-- listen for mapped keystrokes and repeat them as if they were button presses:
local function controllerListener(event)
	-- check to make sure key event corresponds to a mapped button:
	if buttonMap[event.keyName]~=nil then
		-- update event to HID-compatible keyName
		event.keyName = buttonMap[event.keyName]
		
		-- update on-screen display:
		if event.phase == "down" then
			displayText.text = event.keyName
		else
			displayText.text = ""
		end
		displayText.x, displayText.y = 0, 0
	end
end

-- turn on the simulator controller:
function simulatorController:enable()
	Runtime:addEventListener("key", controllerListener)
end

-- turn off the simulator controller:
function simulatorController:disable()
	Runtime:removeEventListener("key", controllerListener)
end

-- show the simulator controller:
function simulatorController:show()
	simulatorController.isVisible = true
end

-- hide the simulator controller:
function simulatorController:hide()
	simulatorController.isVisible = false
end

-- start the simulator controller and return the simulatorController display group:
simulatorController:enable()
return simulatorController