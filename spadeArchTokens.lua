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
local PORTERS = { 51490, 29285, 29283, 29281, 29279, 29277, 29275 }
local SPOTS = { 130307, 130309 }

local spotIdx = 1
if API.ScriptDialogWindow2("Starting Location", {"Castle hall rubble", "Tunnelling equipment repository"}, "Start", "Close").Name == "Tunnelling equipment repository" then
    spotIdx = 2
end

API.SetDrawLogs(false)
API.SetDrawTrackedSkills(true)
API.SetMaxIdleTime(MAX_IDLE_TIME_MINUTES)

local followSprite = (API.ScriptDialogWindow2("Follow Sprite?", {"Yes", "No"}, "Start", "Close").Name == "Yes")
local clickedRemainsTile = nil
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

    clickedRemainsTile = nil
    return true
end

local function excavate()
    chargeGOTE()
    if artifactFoundInterfacePresent() and followSprite then
        clickedRemainsTile = nil
    end

    local remains = API.GetAllObjArrayInteract({ SPOTS[spotIdx] }, 50, { 0, 1, 12 })

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

            API.DoAction_Object2(0x2, API.OFF_ACT_GeneralObject_route0, { SPOTS[spotIdx] }, 50, WPOINT.new(targetRemainsTile.x, targetRemainsTile.y, 0))
            clickedRemainsTile = targetRemainsTile
        end
    end

    return true
end

while API.Read_LoopyLoop() do
    if API.GetGameState2() ~= 3 or not API.PlayerLoggedIn() then
        print("Bad game state, exiting.")
        break
    end

    API.DoRandomEvents()

    if API.InvFull_() and not bank() then
        --[[
            TODO: if not bank:
            1. Open bank
            2. Count each artifact, take the smallest count for number of groups to fix
            3. Teleport to Anachronia
            4. Grab up to 6 of each artifact from bank
            5. Interact with workbench to fix artifacts
            6. Donate artifacts
            7. Repeat 4-6 until there are no more artifacts to fix
            8. Teleport to Daemonheim using ring
                * API.DoAction_Interface(0xffffffff,15707,2,1430,77,-1,API.OFF_ACT_GeneralInterface_route)
                * API.DoAction_Ability("Ring of kinship", 2, API.OFF_ACT_GeneralInterface_route)
        ]] 
        break
    elseif not excavate() then
        break
    end

    API.RandomSleep2(1000, 1000, 1000)
end
