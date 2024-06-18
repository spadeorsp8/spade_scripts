API = require('api')
UTILS = require("utils")
COLORS = require("colors")

API.SetDrawTrackedSkills(true)

-- IDs as tested with 22 flowers in each basket before starting script
local plainWhirlis = {28722, 28726}
local fancyWhirlis = {28719, 28720, 28723, 28724, 28725}
local allWhirliIDs = {28719, 28720, 28722, 28723, 28724, 28725, 28726}
local flowerStages = { }
local basketId = 0
local flowerId = 0
local ultraCompostId = 43966
local threatScarab = 28671
local unhandledFrito = 28665
local useFlowers = false
local fertilized = false
local actualFlowerStage = 0
local maxStack = 5
local targetBasketLevel = 25

local fritoVBId = 10338

-- VB value of Frito before handling him
local unhandledFritoState = 112347

-- VB value of Frito after handling, but before giving him orders
local idleFritoState = 374491

local Cselect =
    API.ScriptDialogWindow2(
    "Whirligig",
    {"Catch Whirligigs", "Cultivate Flowers"},
    "Start",
    "Close"
).Name

local function getBasketQuantity()
    local flowerBasketVB = API.VB_FindPSett(10330).state
    local flowerQuant64 = flowerBasketVB >> 18 & 0xfff
    return flowerQuant64 / 64
end

local function getBasketQuantity2()
    local flowerBasket2VB = API.VB_FindPSett(10331).state
    local mask = 0xFFFFFFFF >> 26
    local flowerBasketCleared = flowerBasket2VB & mask
    return flowerBasketCleared
end

afk = os.time()
local MAX_IDLE_TIME_MINUTES = 10
local function idleCheck()
    local timeDiff = os.difftime(os.time(), afk)
    local randomTime = math.random((MAX_IDLE_TIME_MINUTES * 60) * 0.6, (MAX_IDLE_TIME_MINUTES * 60) * 0.9)

    if timeDiff > randomTime then
        API.PIdle2()
        afk = os.time()
    end
end

local function findNpcOrObject(npcid, distance, objType)
    local distance = distance or 20

    return #API.GetAllObjArray1({ npcid }, distance, { objType }) > 0
end

local function run_to_tile(x, y, z)
    local tile = WPOINT.new(x, y, z)
    API.DoAction_Tile(tile)
    while API.Read_LoopyLoop() and API.Math_DistanceW(API.PlayerCoord(), tile) > 5 do
        API.RandomSleep2(100, 200, 200)
    end
end

local function randomWalk()
    local randomW = math.random(1,40)
    if randomW == 5 then
        print ("Random walking")
        run_to_tile(3378+math.random(1, 4), 3207+math.random(1, 8), 0)
    end
end

local function fillBaskets()
    local basketQuantity = getBasketQuantity()

    if basketQuantity == 0 then
        print("Please put at least one flower in each basket and restart the script.")
        API.Write_LoopyLoop(false)
        return
    elseif basketQuantity <= targetBasketLevel then
        print ("Time to refill basket, basket quantity: " .. basketQuantity)
        run_to_tile(3383 + math.random(-1,0), 3213 + math.random(-1,0), 0)
        UTILS.randomSleep(5000)

        print("Filling all flowers in basket 1")
        API.DoAction_Object1(0x29, API.OFF_ACT_GeneralObject_route3, { basketId }, 50)
        UTILS.randomSleep(1500)

        API.WaitUntilMovingEnds()
        print("Flowers refilled")
    end

    basketQuantity = getBasketQuantity2()
    if basketQuantity <= targetBasketLevel then
        print ("Time to refill basket 2, basket quantity: " .. basketQuantity)
        run_to_tile(3376 + math.random(0,1), 3206 + math.random(-1,1), 0)
        UTILS.randomSleep(5000)

        print("Filling all flowers in basket 2")
        API.DoAction_Object1(0x29, API.OFF_ACT_GeneralObject_route3, { basketId }, 50)
        UTILS.randomSleep(1500)

        API.WaitUntilMovingEnds()
        print("Flowers refilled")
    end
end

local function checkForThreats()
    if findNpcOrObject(7620, 10, 4) then
        print("Nutritous gas inbound.")

        API.DoAction_Object1(0x5, API.OFF_ACT_GeneralObject_route0, { actualFlowerStage }, 50)
        UTILS.randomSleep(1000)

        print("Threats clear")
    end

    if findNpcOrObject(threatScarab, 10, 1) then
        print("Pasty Scarab found! Shoo away")

        API.DoAction_NPC(0x29, API.OFF_ACT_InteractNPC_route, { threatScarab }, 50)
        UTILS.randomSleep(1000)

        print("Threats clear")
    end
    UTILS.randomSleep(1500)
end

local function cultivateFlowers()
    if not API.CheckAnim(100) then
        for i in ipairs(flowerStages) do
            if findNpcOrObject(flowerStages[i], 5, 0) then
                print("Found current flower stage!", flowerStages[i])

                if i == 1 then
                    -- Add Ultracompost if you have it
                    if API.InvItemcount_1(ultraCompostId) > 0 and not fertilized then
                        print("Adding compost to flowers")
                        API.DoAction_Inventory1(ultraCompostId, 0, 0, API.OFF_ACT_Bladed_interface_route)
                        UTILS.randomSleep(500)
                        API.DoAction_Object1(0x24, API.OFF_ACT_GeneralObject_route00, { flowerStages[i] }, 15)
                        UTILS.randomSleep(1000)
                        fertilized = true
                    end
                else
                    fertilized = false
                end

                if flowerStages[i] ~= actualFlowerStage then
                    actualFlowerStage = flowerStages[i]
                end

                API.DoAction_Object1(0x5, API.OFF_ACT_GeneralObject_route0, { flowerStages[i] }, 50)
                break
            end
        end
    end

    checkForThreats()
end

local function getFritoState()
    return (API.VB_FindPSett(fritoVBId).state)
end

local function shuffle(table)
    local length = #table

    for i = length, 2, -1 do
        local j = math.random(i)
        table[i], table[j] = table[j], table[i]
    end
end

eventIgnoreEndTime = os.time()

---@param ignoreChance (int): percentage chance events are ignored for the length of ignoreTimeout
---@param ignoreTimeout (int): number of seconds that events will be ignored 
---@return boolean
local function doRandomEvents(ignoreChance, ignoreTimeout)
    local ignoreChance = ignoreChance or 0
    local ignoreTimeout = ignoreTimeout or 0
    local eventIDs = { 19884, 26022, 27228, 27297, 28411, 30599, 15451 }

    for _, id in ipairs(eventIDs) do
        if #API.GetAllObjArray1({ id }, 30, { 0, 1, 12 }) > 0 then
            if os.time() < eventIgnoreEndTime then
                -- If we're currently ignoring events, return early
                return false
            end

            if math.random(100) > (100 - ignoreChance) then
                print(string.format("Ignoring events for the next %d seconds", ignoreTimeout))
                eventIgnoreEndTime = os.time() + ignoreTimeout
                return false
            end

            print("Clicking event! ID: " .. id)
            UTILS.randomSleep(800, 0, 400)
            if API.DoAction_NPC(0x29, API.OFF_ACT_InteractNPC_route, { id }, 30) then
                UTILS.randomSleep(800,0,400)
                return true
            end
        end
    end

    return false
end

local function catchWhirlis()
    local lastTargetId = 0
    local targetWhirlis = allWhirliIDs

    while API.Read_LoopyLoop() do
        doRandomEvents()
        idleCheck()

        local fritoState = getFritoState()
        local sleep = 500

        if useFlowers then
            if API.InvItemcount_1(flowerId) > 0 then
                fillBaskets()
            else
                print("No more flowers!")
                break
            end
        else
            if fritoState == idleFritoState then
                -- If we don't want to use flowers, target plain whirligig before stacking
                print("Frito is ready for new orders.")
                targetWhirlis = plainWhirlis
            else
                targetWhirlis = fancyWhirlis
                sleep = 250
            end
        end

        local whirliObjs = API.GetAllObjArrayInteract(targetWhirlis, 30, {1})
        if #whirliObjs > 0 then
            if API.Buffbar_GetIDstatus(52770).conv_text < maxStack then
                local idx = math.random(1, #whirliObjs)

                fritoState = getFritoState()
                local fritoState2 = API.VB_FindPSett(10340).state
                if targetWhirlis ~= fancyWhirlis or (targetWhirlis == fancyWhirlis and (fritoState2 < 100000 and fritoState >= 800000)) then
                    API.DoAction_NPC__Direct(0x29, API.OFF_ACT_InteractNPC_route, whirliObjs[idx])
                end
            else
                print("Stack is full, waiting for frito to return")
            end
        end

        randomWalk()
        UTILS.randomSleep(sleep)
    end
end

local function handleFrito()
    local fritoState = getFritoState()

    if fritoState == unhandledFritoState then
        if API.DoAction_NPC(0x29, API.OFF_ACT_InteractNPC_route, { unhandledFrito }, 50) then
            print("Frito is now your pet.")
            UTILS.randomSleep(1000)
        else
            return false
        end
    elseif fritoState == idleFritoState then
        print("Frito is already your pet.")
    else
        print("Frito is in an invalid starting state.")
        return false
    end

    return true
end

if Cselect == "Catch Whirligigs" then
    local Ccheck = API.ScriptDialogWindow2("Flower basket?", {"Roses", "Iris", "Hydrangea", "None"}, "Start", "Close").Name
    if Ccheck == "Roses" then
        useFlowers = true
        basketId = 122495
        flowerId = 52807
    elseif Ccheck == "Iris" then
        useFlowers = true
        basketId = 122496
        flowerId = 52808
    elseif Ccheck == "Hydrangea" then
        useFlowers = true
        basketId = 122497
        flowerId = 52809
    end

    if handleFrito() then
        catchWhirlis()
    end
end

if Cselect == "Cultivate Flowers" then
    local pickedFlower = API.ScriptDialogWindow2("Flower type", {"Roses", "Iris", "Hydrangea"}, "Start", "Close").Name
    if pickedFlower == "Roses" then
        flowerStages = {122504, 122505, 122506, 122507 }
    end
    if pickedFlower == "Iris" then
        flowerStages = {122508, 122509, 122510, 122511 }
    end
    if pickedFlower == "Hydrangea" then
        flowerStages = {122512, 122513, 122514, 122515 }
    end

    while API.Read_LoopyLoop() do
        doRandomEvents(20, 45)
        idleCheck()
        cultivateFlowers()
    end
end
