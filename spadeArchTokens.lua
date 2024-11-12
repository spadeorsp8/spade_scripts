--[[
@title Archeology Token Farmer
@author Spade

* Requires GOTE equipped and on action bar.
* Make and load a bank preset with porters.
* Leave at least one free space in inventory.
--]]

local API = require("api")

local MAX_IDLE_TIME_MINUTES = 10
local ARCH_FOCUS = 7307
local COMPLETE_TOME = 49976
local BANKER = 9710
local TOTEM = 56975
local MINE = 56977
local RING = 56973
local GATESTONE = 56971
local PORTERS = { 51490, 29285, 29283, 29281, 29279, 29277, 29275 }
local SPOTS = { 130307, 130309 }

local spotIdx = 1
if API.ScriptDialogWindow2("Starting Location", {"Castle hall rubble", "Tunnelling equipment repository"}, "Start", "Close").Name == "Tunnelling equipment repository" then
    spotIdx = 2
end

local totemCount = 0
local mineCount = 0
local ringCount = 0
local gatestoneCount = 0

API.SetDrawTrackedSkills(true)
API.SetMaxIdleTime(MAX_IDLE_TIME_MINUTES)

local followSprite = (API.ScriptDialogWindow2("Follow Sprite?", {"Yes", "No"}, "Start", "Close").Name == "Yes")
local clickedSpotTile = nil
local artifactFoundInterface = {
    InterfaceComp5.new(1189, 2, -1, 0),
}

local function artifactFoundInterfacePresent()
    return #API.ScanForInterfaceTest2Get(true, artifactFoundInterface) > 0
end

local function waitForStillness()
    API.RandomSleep2(1000, 500, 1000)
    while (API.ReadPlayerMovin2() or API.CheckAnim(50)) and API.Read_LoopyLoop() do
        API.RandomSleep2(500, 250, 500)
    end
end

local function getSpriteSpot(spots, maxDistance)
    local spriteSpot = nil
    local shortestDist = maxDistance
    for _, r in ipairs(spots) do
        for _, hl in ipairs(API.GetAllObjArray1({ ARCH_FOCUS }, maxDistance, {4})) do
            if API.Math_DistanceF(r.Tile_XYZ, hl.Tile_XYZ) < shortestDist then
                spriteSpot = r
                shortestDist = API.Math_DistanceF(r.Tile_XYZ, hl.Tile_XYZ)
            end
        end
    end

    return spriteSpot
end

local function getPorter()
    local porterId = nil
    for _, id in ipairs(PORTERS) do
        if API.InvItemcount_1(id) > 0 then
            porterId = id
            break
        end
    end

    return porterId
end

local function chargeGOTE()
    local buffStatus = API.Buffbar_GetIDstatus(51490, false)
    local stacks = tonumber(buffStatus.text)

    if not buffStatus.found then
        stacks = 0
    end

    local porterId = getPorter()
    if porterId and stacks and stacks <= 50 then
        print ("Recharging GOTE")
        API.DoAction_Ability("Grace of the elves", 5, API.OFF_ACT_GeneralInterface_route)
        API.RandomSleep2(500, 250, 500)
    end
end

local function bank()
    totemCount = totemCount + API.InvItemcount_1(TOTEM)
    mineCount = mineCount + API.InvItemcount_1(MINE)
    ringCount = ringCount + API.InvItemcount_1(RING)
    gatestoneCount = gatestoneCount + API.InvItemcount_1(GATESTONE)

    -- Destroy complete tomes so we can load preset
    if API.DoAction_Inventory1(COMPLETE_TOME, 0, 8, API.OFF_ACT_GeneralInterface_route2) then
        API.RandomSleep2(2000, 500, 1000)

        if API.InvItemcount_1(COMPLETE_TOME) > 1 then
            API.DoAction_Interface(0xffffffff, 0xffffffff, 0, 1183, 7, -1, API.OFF_ACT_GeneralInterface_Choose_option)
        else
            API.DoAction_Interface(0xffffffff, 0xffffffff, 0, 1183, 5, -1, API.OFF_ACT_GeneralInterface_Choose_option)
        end

        API.RandomSleep2(1000, 500, 1000)
    end

    if not API.DoAction_NPC(0x33, API.OFF_ACT_InteractNPC_route4, { BANKER }, 50) then
        print("Failed to interact with banker!")
        return false
    end
    waitForStillness()

    if not getPorter() then
        print("Out of porters!")
        return false
    end

    spotIdx = (spotIdx % #SPOTS) + 1
    print(string.format("Switching to spot %d", SPOTS[spotIdx]))

    clickedSpotTile = nil
    return true
end

local function excavate()
    chargeGOTE()
    if artifactFoundInterfacePresent() and followSprite then
        clickedSpotTile = nil
    end

    local spots = API.GetAllObjArrayInteract({ SPOTS[spotIdx] }, 50, { 0, 1, 12 })

    local spriteSpot = nil
    if followSprite then
        spriteSpot = getSpriteSpot(spots, 50)
    end

    if spriteSpot then
        if not clickedSpotTile or API.Math_DistanceF(clickedSpotTile, spriteSpot.Tile_XYZ) ~= 0 then
            API.RandomSleep2(500, 1000, 1500)
            API.DoAction_Object_Direct(0x2, API.OFF_ACT_GeneralObject_route0, spriteSpot)
            clickedSpotTile = spriteSpot.Tile_XYZ
        end
    else
        if not (API.CheckAnim(50) or API.ReadPlayerMovin2()) and #spots > 0 then
            local targetSpotTile = clickedSpotTile
            if not targetSpotTile then
                targetSpotTile = spots[math.random(1, #spots)].Tile_XYZ
            end

            API.DoAction_Object2(0x2, API.OFF_ACT_GeneralObject_route0, { SPOTS[spotIdx] }, 50, WPOINT.new(targetSpotTile.x, targetSpotTile.y, 0))
            clickedSpotTile = targetSpotTile
        end
    end

    return true
end

local function getCollectionsPerHour()
    local collections = math.min(ringCount + API.InvItemcount_1(RING),
                                 gatestoneCount + API.InvItemcount_1(GATESTONE),
                                 totemCount + API.InvItemcount_1(TOTEM),
                                 mineCount + API.InvItemcount_1(MINE))
    local runtimeHrs = API.ScriptRuntime() / 3600.0
    return collections / runtimeHrs
end

while API.Read_LoopyLoop() do
    if API.GetGameState2() ~= 3 or not API.PlayerLoggedIn() then
        print("Bad game state, exiting.")
        break
    end

    API.DoRandomEvents()

    if API.InvFull_() and not bank() then
        break
    elseif not excavate() then
        break
    end

    local metrics = {
        {"Engraved ring of kinship", ringCount + API.InvItemcount_1(RING)},
        {"Castle gatestone", gatestoneCount + API.InvItemcount_1(GATESTONE)},
        {"Exploratory totem", totemCount + API.InvItemcount_1(TOTEM)},
        {"Excavator portal mine", mineCount + API.InvItemcount_1(MINE)},
        {"Collections per hour", getCollectionsPerHour()}
    }
    API.DrawTable(metrics)

    API.RandomSleep2(1000, 1000, 1000)
end
