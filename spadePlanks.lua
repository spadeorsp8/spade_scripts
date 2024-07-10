--[[
@title Fort Plank Maker
@author Spade

* Create bank preset with logs, planks, or refined planks and load it
* Start script near the Fort Forinthry workshop bank
--]]

local API = require('api')

local MAX_IDLE_TIME_MINUTES = 5

API.SetDrawTrackedSkills(true)
API.SetMaxIdleTime(MAX_IDLE_TIME_MINUTES)

local function usingRefinedPlanks()
    local firstItem = API.ReadInvArrays33()[1].textitem
    return string.find(firstItem, "Refined") ~= nil
end

local function needBank()
    if usingRefinedPlanks() then
        return API.Invfreecount_() > 21
    end
    return API.Invfreecount_() >= 18
end

state = 1
local STATES = {
    {
        desc = "Loading preset",
        pre = function() return needBank() end,
        callback = function() API.DoAction_Object1(0x33, API.OFF_ACT_GeneralObject_route3, { 125115 }, 20) end,
        post = function() API.RandomSleep2(2500, 500, 500) return API.InvFull_() end
    },
    {
        desc = "Using mill",
        pre = function() return not usingRefinedPlanks() end,
        callback = function() API.DoAction_Object_string1(0x29, API.OFF_ACT_GeneralObject_route0, { "Sawmill" }, 20, true) end,
        post = nil
    },
    {
        desc = "Using bench",
        pre = function() return usingRefinedPlanks() end,
        callback = function() API.DoAction_Object_string1(0xae, API.OFF_ACT_GeneralObject_route0, { "Woodworking bench" }, 20, true) end,
        post = nil
    },
    {
        desc = "Making planks",
        pre = nil,
        callback = function() API.KeyboardPress32(0x20, 0) end,
        post = nil
    }
}

while API.Read_LoopyLoop() do
    API.DoRandomEvents()

    if not (API.CheckAnim(50) or API.ReadPlayerMovin2() or API.isProcessing()) then
        if STATES[state].pre and not STATES[state].pre() then
            goto continue
        end

        print("State: " .. STATES[state].desc)
        STATES[state].callback()

        if STATES[state].post and not STATES[state].post() then
            break
        end

        ::continue::
        state = (state % #STATES) + 1
    end

    API.RandomSleep2(1000, 250, 500)
end
