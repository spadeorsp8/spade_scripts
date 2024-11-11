--[[
@title Harvest Hollow Skiller
@author Spade

* Start near activity you'd like to do
* If training arch, load a bank preset with an empty inventory before starting
--]]

local API = require("api")

local MAX_IDLE_TIME_MINUTES = 15
local SMASHING_PUMPKIN = 31320
local LOOT_LOCATIONS = { 131351, 131353 }
local CANDLES = { 131362, 131364 }
local SUMMONING_CIRCLE = 131360
local MYSTERY_REMAINS = 131355
local ARCH_FOCUS = 7307
local EEP = 31287
local BANK_CHEST = 131378
local COMPLETE_TOME = 49976

local ENTRANCE_XRANGE = {698, 703}
local MAZE_PORTAL = 131372
local BONE_CLUB = 57608
local ZOMBIE_IMPLING = 31307
local ZOMBIE = 31305
local SKELETON = 31306
local GATE = 131376
local FENCE = 131377
local BOSS = 31303

API.SetDrawTrackedSkills(true)
API.SetMaxIdleTime(MAX_IDLE_TIME_MINUTES)

local followSprite = true
local clickedRemainsTile = nil
local artifactFoundInterface = {
    InterfaceComp5.new(1189, 2, -1, 0),
}

local function artifactFoundInterfacePresent()
    return #API.ScanForInterfaceTest2Get(true, artifactFoundInterface) > 0
end

local function getFocusRemains(remains, maxDistance)
    local focusRemains = nil
    local shortestDist = maxDistance
    for _, r in ipairs(remains) do
        for _, hl in ipairs(API.GetAllObjArray1({ ARCH_FOCUS }, maxDistance, {4})) do
            if API.Math_DistanceF(r.Tile_XYZ, hl.Tile_XYZ) < shortestDist then
                focusRemains = r
                shortestDist = API.Math_DistanceF(r.Tile_XYZ, hl.Tile_XYZ)
            end
        end
    end

    return focusRemains
end

local function waitForStillness()
    API.RandomSleep2(1000, 500, 1000)
    while (API.ReadPlayerMovin2() or API.CheckAnim(50)) and API.Read_LoopyLoop() do
        API.DoRandomEvents()
        API.RandomSleep2(500, 250, 500)
    end
end

local function smashPumpkin()
    return API.DoAction_NPC(0x29, API.OFF_ACT_InteractNPC_route, { SMASHING_PUMPKIN }, 50)
end

local function robGraves()
    if not (API.CheckAnim(50) or API.ReadPlayerMovin2()) then
        API.RandomSleep2(500, 2000, 3000)
        return API.DoAction_Object1(0x29, API.OFF_ACT_GeneralObject_route0, LOOT_LOCATIONS, 50)
    end

    return true
end

local function summon()
    if not API.DoAction_Object1(0x41, API.OFF_ACT_GeneralObject_route0, CANDLES, 50) then
        if not (API.CheckAnim(100) or API.ReadPlayerMovin2()) then
            return API.DoAction_Object1(0x29, API.OFF_ACT_GeneralObject_route0, { SUMMONING_CIRCLE }, 50)
        end
    end

    return true
end

local function excavate()
    if API.InvFull_() then
        API.DoAction_NPC(0x29, API.OFF_ACT_InteractNPC_route2, { EEP }, 50)
        waitForStillness()

        local preFreeCount = API.Invfreecount_()
        local postFreeCount = nil
        while (postFreeCount ~= preFreeCount) and API.Read_LoopyLoop() do
            preFreeCount = API.Invfreecount_()
            API.DoAction_Interface(0x24,0xffffffff, 1, 656, 25, 0, API.OFF_ACT_GeneralInterface_route)
            API.RandomSleep2(1000, 500, 1000)
            postFreeCount = API.Invfreecount_()
        end

        -- Load preset from bank if inventory is still too full after turning in artifacts
        if API.Invfreecount_() <= 5 then
            print("Banking!")

            if API.DoAction_Inventory1(COMPLETE_TOME, 0, 8, API.OFF_ACT_GeneralInterface_route2) then
                API.RandomSleep2(2000, 500, 1000)
                API.DoAction_Interface(0xffffffff, 0xffffffff, 0, 1183, 7, -1, API.OFF_ACT_GeneralInterface_Choose_option)
                API.RandomSleep2(1000, 500, 1000)
            end

            API.DoAction_Object1(0x33, API.OFF_ACT_GeneralObject_route3, { BANK_CHEST }, 50)
            waitForStillness()
        end

        clickedRemainsTile = nil
    end

    if artifactFoundInterfacePresent() and followSprite then
        clickedRemainsTile = nil
    end

    local remains = API.GetAllObjArrayInteract({ MYSTERY_REMAINS }, 50, { 12 })

    local focusRemains = nil
    if followSprite then
        focusRemains = getFocusRemains(remains, 50)
    end

    if focusRemains then
        if not clickedRemainsTile or API.Math_DistanceF(clickedRemainsTile, focusRemains.Tile_XYZ) ~= 0 then
            API.RandomSleep2(500, 1000, 1500)
            API.DoAction_Object_Direct(0x2, API.OFF_ACT_GeneralObject_route0, focusRemains)
            clickedRemainsTile = focusRemains.Tile_XYZ
        end
    else
        if not (API.CheckAnim(50) or API.ReadPlayerMovin2()) and #remains > 0 then
            local targetRemainsTile = clickedRemainsTile
            if not targetRemainsTile then
                targetRemainsTile = remains[math.random(1, #remains)].Tile_XYZ
            end

            API.DoAction_Object2(0x2, API.OFF_ACT_GeneralObject_route0, { MYSTERY_REMAINS }, 50, WPOINT.new(targetRemainsTile.x, targetRemainsTile.y, 0))
            clickedRemainsTile = targetRemainsTile
        end
    end

    return true
end

local function getBossHealth()
    return API.VB_FindPSettinOrder(10937, 0).state
end

local function completeMaze()
    if #API.GetAllObjArrayInteract({ MAZE_PORTAL }, 50, { 12 }) > 0 then
        print("Entering the maze")
        API.DoAction_Object1(0x39, API.OFF_ACT_GeneralObject_route0, { MAZE_PORTAL }, 50)
        waitForStillness()
        API.RandomSleep2(4000, 1000, 2000)
    end

    -- Press 'b' to open inventory interface
    if not API.InventoryInterfaceCheckvarbit() then
        API.KeyboardPress32(0x42, 0)
        API.RandomSleep2(250, 500, 750)
    end

    print("Waiting for first 3 zombie implings! Standing still is normal.")
    while API.InvItemcount_1(BONE_CLUB) < 3 and API.Read_LoopyLoop() do
        if API.DoAction_NPC(0x29, API.OFF_ACT_InteractNPC_route, { ZOMBIE_IMPLING }, 2) then
            waitForStillness()
        end

        API.RandomSleep2(1000, 250, 500)
    end

    if not API.Read_LoopyLoop() then return false end

    local lookForGate = false
    local xRange = ENTRANCE_XRANGE
    local yRange = {1726, 1727}
    if API.Dist_FLP(FFPOINT.new(720, 1726, 0)) < API.Dist_FLP(FFPOINT.new(698, 1727, 0)) then
        xRange = {717, 720}
        lookForGate = true
    end

    local selectedTile = FFPOINT.new(math.random(xRange[1], xRange[2]), math.random(yRange[1], yRange[2]), 0)
    while API.Dist_FLP(selectedTile) > 1 and API.Read_LoopyLoop() do
        if not (API.ReadPlayerMovin2() or API.CheckAnim(50)) then
            if API.DoAction_NPC(0x29, API.OFF_ACT_InteractNPC_route, { ZOMBIE, SKELETON }, 2) then
                print("Spooking enemy!")
                waitForStillness()
            end

            if API.Dist_FLP(selectedTile) < 1 then break end
            selectedTile = FFPOINT.new(math.random(xRange[1], xRange[2]), math.random(yRange[1], yRange[2]), 0)
            API.DoAction_TileF(selectedTile)
            API.RandomSleep2(1000, 250, 500)
            print("Navigating to ", selectedTile.x, selectedTile.y)
        end

        if API.DoAction_NPC(0x29, API.OFF_ACT_InteractNPC_route, { ZOMBIE_IMPLING }, 1) then
            print("Catching zombie impling!")
            API.RandomSleep2(500, 250, 500)
        end

        API.RandomSleep2(250, 500, 500)
    end

    if not API.Read_LoopyLoop() then return false end

    if lookForGate then
        if API.DoAction_Object2(0xb5, API.OFF_ACT_GeneralObject_route0, { GATE }, 50, WPOINT.new(713, 1726, 0)) then
            print("Jumping main gate!")
            waitForStillness()
        else
            xRange = ENTRANCE_XRANGE
            selectedTile = FFPOINT.new(math.random(xRange[1], xRange[2]), math.random(yRange[1], yRange[2]), 0)
            while API.Dist_FLP(selectedTile) > 1 and API.Read_LoopyLoop() do
                if not (API.ReadPlayerMovin2() or API.CheckAnim(30)) then
                    if API.DoAction_NPC(0x29, API.OFF_ACT_InteractNPC_route, { ZOMBIE, SKELETON }, 2) then
                        print("Spooking enemy!")
                        API.RandomSleep2(2000, 500, 1500)
                    end

                    if API.Dist_FLP(selectedTile) < 1 then break end
                    selectedTile = FFPOINT.new(math.random(xRange[1], xRange[2]), math.random(yRange[1], yRange[2]), 0)
                    API.DoAction_TileF(selectedTile)
                    print("Navigating to ", selectedTile.x, selectedTile.y)
                end

                if API.DoAction_NPC(0x29, API.OFF_ACT_InteractNPC_route, { ZOMBIE_IMPLING }, 1) then
                    print("Catching zombie impling!")
                    API.RandomSleep2(500, 500, 500)
                end

                if API.DoAction_Object1(0xb5,API.OFF_ACT_GeneralObject_route0,{ GATE }, 2) then
                    print("Jumping gate!")
                    waitForStillness()
                    break
                end

                API.RandomSleep2(250, 500, 500)
            end

            if not API.Read_LoopyLoop() then return false end
        end

        API.RandomSleep2(1000, 500, 1000)
    end

    print("Arrived in boss area!")

    ::collectImplings::
    local bonesToKill = (getBossHealth() / 10)
    if API.InvItemcount_1(BONE_CLUB) < bonesToKill then
        print("Going to catch remaining implings!")
        API.DoAction_TileF(FFPOINT.new(math.random(700, 707), math.random(1726, 1727), 0))
        waitForStillness()

        while API.InvItemcount_1(BONE_CLUB) < bonesToKill and API.Read_LoopyLoop() do
            if API.DoAction_NPC_In_Area(0x29, API.OFF_ACT_InteractNPC_route, { ZOMBIE_IMPLING }, 5, WPOINT.new(700, 1726, 0), WPOINT.new(707, 1727, 0), true, 0) then
                waitForStillness()
            end
    
            API.RandomSleep2(250, 500, 500)
        end

        if not API.Read_LoopyLoop() then return false end
    end

    print("Ready to fight the boss!")
    API.DoAction_Object1(0xb5, API.OFF_ACT_GeneralObject_route0, { FENCE }, 50)
    waitForStillness()

    local targetBoneCount = API.InvItemcount_1(BONE_CLUB) - bonesToKill
    while API.InvItemcount_1(BONE_CLUB) > targetBoneCount and API.Read_LoopyLoop() do
        API.DoAction_NPC(0x29, API.OFF_ACT_InteractNPC_route, { BOSS }, 50)
        API.RandomSleep2(500, 500, 500)
    end

    if not API.Read_LoopyLoop() then return false end

    if getBossHealth() > 0 then
        print("Boss isn't dead yet, we got spooked!")
        API.DoAction_Object1(0xb5, API.OFF_ACT_GeneralObject_route0, { FENCE }, 50)
        waitForStillness()
        if not API.Read_LoopyLoop() then return false end

        goto collectImplings
    end

    print("The boss is dead!")
    API.RandomSleep2(10000, 1000, 2000)

    return true
end

local ACTIVITY = API.ScriptDialogWindow2("Activity", {"Smash Pumpkin", "Train Thieving", "Train Summoning", "Train Arch", "Maize Maze"}, "Start", "Close").Name
if ACTIVITY == "Smash Pumpkin" then
    ACTIVITY = smashPumpkin
elseif ACTIVITY == "Train Thieving" then
    ACTIVITY = robGraves
elseif ACTIVITY == "Train Summoning" then
    ACTIVITY = summon
elseif ACTIVITY == "Train Arch" then
    followSprite = (API.ScriptDialogWindow2("Follow Sprite?", {"Yes", "No"}, "Start", "Close").Name == "Yes")
    ACTIVITY = excavate
elseif ACTIVITY == "Maize Maze" then
    ACTIVITY = completeMaze
else
    API.Write_LoopyLoop(false)
end

while API.Read_LoopyLoop() do
    if API.GetGameState2() ~= 3 or not API.PlayerLoggedIn() then
        print("Bad game state, exiting.")
        break
    end

    API.DoRandomEvents()
    if not ACTIVITY() then
        break
    end
    API.RandomSleep2(2000, 500, 1000)
end
