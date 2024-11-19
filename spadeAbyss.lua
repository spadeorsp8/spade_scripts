--[[
@title Spade Abyss
@author Spade

* Have food in inventory and put "Eat food" ability on ability bar
* Put War's Retreat teleport on ability bar
* Configure custom loot button in RS3 settings, or set LOOT to nil to disable looting
* Start script after entering the Abyss
--]]

local API = require("api")
local MAX_IDLE_TIME_MINUTES = 10

API.SetDrawTrackedSkills(true)
API.SetMaxIdleTime(MAX_IDLE_TIME_MINUTES)
math.randomseed(os.time())

local LOOT = { 592, 7937 }
local NPCS = { 2265, 2264, 2263 }
local STARTING_SPOT = FFPOINT.new(3040 + math.random(-5, 5), 4809 + math.random(-5, 5), 0)
local SAFE_SPOT = FFPOINT.new(3048, 4805, 0)
local TRAINING_DATA = {
    {
        trainingSpots = { FFPOINT.new(3030, 4807, 0), FFPOINT.new(3029, 4807, 0) },
        resetSpot = {3019, 4844},
    },
    {
        trainingSpots = { FFPOINT.new(3059, 4812, 0), FFPOINT.new(3059,4814,0) },
        resetSpot = {3058, 4844},
    },
}

local function chargePackCheck()
    local chatTexts = API.GatherEvents_chat_check()
    for _, v in ipairs(chatTexts) do
        if (string.find(v.text, "Your charge pack has run out of power")) then
            print("Charge pack is empty!")
            API.DoAction_Ability("Retreat Teleport", 1, API.OFF_ACT_GeneralInterface_route)
            API.Write_LoopyLoop(false)
            return
        end
    end
end

local function maintainHealth()
    if API.GetHPrecent() > 50 then
        return
    end

    print("Eating food!")
    if not API.DoAction_Ability_check("Eat Food", 1, API.OFF_ACT_GeneralInterface_route, true, true) then
        API.DoAction_Ability("Retreat Teleport", 1, API.OFF_ACT_GeneralInterface_route)
        API.Write_LoopyLoop(false)
        return
    end

    API.RandomSleep2(1000, 250, 500)
end

local function waitForStillness()
    API.RandomSleep2(1000, 250, 500)
    while (API.CheckAnim(2) or API.ReadPlayerMovin2()) and API.Read_LoopyLoop() do
        maintainHealth()
        API.RandomSleep2(1000, 250, 500)
    end
end

local function moveToTrainingSpot(trainingSpots)
    print("Running to training spot.")
    API.DoAction_TileF(trainingSpots[math.random(1, #trainingSpots)])
    waitForStillness()

    API.RandomSleep2(1000, 250, 500)
    API.DoAction_NPC(0x2a, API.OFF_ACT_AttackNPC_route, NPCS, 2)
end

local function loot(trainingData)
    if not API.LootWindowOpen_2() then
        -- Open loot window and move back to training spot
        if API.DoAction_Loot_w(LOOT, 3, API.PlayerCoordfloat(), 10) then
            API.RandomSleep2(1000, 250, 500)
            moveToTrainingSpot(trainingData.trainingSpots)
        end
    else
        if math.random(1, 100) <= 5 then
            -- Press custom loot button
            API.DoAction_Interface(0x24, 0xffffffff, 1, 1622, 30, -1, API.OFF_ACT_GeneralInterface_route)
        end
    end
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

local function chooseTrainingData()
    for _, v in ipairs(TRAINING_DATA) do
        if not playerNearTile(v.trainingSpots[1], 15) then
            return v
        end
    end

    return nil
end

if #API.GetAllObjArray1(NPCS, 50, {1}) <= 0 then
    print("No Abyssal NPCs detected, please start in the Abyss!")
    return
end

if API.Dist_FLP(STARTING_SPOT) >= 20 then
    print("Running to starting spot.")
    API.DoAction_TileF(STARTING_SPOT)
    waitForStillness()
end

local TDATA = chooseTrainingData()
if not TDATA then
    -- TODO: Hop worlds automatically
    print("Neither training spot is open, please hop worlds and try again!")
    API.DoAction_TileF(SAFE_SPOT)
    return
end

moveToTrainingSpot(TDATA.trainingSpots)
while API.Read_LoopyLoop() do
    if API.GetGameState2() ~= 3 or not API.PlayerLoggedIn() then
        print("Bad game state, exiting.")
        break
    end

    if LOOT then loot(TDATA) end
    if not API.CheckAnim(100) and not API.LocalPlayer_IsInCombat_() then
        print("Running to reset spot.")
        local resetTile = FFPOINT.new(TDATA.resetSpot[1] + math.random(-5, 5), TDATA.resetSpot[2] + math.random(0, 5), 0)
        API.DoAction_TileF(resetTile)

        waitForStillness()
        moveToTrainingSpot(TDATA.trainingSpots)
    end

    maintainHealth()
    chargePackCheck()
    API.RandomSleep2(1000, 250, 500)
end
