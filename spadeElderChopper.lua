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

local BANK_THRESH = 9
local MAX_IDLE_TIME_MINUTES = 10

i = 1
locationIdx = 0
local LOCATIONS = {
    { LODESTONES.LODESTONE.YANILLE, 2561, 3068 },
    { LODESTONES.LODESTONE.VARROCK, 3250, 3366 },
    { LODESTONES.LODESTONE.EDGEVILLE, 3090, 3456 }
}

API.SetDrawTrackedSkills(true)
API.SetMaxIdleTime(MAX_IDLE_TIME_MINUTES)

local function goToLodestone(lode)
    print('Teleporting to ', UTILS.GetLabelFromArgument(lode, LODESTONES.LODESTONE))

    LODESTONES.openLodestonesInterface()
    API.RandomSleep2(1000, 500, 1000)
    API.DoAction_Interface(0xffffffff, 0xffffffff, 1, 1092, lode.id, -1, API.OFF_ACT_GeneralInterface_route)
    while API.Math_DistanceW(lode.loc, API.PlayerCoord()) > 100 and API.Read_LoopyLoop() do
        API.RandomSleep2(1000, 250, 500)
    end
end

local function openBank()
    if LOCATIONS[locationIdx][1] == LODESTONES.LODESTONE.EDGEVILLE and i >= BANK_THRESH then
        local bankCounters = API.GetAllObjArrayInteract_str({ "Counter" }, 50, { 12 })
        API.DoAction_Object_Direct(0x5, API.OFF_ACT_GeneralObject_route1, bankCounters[math.random(1, #bankCounters)])
        i = 0
    end
end

local function loadPreset()
    if i == 0 then
        API.KeyboardPress32(0x33, 0)
        API.RandomSleep2(500, 250, 500)
        API.KeyboardPress32(0x31, 0)
    end
end

action = 1
local ACTIONS = {
    function() locationIdx = (locationIdx % #LOCATIONS) + 1 end,
    function() goToLodestone(LOCATIONS[locationIdx][1]) end,
    function() API.DoAction_Tile(WPOINT.new(LOCATIONS[locationIdx][2] + math.random(1, 5), LOCATIONS[locationIdx][3] + math.random(1, 5), 0)) end,
    function() API.DoAction_Object_string1(0x3b, API.OFF_ACT_GeneralObject_route0, { "Elder tree" }, 50, true) end,
    function() API.KeyboardPress32(0x31, 0) end,
    function() openBank() end,
    function() loadPreset() i = i + 1 end
}

while API.Read_LoopyLoop() do
    API.DoRandomEvents()

    if not (API.CheckAnim(100) or API.ReadPlayerMovin2() or API.isProcessing()) then
        ACTIONS[action]()
        action = (action % #ACTIONS) + 1
    end

    API.RandomSleep2(500, 250, 500)
end
