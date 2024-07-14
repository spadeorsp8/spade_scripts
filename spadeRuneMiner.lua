--[[
@title Prif Rune Miner BETA
@author Spade

* Start script near rune rocks in Prif
* Supports drinking perfect juju mining potions and recharging GOTE if porters are in inventory
--]]

local API = require('api')

local MAX_IDLE_TIME_MINUTES = 10
local POTIONS = {32769, 32771, 32773, 32775}
local ROCKS = { 112963, 112964 }
local HIGHLIGHTS = { 7164, 7165 }

API.SetDrawTrackedSkills(true)
API.SetMaxIdleTime(MAX_IDLE_TIME_MINUTES)

local function keepGOTEcharged()
    local buffStatus = API.Buffbar_GetIDstatus(51490, false)
    local stacks = tonumber(buffStatus.text)

    local function findporters()
        local portersIds = {51490, 29285, 29283, 29281, 29279, 29277, 29275}
        local porters = API.CheckInvStuff3(portersIds)
        local foundIdx = -1
        for i, value in ipairs(porters) do
            if tostring(value) == '1' then
                foundIdx = i
                break
            end
        end
        if foundIdx ~= -1 then
            local foundId = portersIds[foundIdx]
            if foundId <= 51490 then
                return foundId
            else
                return nil
            end
        else
            return nil
        end
    end
    
    if stacks and stacks <= 50 and findporters() then
        print ("Recharging GOTE")
        
        -- Assumes GOTE is in slot 2 of action bar
        API.DoAction_Interface(0xffffffff, 0xae06, 5, 1430, 77, -1, API.OFF_ACT_GeneralInterface_route)
        API.RandomSleep2(600,600,600)
    end
end

local function takeMiningPot()
    if API.Buffbar_GetIDstatus(32773).conv_text <= 1 then
        for _, pot in ipairs(POTIONS) do
            if API.InvItemcount_1(pot) > 0 then
                print("Drinking potion!")
                API.DoAction_Inventory1(pot, 0, 1, API.OFF_ACT_GeneralInterface_route)
                break
            end
        end
    end
end

local function FindHl(objects, maxdistance, highlight)
    for _, obj in ipairs(API.GetAllObjArray1(objects, maxdistance, {0})) do
        for _, hl in ipairs(API.GetAllObjArray1(highlight, maxdistance, {4})) do
            if math.abs(obj.Tile_XYZ.x - hl.Tile_XYZ.x) == 0 and math.abs(obj.Tile_XYZ.y - hl.Tile_XYZ.y) == 0 then
                return obj
            end
        end
    end

    return nil
end

clickedRockId = nil
while API.Read_LoopyLoop() do
    API.DoRandomEvents()

    takeMiningPot()
    keepGOTEcharged()
    API.RandomSleep2(1000, 250, 500)

    local shinyRock = FindHl(ROCKS, 50, HIGHLIGHTS)
    if shinyRock then
        if clickedRockId ~= shinyRock.Id then
            API.DoAction_Object_Direct(0x3a, API.OFF_ACT_GeneralObject_route0, shinyRock)
            clickedRockId = shinyRock.Id
        end
    else
        if not API.CheckAnim(25) then
            API.DoAction_Object1(0x3a, API.OFF_ACT_GeneralObject_route0, ROCKS, 50)
        end
    end

    API.RandomSleep2(1000, 1000, 2000)
end
