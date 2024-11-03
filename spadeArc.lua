--[[
@title Arc Skiller
@author Spade

Unfinished Arc Skiller
--]]

local API = require("api")

API.SetDrawTrackedSkills(true)

local MAX_IDLE_TIME_MINUTES = 10
local BAMBOO = 104007
local GOLDEN_BAMBOO = 104009

API.SetMaxIdleTime(MAX_IDLE_TIME_MINUTES)

local function chooseBamboo()
    local choppableTrees = {}

    for _, tree in ipairs(API.GetAllObjArray1({ GOLDEN_BAMBOO, BAMBOO }, 10, { 0, 12 })) do
        if tree.Bool1 == 0 then
            table.insert(choppableTrees, tree)
        end
    end

    if #choppableTrees <= 0 then
        return nil
    end

    return choppableTrees[1]
end

while API.Read_LoopyLoop() do
    if API.GetGameState2() ~=3 or not API.PlayerLoggedIn() then
        print("Bad game state, exiting.")
        break
    end

    API.DoRandomEvents()

    if not (API.CheckAnim(25) or API.ReadPlayerMovin2() or API.isProcessing()) then
        if not API.InvFull_() then
            local bambooObj = chooseBamboo()
            if bambooObj then
               API.DoAction_Object_Direct(0x3b, API.OFF_ACT_GeneralObject_route0, bambooObj)
            else
                break
            end

            API.RandomSleep2(1000, 500, 1000)
        else
            API.DoAction_Inventory1(37770, 0, 1, API.OFF_ACT_GeneralInterface_route)
            API.RandomSleep2(1000, 500, 1000)
            API.KeyboardPress32(0x20, 0)
        end
    end

    API.RandomSleep2(1000, 500, 1000)
end
