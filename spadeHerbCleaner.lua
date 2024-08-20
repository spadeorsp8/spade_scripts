--[[
@title Herb Cleaner
@author Spade

* Create bank preset full of grimy herbs
* Put herblore cape in ability bar
* Start script near the Fort Forinthry workshop bank
--]]

local API = require('api')

local MAX_IDLE_TIME_MINUTES = 15
local BANK_CHEST = 125115
local cape = API.GetABs_name1("Herblore cape (t)")

API.SetMaxIdleTime(MAX_IDLE_TIME_MINUTES)

herbsCleaned = 0
state = 1
local STATES = {
    {
        desc = "Loading preset",
        -- callback = function() API.DoAction_Object1(0x33, API.OFF_ACT_GeneralObject_route3, { BANK_CHEST }, 20) end,
        callback = function() API.DoAction_NPC(0x33, API.OFF_ACT_InteractNPC_route4, { 3418 }, 50) end,
        post = function() API.RandomSleep2(500, 500, 500) return API.InvFull_() end
    },
    {
        desc = "Cleaning herbs",
        callback = function() API.DoAction_Ability_Direct(cape, 2, API.OFF_ACT_GeneralInterface_route) end,
        post = function() herbsCleaned = herbsCleaned + 28 return true end
    }
}

while API.Read_LoopyLoop() do
    API.DoRandomEvents()
    API.DrawTable({{"Herbs Cleaned:", herbsCleaned}})

    if not (API.CheckAnim(10) or API.ReadPlayerMovin2() or API.isProcessing()) then
        print("State: " .. STATES[state].desc)
        STATES[state].callback()

        if STATES[state].post and not STATES[state].post() then
            print("Out of supplies!")
            break
        end

        state = (state % #STATES) + 1
    end

    API.RandomSleep2(250, 100, 250)
end