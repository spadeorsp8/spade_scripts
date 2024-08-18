--[[
@title Spade Abyss
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
local TRAINING_SPOT = WPOINT.new(3059, 4812, 0)

local function moveToTrainingSpot(useDive)
    print("Running to training spot")
    if useDive then
        API.DoAction_Dive_Tile(TRAINING_SPOT)
        API.RandomSleep2(2000, 500, 1000)
    end
    
    API.DoAction_Tile(TRAINING_SPOT)
    API.RandomSleep2(1000, 250, 500)
    while API.ReadPlayerMovin2() and API.Read_LoopyLoop() do
        API.RandomSleep2(1000, 250, 500)
    end
    API.RandomSleep2(1000, 250, 500)

    API.DoAction_NPC(0x2a, API.OFF_ACT_AttackNPC_route, NPCS, 2)
end

moveToTrainingSpot(false)
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

    if not API.LootWindowOpen_2() then
        -- Open loot window and move back to training spot
        if API.DoAction_Loot_w(LOOT, 3, API.PlayerCoordfloat(), 10) then
            API.RandomSleep2(1000, 250, 500)
            moveToTrainingSpot(false)
        end
    else
        if math.random(1, 100) <= 5 then
            -- Loot custom
            API.DoAction_Interface(0x24, 0xffffffff, 1, 1622, 30, -1, API.OFF_ACT_GeneralInterface_route)
        end
    end
    

    if not API.LocalPlayer_IsInCombat_() then
        print("Running to reset spot")
        local resetTile = WPOINT.new(3058 + math.random(-5, 5), 4844 + math.random(0, 5), 0)
        API.DoAction_Tile(resetTile)
        API.RandomSleep2(1000, 250, 500)
        API.DoAction_Ability_check("Surge", 1, API.OFF_ACT_GeneralInterface_route, true, true)
        API.RandomSleep2(1000, 250, 500)
        API.DoAction_Tile(resetTile)
        API.RandomSleep2(1000, 250, 500)
        while (API.CheckAnim(2) or API.ReadPlayerMovin2()) and API.Read_LoopyLoop() do
            API.RandomSleep2(1000, 250, 500)
        end

        moveToTrainingSpot(true)
    end

    API.RandomSleep2(1000, 250, 500)
end
