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

    for _, tree in ipairs(API.GetAllObjArray1({ GOLDEN_BAMBOO, BAMBOO }, 30, { 0, 12 })) do
        if tree.Bool1 == 0 then
            table.insert(choppableTrees, tree)
        end
    end

    if #choppableTrees <= 0 then
        return nil
    end

    return choppableTrees[1]
end

local function handleElidinisEvents()
    local lostSoul = 17720
    local unstableSoul = 17739
    local mimickingSoul = 18222
    local eventIDs = { lostSoul, unstableSoul, mimickingSoul }

    local found = false
    local eventObjs = API.GetAllObjArray1(eventIDs, 50, { 1 })
    if #eventObjs > 0 then
        print("Elidinis soul detected!")
        found = true
    end

    local originTile = API.PlayerCoordfloat()
    while #eventObjs > 0 and API.Read_LoopyLoop() do
        if eventObjs[1].Id == mimickingSoul then
            API.DoAction_TileF(eventObjs[1].Tile_XYZ)
        elseif eventObjs[1].Id == unstableSoul or eventObjs[1].Id == lostSoul then
            -- API.DoAction_NPC(0x29, API.OFF_ACT_InteractNPC_route, { eventObjs[1].Id }, 50)
            API.DoAction_NPC__Direct(0x29, API.OFF_ACT_InteractNPC_route, eventObjs[1])
        end

        API.RandomSleep2(1000, 250, 500)
        eventObjs = API.GetAllObjArray1(eventIDs, 50, { 1 })
    end

    if found then API.DoAction_TileF(originTile) end
end

while API.Read_LoopyLoop() do
    if API.GetGameState2() ~= 3 or not API.PlayerLoggedIn() then
        print("Bad game state, exiting.")
        break
    end

    API.DoRandomEvents()
    handleElidinisEvents()

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
            API.RandomSleep2(1500, 500, 1000)
            API.KeyboardPress32(0x20, 0)
        end
    end

    API.RandomSleep2(1000, 500, 1000)
end
