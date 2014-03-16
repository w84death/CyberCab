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
local blocks = require("libs.blocks")

-- GLOBAL VIRABLES
-----------------------------------------------------------------------------------------
platforms = {}

-- FUNCTIONS
-----------------------------------------------------------------------------------------
local function drawSandboxMap(camera)
	local bounds = blocks:newBounds()
	local sidewalk = blocks:newSidewalk()
	local sidewalk2 = blocks:newSidewalk()	
	local p1 = blocks:newPlatform()
	local p2 = blocks:newPlatform()
	local p3 = blocks:newPlatform()
	local p4 = blocks:newPlatform()
	local p5 = blocks:newPlatform()
	local s1 = blocks:newSign()
	local s2 = blocks:newSign()
	local s3 = blocks:newSign()
	local s4 = blocks:newSign()
	local s5 = blocks:newSign()

	local skyscraper1 = blocks:newSkyscraper()
	local skyscraper2 = blocks:newSkyscraper()
	local colaBanner = blocks:newColaBanner()
	local skyscraper3 = blocks:newSkyscraper()

	local sidewalkBack = blocks:newSidewalkBack()
	local chineseStall = blocks:newChineseStall()
	local shop1 = blocks:newShop()
	local shop2 = blocks:newShop()
	local shop3 = blocks:newShop()
	local shop4 = blocks:newShop()
	
	bounds:init({x=1024,y=512})	
	sidewalk:init({x=0, y=512})
	sidewalk2:init({x=510, y=512})
	
	skyscraper1:init({x=16,y=464,type="old",body=true})
	skyscraper2:init({x=500,y=464,type="blue",body=true})	
	skyscraper3:init({x=900,y=464,type="old",body=true})
	colaBanner:init({x=506,y=92})
	
	p1:init({x=131,y=100, letter="A"})
	s1:init({x=231,y=70, letter="A"})

	p2:init({x=131,y=280, letter="B"})
	s2:init({x=231,y=250, letter="B"})

	p3:init({x=373,y=386,flip=true, letter="C"})
	s3:init({x=378,y=356, letter="C"})

	p4:init({x=672,y=330, letter="D"})
	s4:init({x=772,y=300, letter="D"})

	p5:init({x=774,y=36,flip=true, letter="E"})
	s5:init({x=779,y=6, letter="E"})

	sidewalkBack:init({x=0, y=440})	
	shop1:init({x=140,y=440,id="1"})
	shop2:init({x=272,y=440,id="2"})
	shop3:init({x=600,y=440,id="3"})
	shop4:init({x=732,y=440,id="4"})
	chineseStall:init({x=410,y=434})
	
	camera:add(bounds.left, 4, false)
	camera:add(bounds.right, 4, false)
	camera:add(bounds.top, 4, false)
	camera:add(sidewalk.sidewalk, 4, false)
	camera:add(sidewalk2.sidewalk, 4, false)

	camera:add(skyscraper1.skyscraper, 3, false)
	camera:add(skyscraper2.skyscraper, 3, false)	
	camera:add(skyscraper3.skyscraper, 3, false)	
	camera:add(colaBanner.cola, 3, false)

	camera:add(p1.platform, 4, false)
	camera:add(p2.platform, 4, false)
	camera:add(p3.platform, 4, false)
	camera:add(p4.platform, 4, false)
	camera:add(p5.platform, 4, false)
	camera:add(s1.sign, 4, false)
	camera:add(s2.sign, 4, false)
	camera:add(s3.sign, 4, false)
	camera:add(s4.sign, 4, false)
	camera:add(s5.sign, 4, false)

	camera:add(sidewalkBack.sidewalk, 5, false)
	camera:add(chineseStall.stall, 5, false)
	camera:add(shop1.shop, 5, false)
	camera:add(shop2.shop, 5, false)
	camera:add(shop3.shop, 5, false)
	camera:add(shop4.shop, 5, false)


	table.insert(platforms, p1)
	table.insert(platforms, p2)
	table.insert(platforms, p3)
	table.insert(platforms, p4)
	table.insert(platforms, p5)
end

function init(params)
	drawSandboxMap(params.camera)
end
