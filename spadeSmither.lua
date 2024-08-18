--[[
@title Spade Smither - WIP
@author Spade

* Start with your unfinished items in your inventory
--]]

local API = require("api")
local MAX_IDLE_TIME_MINUTES = 10

API.SetDrawTrackedSkills(true)
API.SetMaxIdleTime(MAX_IDLE_TIME_MINUTES)

local UNFINISHED_ITEM = 47068
local FORGE = 125136
local ANVIL = 125135

local function atFullHeat()
    local chatTexts = API.GatherEvents_chat_check()
    for _, v in ipairs(chatTexts) do
        if (string.find(v.text, "Your unfinished item is at full heat")) then
            return true
        end
    end

    return false
end

API.DoAction_Object1(0x3f, API.OFF_ACT_GeneralObject_route0, { ANVIL }, 50)
while API.Read_LoopyLoop() do
    API.DoRandomEvents()

    if API.InvItemcount_1(UNFINISHED_ITEM) <= 0 then
        break
    end

    -- TODO: Convert this to state machine
    if API.LocalPlayer_HoverProgress() <= 153 or not API.CheckAnim(100) then
        API.DoAction_Object1(0x3f, API.OFF_ACT_GeneralObject_route0, { FORGE }, 15)

        local timeout = os.time() + 10
        while not atFullHeat() and API.Read_LoopyLoop() and os.time() < timeout do
            API.RandomSleep2(1000, 1500, 2000)
        end

        API.DoAction_Object1(0x3f, API.OFF_ACT_GeneralObject_route0, { ANVIL }, 50)
    end

    API.RandomSleep2(2000, 500, 1000)
end
