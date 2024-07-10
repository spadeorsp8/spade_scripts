--[[
@title Simple Prif Woodcutter
@author Spade

* Change TREE_STR to name of desired tree
* Create a preset with your woodcutting supplies (empty inventory is acceptable), and load it
* Start script within 50 tiles of the tree/woodcutting bank chest in Prif.
--]]

API = require("api")

API.SetDrawTrackedSkills(true)

state = 1

local MAX_IDLE_TIME_MINUTES = 5
local BANK_CHEST = 92692
local TREE_STR = "Ivy"

local function waitForStillness()
    while (API.CheckAnim(100) or API.ReadPlayerMovin2() or API.isProcessing()) and API.Read_LoopyLoop() do
        API.DoRandomEvents()
        API.RandomSleep2(1000, 250, 500)
    end
end

local function validatePosition()
    if #API.GetAllObjArray1({ BANK_CHEST }, 50, { 12 }) <= 0 or #API.GetAllObjArrayInteract_str({ TREE_STR }, 50, { 0, 12 }) <= 0 then
        print(string.format("Please start near %s in Prif!", TREE_STR))
        return false
    end

    return true
end

local function chooseTree()
    local choppableTrees = {}

    for _, tree in ipairs(API.GetAllObjArrayInteract_str({ TREE_STR }, 50, { 0, 12 })) do
        if tree.Bool1 == 0 then
            table.insert(choppableTrees, tree)
        end
    end

    return choppableTrees[math.random(1, #choppableTrees)]
end

local STATES = {
    {
        desc = "Banking",
        pre = function() return API.InvFull_() end,
        callback = function() API.DoAction_Object1(0x33, API.OFF_ACT_GeneralObject_route3, { BANK_CHEST }, 50) end
    },
    {
        desc = string.format("Chopping %s", TREE_STR),
        pre = nil,
        callback = function() API.DoAction_Object_Direct(0x3b, API.OFF_ACT_GeneralObject_route0, chooseTree()) end
    }
}

while API.Read_LoopyLoop() and validatePosition() do
    API.DoRandomEvents()
    API.SetMaxIdleTime(MAX_IDLE_TIME_MINUTES)

    if STATES[state].pre and not STATES[state].pre() then
        goto continue
    end

    print("State: " .. STATES[state].desc)
    STATES[state].callback()
    waitForStillness()

    ::continue::
    state = (state % #STATES) + 1
    API.RandomSleep2(500, 500, 1000)
end
