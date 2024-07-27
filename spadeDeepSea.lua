--[[
@title Deep Sea Fisher
@author Spade

* Create bank preset with your fishing gear and load it
* Start script near the fish you want to catch
--]]

local API = require("api")

local MAX_IDLE_TIME_MINUTES = 10
local FISHING_NOTE = 42286

API.SetDrawTrackedSkills(true)
API.SetMaxIdleTime(MAX_IDLE_TIME_MINUTES)

TARGET_FISH = { API.ScriptDialogWindow2("Fish to catch", {"Minnow shoal", "Swarm", "Green blubber jellyfish", "Blue blubber jellyfish", "Sailfish", "Fishing Frenzy"}, "Start", "Close").Name }
if TARGET_FISH[1] == "Fishing Frenzy" then
    TARGET_FISH = {"Fish", "Calm fish", "Frenzy fish"}
end

local function getClosestObj(objVect)
    local closestObj, smallestDist = nil, nil
    for _, obj in ipairs(objVect) do
        local dist = API.Dist_FLP(obj.Tile_XYZ)
        if smallestDist == nil or dist < smallestDist then
            smallestDist = dist
            closestObj = obj
        end
    end

    return closestObj
end

local function bank()
    local banks = API.GetAllObjArrayInteract_str({ "Bank boat", "Magical net" }, 50, { 0, 12 })
    local chosenBank = getClosestObj(banks)
    if not chosenBank then
        print("Failed to find a bank boat or magical net nearby!")
        return false
    end

    if chosenBank.Name == "Bank boat" then
        API.DoAction_Object_Direct(0x33, API.OFF_ACT_GeneralObject_route3, chosenBank)
    else
        API.DoAction_Object_Direct(0x29, API.OFF_ACT_GeneralObject_route2, chosenBank)
    end

    API.RandomSleep2(1000, 250, 500)
    return true
end

local function chooseFish()
    for _, dist in ipairs({15, 30}) do
        local fish = API.GetAllObjArrayInteract_str(TARGET_FISH, dist, { 1 })
        if #fish > 0 then
            return fish[math.random(1, #fish)]
        end
    end

    return nil
end

local function redeemFishingNotes()
    while API.InvItemcount_1(FISHING_NOTE) > 0 do
        API.DoAction_Inventory1(FISHING_NOTE, 0, 1, API.OFF_ACT_GeneralInterface_route)
        API.RandomSleep2(1000, 250, 500)
        API.DoAction_Interface(0xffffffff, 0xffffffff, 0, 847, 22, -1, API.OFF_ACT_GeneralInterface_Choose_option)
    end
end

state = 1
local STATES = {
    {
        desc = "Redeeming fishing notes",
        pre = function() return API.InvItemcount_1(FISHING_NOTE) > 0 end,
        callback = function() redeemFishingNotes() return true end
    },
    {
        desc = "Banking",
        pre = function() return API.InvFull_() end,
        callback = function() return bank() end
    },
    {
        desc = string.format("Catching %s", TARGET_FISH[1]),
        pre = function() return (chooseFish() ~= nil) end,
        callback = function() API.DoAction_NPC__Direct(0x3c, API.OFF_ACT_InteractNPC_route, chooseFish()) return true end
    }
}

if not chooseFish() then
    print("Please start near fish in deep sea hub!")
    API.Write_LoopyLoop(false)
end

while API.Read_LoopyLoop() do
    API.DoRandomEvents()

    if (not (API.CheckAnim(25) or API.ReadPlayerMovin2() or API.isProcessing())) or API.DeBuffbar_GetIDstatus(33045, false).conv_text > 0 then
        local timeout = os.time() + 30
        if STATES[state].pre and not STATES[state].pre() then
            goto continue
        end

        print("State: " .. STATES[state].desc)
        if not STATES[state].callback() then
            break
        end

        while API.DeBuffbar_GetIDstatus(33045, false).conv_text > 0 and API.Read_LoopyLoop() and os.time() < timeout do
            API.RandomSleep(1000, 0, 0)
        end

        ::continue::
        state = (state % #STATES) + 1
    end

    API.RandomSleep2(500, 500, 1000)
end