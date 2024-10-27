--[[
@title Simple Summoner
@author Spade

* Create a preset with your summoning supplies, and load it.
* Start script within 50 tiles of the Amlodd summoning obelisk in Prif, or the bank chest by the Ithell harps.
--]]

API = require("api")

API.SetDrawTrackedSkills(true)

state = 1

local MAX_IDLE_TIME_MINUTES = 5
local BANK_CHEST = 92692
local OBELISK = 94230
local obeliskInterface = { InterfaceComp5.new(1371, 7, -1, 0) }

local STATES = {
    {
        desc = "Banking",
        callback = function() API.DoAction_Object1(0x33, API.OFF_ACT_GeneralObject_route3, { BANK_CHEST }, 50) end,
        post = function() return API.InvFull_() end
    },
    {
        desc = "Opening Obelisk",
        callback = function() API.DoAction_Object1(0x29, API.OFF_ACT_GeneralObject_route0, { OBELISK }, 50) end,
        post = nil
    },
    {
        desc = "Infusing Pouches",
        callback = function() API.KeyboardPress32(0x20, 0) end,
        post = function() return #API.ScanForInterfaceTest2Get(true, obeliskInterface) <= 0 end
    }
}

local function waitForStillness()
    while (API.CheckAnim(75) or API.ReadPlayerMovin2() or API.isProcessing()) and API.Read_LoopyLoop() do
        API.RandomSleep2(1000, 250, 500)
    end
end

local function validatePosition()
    if #API.GetAllObjArray1({ BANK_CHEST, OBELISK }, 50, { 0, 1, 12 }) <= 0 then
        print("Please start near the obelisk or bank in Prif!")
        return false
    end

    return true
end

while API.Read_LoopyLoop() and validatePosition() do
    API.DoRandomEvents()
    API.SetMaxIdleTime(MAX_IDLE_TIME_MINUTES)

    print("State: " .. STATES[state].desc)
    STATES[state].callback()
    waitForStillness()
    if STATES[state].post and not STATES[state].post() then
        print(STATES[state].desc .. " failed!")
        break
    end

    state = (state % #STATES) + 1
    API.RandomSleep2(1000, 500, 1000)
end
