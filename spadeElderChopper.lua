--[[
@title Elder Tree Chopper
@author Spade

* Add your desired woodcutting gear to bank preset 1 (wood box recommended)
* If you have a wood box, add it to slot 1 of your action bar
* Start script
--]]

local API = require("api")
local UTILS = require("utils")
local LODESTONES = require("lodestones")

API.SetDrawTrackedSkills(true)

i = 0
local BANK_INTERVAL = 3 -- Number of full loops between banking
local MAX_IDLE_TIME_MINUTES = 5

local function waitForStillness()
    API.RandomSleep2(2000, 250, 500)
    while (API.CheckAnim(100) or API.ReadPlayerMovin2() or API.isProcessing()) and API.Read_LoopyLoop() do
        API.DoRandomEvents()
        API.SetMaxIdleTime(MAX_IDLE_TIME_MINUTES)
        API.RandomSleep2(1000, 250, 500)
    end
end

local function goToLodestone(lode)
    print('Teleporting to ', UTILS.GetLabelFromArgument(lode, LODESTONES.LODESTONE))

    LODESTONES.openLodestonesInterface()
    API.RandomSleep2(500, 250, 500)
    API.DoAction_Interface(0xffffffff, 0xffffffff, 1, 1092, lode.id, -1, API.OFF_ACT_GeneralInterface_route)
    while API.Math_DistanceW(lode.loc, API.PlayerCoord()) > 100 and API.Read_LoopyLoop() do
        API.RandomSleep2(1000, 250, 500)
    end

    waitForStillness()
end

local function goToTree(lodestone, nearbyTile)
    goToLodestone(lodestone)
    if not API.Read_LoopyLoop() then return end

    API.DoAction_Tile(nearbyTile)
    waitForStillness()
end

local function chopTree()
    API.DoAction_Object_string1(0x3b, API.OFF_ACT_GeneralObject_route0, { "Elder tree" }, 50, true)
    waitForStillness()

    API.KeyboardPress32(0x31, 0) -- Press '1' to fill wood box on action bar slot 1
    API.RandomSleep2(1000, 250, 500)
end

local function bank()
    local bankCounters = API.GetAllObjArrayInteract_str({ "Counter" }, 50, { 12 })
    API.DoAction_Object_Direct(0x5, API.OFF_ACT_GeneralObject_route1, bankCounters[math.random(1, #bankCounters)])
    waitForStillness()

    API.KeyboardPress32(0x33, 0) -- Press '3' to empty inventory into bank
    API.RandomSleep2(500, 250, 500)
    API.KeyboardPress32(0x31, 0) -- Press '1' to load preset 1
    API.RandomSleep2(500, 250, 500)
end

local TRANSITIONS = {
    function() goToTree(LODESTONES.LODESTONE.YANILLE, WPOINT.new(2561 + math.random(1, 5), 3068 + math.random(1, 5), 0)) end,
    function() goToTree(LODESTONES.LODESTONE.VARROCK, WPOINT.new(3250 + math.random(1, 5), 3366 + math.random(1, 5), 0)) end,
    function() goToTree(LODESTONES.LODESTONE.EDGEVILLE, WPOINT.new(3090 + math.random(1, 5), 3456 + math.random(1, 5), 0)) end
}

while API.Read_LoopyLoop() do
    for _, move in ipairs(TRANSITIONS) do
        if not API.Read_LoopyLoop() then goto exit end
        move()
        chopTree()
    end

    -- TODO: Make this more intelligent to bank only when necessary
    i = i + 1
    if i >= BANK_INTERVAL then
        bank()
        i = 0
    end

    API.RandomSleep2(2000, 500, 1000)
end

::exit::
