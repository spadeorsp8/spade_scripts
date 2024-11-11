--[[
@title Spade Miner
@author Spade

* Start script near rocks you want to mine
* Select rock you want to mine from menu

Note: Supports drinking perfect juju mining potions and recharging GOTE if porters are in inventory
--]]

local API = require('api')

local MAX_IDLE_TIME_MINUTES = 10
local POTIONS = { 32769, 32771, 32773, 32775 }
local HIGHLIGHTS = { 7164, 7165 }
local PORTERS = { 51490, 29285, 29283, 29281, 29279, 29277, 29275 }
local menu = API.CreateIG_answer()
local imguiBackground = API.CreateIG_answer()

API.SetDrawTrackedSkills(true)
API.SetMaxIdleTime(MAX_IDLE_TIME_MINUTES)

local function setupMenu()
    local uniqueTable = {}
    local objects = API.ReadAllObjectsArray({0, 12}, {-1}, {})
    for _, o in ipairs(objects) do
        if o.Name and (string.find(o.Name, 'rock') or o.Name == 'Seren stone')and o.Distance <= 50 then
            uniqueTable[o.Name] = true
        end
    end

    imguiBackground.box_name = "imguiBackground"
    imguiBackground.box_start = FFPOINT.new(1, 60, 0)
    imguiBackground.box_size = FFPOINT.new(400, 100, 0)
    imguiBackground.colour = ImColor.new(10, 13, 29)

    menu.box_name = "Spade Miner"
    menu.box_start = FFPOINT.new(1, 60, 0)
    menu.box_size = FFPOINT.new(400, 0, 0)
    menu.stringsArr = {}
    menu.colour = ImColor.new(10, 13, 29)

    for r, _ in pairs(uniqueTable) do
        table.insert(menu.stringsArr, r)
    end
    table.sort(menu.stringsArr)

    API.DrawSquareFilled(imguiBackground)
    API.DrawComboBox(menu, false)
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

local function takeMiningPot()
    if API.Buffbar_GetIDstatus(32773).conv_text > 1 then
        return
    end

    for _, pot in ipairs(POTIONS) do
        if API.InvItemcount_1(pot) > 0 then
            print("Drinking potion!")
            API.DoAction_Inventory1(pot, 0, 1, API.OFF_ACT_GeneralInterface_route)
            break
        end
    end
end

local function getShinyRock(rocks, maxDistance)
    local shinyRock = nil
    local shortestDist = maxDistance
    for _, rock in ipairs(rocks) do
        for _, hl in ipairs(API.GetAllObjArray1(HIGHLIGHTS, maxDistance, {4})) do
            if API.Math_DistanceF(rock.Tile_XYZ, hl.Tile_XYZ) < shortestDist then
                shinyRock = rock
                shortestDist = API.Math_DistanceF(rock.Tile_XYZ, hl.Tile_XYZ)
            end
        end
    end

    return shinyRock
end

local function getProgress(samples)
    local samples = samples or 1
    local max = 0
    for i = 1, samples do
        local progress = API.LocalPlayer_HoverProgress()
        if progress > max then max = progress end
        API.RandomSleep2(250, 0, 0)
    end
    return max
end

setupMenu()

local selectedRock = nil
local clickedRockId = nil
local clickedRockTile = nil
while API.Read_LoopyLoop() do
    if API.GetGameState2() ~= 3 or not API.PlayerLoggedIn() then
        print("Bad game state, exiting.")
        break
    end

    API.DoRandomEvents()
    takeMiningPot()
    chargeGOTE()

    if API.InvFull_() and not getPorter() then
        print("Out of porters!")
        break
    end

    if (menu.return_click) then
        menu.return_click = false
        print("Selected " .. menu.string_value)
        selectedRock = menu.string_value
    end

    if selectedRock then
        local rocks = API.GetAllObjArrayInteract_str({ selectedRock }, 50, { 0, 12 })
        local shinyRock = getShinyRock(rocks, 50)
        if shinyRock then
            if not clickedRockTile or API.Math_DistanceF(clickedRockTile, shinyRock.Tile_XYZ) ~= 0 then
                API.RandomSleep2(500, 1000, 1500)
                API.DoAction_Object_Direct(0x3a, API.OFF_ACT_GeneralObject_route0, shinyRock)
                clickedRockId = shinyRock.Id
                clickedRockTile = shinyRock.Tile_XYZ
            end
        else
            -- Click rock again to refresh stamina
            if selectedRock ~= "Seren stone" and clickedRockTile and clickedRockId and getProgress(5) < math.random(145, 165) then
                API.DoAction_Object2(0x3a, API.OFF_ACT_GeneralObject_route0, { clickedRockId }, 50, WPOINT.new(clickedRockTile.x, clickedRockTile.y, 0))
            end

            if not API.CheckAnim(25) and #rocks > 0 then
                local randomRock = rocks[math.random(1, #rocks)]
                API.DoAction_Object_Direct(0x3a, API.OFF_ACT_GeneralObject_route0, randomRock)
                clickedRockId = randomRock.Id
                clickedRockTile = randomRock.Tile_XYZ
            end
        end
    end

    API.RandomSleep2(1000, 1000, 2000)
end
