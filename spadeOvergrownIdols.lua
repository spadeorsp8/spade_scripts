--[[
@title Overgrown Idol Chopper
@author Spade

* Start script within 15 tiles of the overgrown idol and vines (preferably with wood box in inventory for nests)
--]]

API = require("api")

API.SetDrawTrackedSkills(true)

local MAX_IDLE_TIME_MINUTES = 5
local ALL_VINES = { 111302, 111303, 111304, 111305, 111307 }
local INNER_VINES = { 111304, 111305 }
local IDOL = 111307

local function validatePosition()
    if #API.GetAllObjArray1(ALL_VINES, 15, { 0, 12 }) <= 0 then
        print("Please start near overgrown idol!")
        return false
    end

    return true
end

local function getChoppableVines(vines)
    local choppableVines = {}

    for _, vine in ipairs(API.GetAllObjArray1(vines, 15, { 0, 12 })) do
        if vine.Bool1 == 0 then
            table.insert(choppableVines, vine)
        end
    end

    return choppableVines
end

local function getReachableVines(vines)
    local reachableVines = {}

    for i, v1 in ipairs(vines) do
        local blocked = { false, false, false, false }

        for j, v2 in ipairs(vines) do
            if i == j then
                goto continue
            end

            local diff = 0
            if v2.TileX == v1.TileX then
                diff = (v2.TileY/512) - (v1.TileY/512)

                if diff == 1 then
                    -- v2 is 1 tile above v1
                    blocked[1] = true
                elseif diff == -1 then
                    -- v2 is 1 tile below v1
                    blocked[2] = true
                end
            elseif v2.TileY == v1.TileY then
                diff = (v2.TileX/512) - (v1.TileX/512)

                if diff == 1 then
                    -- v2 is 1 tile to the right of v1
                    blocked[3] = true
                elseif diff == -1 then
                    -- v1 is 1 tile to the left of v1
                    blocked[4] = true
                end
            end
        
            ::continue::
        end

        -- Vine is reachable if any edge is unblocked
        if not (blocked[1] and blocked[2] and blocked[3] and blocked[4]) then
            table.insert(reachableVines, v1)
        end
    end

    return reachableVines
end

local function getObjFromTable(id, table)
    for _, obj in ipairs(table) do
        if obj.Id == id then
            return obj
        end
    end

    return nil
end

while API.Read_LoopyLoop() and validatePosition() do
    API.DoRandomEvents()
    API.SetMaxIdleTime(MAX_IDLE_TIME_MINUTES)

    local choppableVines, reachableVines, chosenVine = nil, nil, nil

    if API.CheckAnim(50) or API.ReadPlayerMovin2() or API.isProcessing() then
        goto sleep
    end

    choppableVines = getChoppableVines(ALL_VINES)
    reachableVines = getReachableVines(choppableVines)

    for _, v in ipairs(INNER_VINES) do
        chosenVine = getObjFromTable(v, reachableVines)
        if chosenVine then
            break
        end
    end

    if not chosenVine then
        chosenVine = getObjFromTable(IDOL, reachableVines)
        if not chosenVine then
            chosenVine = reachableVines[math.random(1, #reachableVines)]
        end
    end

    -- API.DoAction_Object1(0x3b, API.OFF_ACT_GeneralObject_route0, { chosenVine }, 15)
    API.DoAction_Object_Direct(0x3b, API.OFF_ACT_GeneralObject_route0, chosenVine)

    ::sleep::
    API.RandomSleep2(1000, 500, 1000)
end
