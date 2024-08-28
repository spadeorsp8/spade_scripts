--[[
@title Spade Abyss - WORK IN PROGRESS
@author Spade
--]]

local API = require("api")
local MAX_IDLE_TIME_MINUTES = 10

API.SetDrawTrackedSkills(true)
API.SetMaxIdleTime(MAX_IDLE_TIME_MINUTES)

-- safe spot: API.DoAction_Tile(WPOINT.new(3048,4805,0))
-- training spot: API.DoAction_Tile(WPOINT.new(3059,4812,0))
-- reset spot: API.DoAction_Tile(WPOINT.new(3058,4844,0))

local LOOT = { 592, 7937 }
local NPCS = { 2265, 2264, 2263 }
local TRAINING_SPOT = FFPOINT.new(3059, 4812, 0)

--[[
Training spot 1 alt:
[16:41:38:144] API.DoAction_Tile(WPOINT.new(3059,4814,0))

Training spot 2:
[16:37:49:011] API.DoAction_Tile(WPOINT.new(3030,4807,0))
[16:37:52:885] API.DoAction_Tile(WPOINT.new(3029,4807,0))

Reset spot 2:
[16:39:55:095] API.DoAction_Tile(WPOINT.new(3019,4844,0))
]]

local function moveToTrainingSpot()
    print("Running to training spot")
    API.DoAction_TileF(TRAINING_SPOT)
    API.RandomSleep2(1000, 250, 500)
    while API.ReadPlayerMovin2() and API.Read_LoopyLoop() do
        API.RandomSleep2(1000, 250, 500)
    end
    API.RandomSleep2(1000, 250, 500)

    API.DoAction_NPC(0x2a, API.OFF_ACT_AttackNPC_route, NPCS, 2)
end

local function playerNearTile(targetTile, dist)
    for _, p in ipairs(API.GetAllObjArray1({1}, 50, {2})) do
        local distance = API.Math_DistanceF(p.Tile_XYZ, targetTile)
        if distance < dist and p.Name ~= API.GetLocalPlayerName() then
            print(string.format("%s is in the training spot! Dist: %f", p.Name, distance))
            return true
        end
    end

    return false
end

local function getCurrentWorld()
    local worldPtr = 0x00D82B00
    local offsets = {0x78, 0x9C8, 0x0, 0x20, 0x8}

    local val = API.Mem_Read_uint64(API.Get_RSExeStart() + worldPtr)
    for _, offset in pairs(offsets) do
        val = API.Mem_Read_uint64(val + offset)
    end
    return val
end

print(string.format("%x", getCurrentWorld()))

-- print(playerNearTile(TRAINING_SPOT, 15))

-- TODO: Add more than one training spot, and automatically move to it based on if a player is nearby or not

moveToTrainingSpot()
while API.Read_LoopyLoop() do
    if API.GetGameState2() ~=3 or not API.PlayerLoggedIn() then
        print("Bad game state, exiting.")
        break
    end

    if API.GetHPrecent() < 50 then
        print("Eating food!")

        if not API.DoAction_Ability_check("Eat Food", 1, API.OFF_ACT_GeneralInterface_route, true, true) then
            API.DoAction_Ability("Retreat Teleport", 1, API.OFF_ACT_GeneralInterface_route)
            break
        end

        API.RandomSleep2(1000, 250, 500)
    end

    -- TODO: Convert to state machine to get rid of while loop sleeps
    if not API.LootWindowOpen_2() then
        -- Open loot window and move back to training spot
        if API.DoAction_Loot_w(LOOT, 3, API.PlayerCoordfloat(), 10) then
            API.RandomSleep2(1000, 250, 500)
            moveToTrainingSpot()
        end
    else
        if math.random(1, 100) <= 5 then
            -- Loot custom
            API.DoAction_Interface(0x24, 0xffffffff, 1, 1622, 30, -1, API.OFF_ACT_GeneralInterface_route)
        end
    end
    

    if not API.LocalPlayer_IsInCombat_() then
        print("Running to reset spot")
        local resetTile = FFPOINT.new(3058 + math.random(-5, 5), 4844 + math.random(0, 5), 0)
        API.DoAction_TileF(resetTile)
        API.RandomSleep2(1000, 250, 500)
        API.DoAction_Ability_check("Surge", 1, API.OFF_ACT_GeneralInterface_route, true, true)
        API.RandomSleep2(1000, 250, 500)
        API.DoAction_TileF(resetTile)
        API.RandomSleep2(1000, 250, 500)
        while (API.CheckAnim(2) or API.ReadPlayerMovin2()) and API.Read_LoopyLoop() do
            API.RandomSleep2(1000, 250, 500)
        end

        moveToTrainingSpot()
    end

    API.RandomSleep2(1000, 250, 500)
end
