--[[
@title Archeology Token Farmer
@author Spade

* Requires GOTE equipped and on action bar.
* If redeeming artifacts, Ring of kinship must be equipped and on action bar.
* Make and load a bank preset with porters.
    * Leave at least one free space in inventory.
* If redeeming artifacts, bank chest must be unlocked in Anachronia.
--]]

local API = require("api")

local MAX_IDLE_TIME_MINUTES = 10
local ARCH_FOCUS = 7307
local COMPLETE_TOME = 49976
local BANKER = 9710
local SHARRIGAN = 27287
local TOTEM = 56975
local MINE = 56977
local RING = 56973
local GATESTONE = 56971
local BANK_CHEST = 114022
local WORKBENCH = 115421
local CHRONOTE = 49430
local TOKEN_BOX = 36093
local GOTE = 44550
local ARTIFACTS = { GATESTONE, RING, TOTEM, MINE }
local ARTIFACT_IFS = { 1, 5, 9, 13 }
local PORTERS = { 51490, 29285, 29283, 29281, 29279, 29277, 29275 }
local SPOTS = { 130307, 130309 }

-- Increase if you want to excavate more than 2 inventories of artifacts per redemption cycle
local BANK_INCREMENT = 2

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

local redeemArtifacts = (API.ScriptDialogWindow2("Redeem Artifacts?", {"Yes", "No"}, "Start", "Close").Name == "Yes")
local clickedSpotTile = nil

local function artifactFoundInterfacePresent()
    return #API.ScanForInterfaceTest2Get(true, {{ 1189, 2, -1, 0 }}) > 0
end

-- Credit Higgins for this function
local function lodestoneInterfaceOpen()
    return (#API.ScanForInterfaceTest2Get(true, {{ 1092, 1, -1, -1, 0 }, { 1092, 54, -1, 1, 0 } }) > 0) or API.VB_FindPSettinOrder(2874, 1).state == 30 or API.Compare2874Status(30)
end

local function workInterfaceOpen()
    return #API.ScanForInterfaceTest2Get(true, {{ 1371, 7, -1, 0 }}) > 0
end

local function sharriganInterfaceOpen()
    return #API.ScanForInterfaceTest2Get(true, {{ 656, 3, -1, 0 }}) > 0
end

local function waitForStillness()
    API.RandomSleep2(1000, 500, 1000)
    while (API.ReadPlayerMovin2() or API.isProcessing() or API.CheckAnim(50)) and API.Read_LoopyLoop() do
        API.DoRandomEvents()
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
    local necklaceContainer = API.Container_Get_all(94)[3]

    local porterId = getPorter()
    if not porterId then
        return
    end

    if necklaceContainer.item_id == GOTE then
        local stacks = tonumber(buffStatus.text)
        if not buffStatus.found then stacks = 0 end
        
        if stacks <= 50 then
            print("Recharging GOTE")
            API.DoAction_Ability("Grace of the elves", 5, API.OFF_ACT_GeneralInterface_route)
        end
    else
        if not buffStatus.found then
            print("Equipping new porter!")
            API.DoAction_Inventory1(porterId, 0, 2, API.OFF_ACT_GeneralInterface_route)
        end
    end

    API.RandomSleep2(500, 250, 500)
end

local function destroyTomes()
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
end

local function bank()
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
    if artifactFoundInterfacePresent() or not (API.CheckAnim(50) or API.ReadPlayerMovin2()) then
        clickedSpotTile = nil
    end

    local spots = API.GetAllObjArrayInteract({ SPOTS[spotIdx] }, 50, { 0, 1, 12 })

    local spriteSpot = getSpriteSpot(spots, 50)
    if spriteSpot then
        if not clickedSpotTile or API.Math_DistanceF(clickedSpotTile, spriteSpot.Tile_XYZ) ~= 0 then
            API.RandomSleep2(1000, 1000, 1500)
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

local function goToDaemonheim()
    if #API.GetAllObjArray1({ BANKER }, 50, { 1 }) > 0 then
        return
    end

    API.DoAction_Ability("Ring of kinship", 2, API.OFF_ACT_GeneralInterface_route)
    while(#API.GetAllObjArray1({ BANKER }, 50, { 1 }) <= 0) and API.Read_LoopyLoop() do
        API.RandomSleep2(1000, 500, 500)
    end
    API.RandomSleep2(5000, 1000, 1000)
end

local function goToAnachronia()
    API.DoAction_Interface(0xffffffff, 0xffffffff, 1, 1465, 18, -1, API.OFF_ACT_GeneralInterface_route)
    while not lodestoneInterfaceOpen() and API.Read_LoopyLoop() do
        API.RandomSleep2(1000, 500, 500)
    end
    
    API.DoAction_Interface(0xffffffff, 0xffffffff, 1, 1092, 25, -1, API.OFF_ACT_GeneralInterface_route)
    while(#API.GetAllObjArray1({ SHARRIGAN }, 50, { 1 }) <= 0) and API.Read_LoopyLoop() do
        API.RandomSleep2(1000, 500, 500)
    end
    API.RandomSleep2(5000, 1000, 1000)
end

local function getArtifacts()
    API.DoAction_Object1(0x2e, API.OFF_ACT_GeneralObject_route1, { BANK_CHEST }, 50)
    waitForStillness()

    while not API.BankOpen2() and API.Read_LoopyLoop() do
        API.RandomSleep2(1000, 500, 500)
    end
    API.RandomSleep2(500, 500, 500)

    if not API.BankOpen2() then
        print("Failed to open bank!")
        return 0
    end

    -- Deposit all
    if API.Invfreecount_() < 28 then
        API.DoAction_Interface(0xffffffff,0xffffffff,1,517,39,-1,API.OFF_ACT_GeneralInterface_route)
        API.RandomSleep2(500, 500, 500)
    end

    local itemsToGrab = 6
    for _, a in ipairs(ARTIFACTS) do
        for i = 1, itemsToGrab do
            if not API.DoAction_Bank(a, 1, API.OFF_ACT_GeneralInterface_route) then
                itemsToGrab = i
                break
            end
            API.RandomSleep2(250, 500, 500)
        end
    end

    API.KeyboardPress32(0x1B, 0)
    API.RandomSleep2(500, 500, 500)

    return itemsToGrab
end

local function restoreArtifacts()
    for _, a in ipairs(ARTIFACT_IFS) do
        API.DoAction_Object1(0x4, API.OFF_ACT_GeneralObject_route0, { WORKBENCH }, 50)
        waitForStillness()

        while not workInterfaceOpen() and API.Read_LoopyLoop() do
            API.RandomSleep2(1000, 500, 500)
        end
        API.RandomSleep2(1000, 500, 500)

        if not workInterfaceOpen() then
            return false
        end

        API.DoAction_Interface(0xffffffff, 0xffffffff, 1, 1371, 22, a, API.OFF_ACT_GeneralInterface_route)
        API.RandomSleep2(1000, 500, 500)

        API.KeyboardPress32(0x20, 0)
        API.RandomSleep2(500, 500, 500)

        if not API.isProcessing() then
            print("Processing didn't start!")
            return false
        end

        waitForStillness()
        API.RandomSleep2(1000, 500, 500)
    end

    return true
end

local function turnInArtifacts()
    API.DoAction_NPC(0x29, API.OFF_ACT_InteractNPC_route4, { SHARRIGAN }, 50)
    waitForStillness()

    while not sharriganInterfaceOpen() and API.Read_LoopyLoop() do
        API.RandomSleep2(1000, 500, 500)
    end
    API.RandomSleep2(500, 500, 500)

    if not sharriganInterfaceOpen() then
        print("Failed to talk to Sharrigan!")
        return false
    end

    API.DoAction_Interface(0x24, 0xffffffff, 1, 656, 31, 4, API.OFF_ACT_GeneralInterface_route)
    API.RandomSleep2(500, 500, 500)

    local preFreeCount = API.Invfreecount_()
    local postFreeCount = nil
    while (postFreeCount ~= preFreeCount) and API.Read_LoopyLoop() do
        preFreeCount = API.Invfreecount_()
        API.DoAction_Interface(0x24,0xffffffff, 1, 656, 25, 0, API.OFF_ACT_GeneralInterface_route)
        API.RandomSleep2(1000, 500, 1000)
        postFreeCount = API.Invfreecount_()
    end

    API.KeyboardPress32(0x1B, 0)
    API.RandomSleep2(500, 500, 500)

    -- Redeem chronotes
    API.DoAction_Inventory1(CHRONOTE, 0, 3, API.OFF_ACT_GeneralInterface_route)
    API.RandomSleep2(500, 1000, 1000)

    while API.InvItemcount_1(TOKEN_BOX) > 0  and API.Read_LoopyLoop() do
        API.DoAction_Inventory1(TOKEN_BOX, 0, 1, API.OFF_ACT_GeneralInterface_route)
        API.RandomSleep2(500, 1000, 1000)
    end

    if API.Invfreecount_() < 28 then
        print("Couldn't turn everything in!")
        return false
    end

    return true
end

local function maintainPrayer()
    if API.GetPrayPrecent() > math.random(60, 66) then
        return
    end

    if not API.DeBuffbar_GetIDstatus(43358, false).found then
        API.DoAction_Inventory1(43358, 0, 1, API.OFF_ACT_GeneralInterface_route)
    end
end

goToDaemonheim()

local itr = 1
while API.Read_LoopyLoop() do
    if API.GetGameState2() ~= 3 or not API.PlayerLoggedIn() then
        print("Bad game state, exiting.")
        break
    end

    API.DoRandomEvents()
    chargeGOTE()
    maintainPrayer()
    destroyTomes()

    if API.InvFull_() then
        if redeemArtifacts and itr % BANK_INCREMENT == 0 then
            API.RandomSleep2(1000, 1000, 1000)
            goToAnachronia()

            local keepRunning = true
            while keepRunning and API.Read_LoopyLoop() do
                local numArtifacts = getArtifacts()
                if numArtifacts == 0 then
                    break
                elseif numArtifacts < 6 then
                    keepRunning = false
                end

                if not restoreArtifacts() or not turnInArtifacts() then
                    break
                end
            end

            if API.Read_LoopyLoop() then
                goToDaemonheim()
            end
        else
            totemCount = totemCount + API.InvItemcount_1(TOTEM)
            mineCount = mineCount + API.InvItemcount_1(MINE)
            ringCount = ringCount + API.InvItemcount_1(RING)
            gatestoneCount = gatestoneCount + API.InvItemcount_1(GATESTONE)
        end

        if not bank() then
            break
        end

        itr = itr + 1
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
