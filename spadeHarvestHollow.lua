--[[
@title Harvest Hallow Skiller
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

API.SetDrawTrackedSkills(true)
API.SetMaxIdleTime(MAX_IDLE_TIME_MINUTES)

local clickedRemainsTile = nil
local artifactFoundInterface = {
    InterfaceComp5.new(1189, 2, -1, -1, 0),
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
    while (API.CheckAnim(50) or API.ReadPlayerMovin2()) and API.Read_LoopyLoop() do
        API.RandomSleep2(1000, 500, 1000)
    end
end

local function smashPumpkin()
    API.DoAction_NPC(0x29, API.OFF_ACT_InteractNPC_route, { SMASHING_PUMPKIN }, 50)
end

local function robGraves()
    if not (API.CheckAnim(50) or API.ReadPlayerMovin2()) then
        API.RandomSleep2(500, 2000, 3000)
        API.DoAction_Object1(0x29, API.OFF_ACT_GeneralObject_route0, LOOT_LOCATIONS, 50)
    end
end

local function summon()
    if not API.DoAction_Object1(0x41, API.OFF_ACT_GeneralObject_route0, CANDLES, 50) then
        if not (API.CheckAnim(100) or API.ReadPlayerMovin2()) then
            API.DoAction_Object1(0x29, API.OFF_ACT_GeneralObject_route0, { SUMMONING_CIRCLE }, 50)
        end
    end
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

    if artifactFoundInterfacePresent() then
        clickedRemainsTile = nil
    end

    local remains = API.GetAllObjArrayInteract({ MYSTERY_REMAINS }, 50, { 12 })
    local focusRemains = getFocusRemains(remains, 50)
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
end

local ACTIVITY = API.ScriptDialogWindow2("Activity", {"Smash Pumpkin", "Train Thieving", "Train Summoning", "Train Arch"}, "Start", "Close").Name
if ACTIVITY == "Smash Pumpkin" then
    ACTIVITY = smashPumpkin
elseif ACTIVITY == "Train Thieving" then
    ACTIVITY = robGraves
elseif ACTIVITY == "Train Summoning" then
    ACTIVITY = summon
elseif ACTIVITY == "Train Arch" then
    ACTIVITY = excavate
else
    API.Write_LoopyLoop(false)
end

while API.Read_LoopyLoop() do
    if API.GetGameState2() ~=3 or not API.PlayerLoggedIn() then
        print("Bad game state, exiting.")
        break
    end

    API.DoRandomEvents()
    ACTIVITY()
    API.RandomSleep2(2000, 500, 1000)
end
