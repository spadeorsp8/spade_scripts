local API = require("api")
local UTILS = require("utils")

API.SetDrawTrackedSkills(true)

local wispOptions = {
    {
        label = "Pale Wisps",
        ids = {
            wisp = 18150,
            spring = 18173,
            enriched_wisp = nil,
            enriched_spring = nil
        }
    },
    {
        label = "Flickering Wisps",
        ids = {
            wisp = 18151,
            spring = 18174,
            enriched_wisp = 18152,
            enriched_spring = 18175
        }
    },
    {
        label = "Bright Wisps",
        ids = {
            wisp = 18153,
            spring = 18176,
            enriched_wisp = 18154,
            enriched_spring = 18177
        }
    },
    {
        label = "Glowing Wisps",
        ids = {
            wisp = 18155,
            spring = 18178,
            enriched_wisp = 18156,
            enriched_spring = 18179
        }
    },
    {
        label = "Sparkling Wisps",
        ids = {
            wisp = 18157,
            spring = 18180,
            enriched_wisp = 18158,
            enriched_spring = 18181
        }
    },
    {
        label = "Gleaming Wisps",
        ids = {
            wisp = 18159,
            spring = 18182,
            enriched_wisp = 18160,
            enriched_spring = 18183
        }
    },
    {
        label = "Vibrant Wisps",
        ids = {
            wisp = 18161,
            spring = 18184,
            enriched_wisp = 18162,
            enriched_spring = 18185
        }
    },
    {
        label = "Lustrous Wisps",
        ids = {
            wisp = 18163,
            spring = 18186,
            enriched_wisp = 18164,
            enriched_spring = 18187
        }
    },
    {
        label = "Elder Wisps",
        ids = {
            wisp = 13614,
            spring = 13616,
            enriched_wisp = 13615,
            enriched_spring = 13617
        }
    },
    {
        label = "Brilliant Wisps",
        ids = {
            wisp = 18165,
            spring = 18188,
            enriched_wisp = 18166,
            enriched_spring = 18189
        }
    },
    {
        label = "Radiant Wisps",
        ids = {
            wisp = 18167,
            spring = 18190,
            enriched_wisp = 18168,
            enriched_spring = 18191
        }
    },
    {
        label = "Luminous Wisps",
        ids = {
            wisp = 18169,
            spring = 18192,
            enriched_wisp = 18170,
            enriched_spring = 18193
        }
    },
    {
        label = "Incandescent Wisps",
        ids = {
            wisp = 18171,
            spring = 18194,
            enriched_wisp = 18172,
            enriched_spring = 18195
        }
    }
}

local MAX_IDLE_TIME_MINUTES = 5
local EMPOWER_RIFT = true   -- If false, chronicle fragments will be offered from inv instead of used to empower rift
local FRAGMENT_IDS = {29293, 51489}
local RIFT_IDS = { 93489, 87306 }

local menu = API.CreateIG_answer()
local selectedWisp = nil
local selectedSpring = nil
local enrichedWisp = nil
local enrichedSpring = nil
local harvestingEnriched = false

API.SetMaxIdleTime(MAX_IDLE_TIME_MINUTES)

eventIgnoreEndTime = os.time()

---@param ignoreChance (int): percentage chance events are ignored for the length of ignoreTimeout
---@param ignoreTimeout (int): number of seconds that events will be ignored 
---@return boolean
local function doRandomEvents(ignoreChance, ignoreTimeout)
    local ignoreChance = ignoreChance or 0
    local ignoreTimeout = ignoreTimeout or 0
    local eventIDs = { 19884, 26022, 27228, 27297, 28411, 30599, 15451, 18204, 18205 }
    local eventObjs = API.GetAllObjArrayInteract(eventIDs, 30, {0, 1, 12})

    if #eventObjs <= 0 or os.time() < eventIgnoreEndTime then
        return false
    end

    if math.random(100) > (100 - ignoreChance) then
        print(string.format("Ignoring events for the next %d seconds", ignoreTimeout))
        eventIgnoreEndTime = os.time() + ignoreTimeout
        return false
    end

    print("Clicking random event!")
    UTILS.randomSleep(1000, 250, 500)
    if API.DoAction_NPC__Direct(0x29, API.OFF_ACT_InteractNPC_route, eventObjs[1]) then
        UTILS.randomSleep(500, 100, 250)
        return true
    end

    return false
end

local fullInvInterface = {
    InterfaceComp5.new(1186, 2, -1, -1, 0),
}

local function fullInvInterfacePresent()
    return #API.ScanForInterfaceTest2Get(true, fullInvInterface) > 0
end

local function setupMenu()
    menu.box_name = "Div Menu"
    menu.box_start = FFPOINT.new(1, 60, 0)
    menu.box_size = FFPOINT.new(440, 0, 0)
    menu.stringsArr = {}

    table.insert(menu.stringsArr, "Select an option")
    for _, v in ipairs(wispOptions) do
        table.insert(menu.stringsArr, v.label)
    end

    API.DrawComboBox(menu, false)
end

local function getInvFragment()
    for _, id in ipairs(FRAGMENT_IDS) do
        if API.InvItemcount_1(id) > 0 then
            return id
        end
    end

    return 0
end

local function harvest(wispId, springId)
    if springId and #API.GetAllObjArray1({ springId }, 50, { 1 }) > 0 then
        print("Harvesting spring " .. springId)
        API.DoAction_NPC(0xc8, API.OFF_ACT_InteractNPC_route, { springId }, 50)
        return true
    elseif wispId and #API.GetAllObjArray1({ wispId }, 50, { 1 }) > 0 then
        print("Harvesting wisp " .. wispId)
        API.DoAction_NPC(0xc8, API.OFF_ACT_InteractNPC_route, { wispId }, 50)
        return true
    end

    return false
end

local function getEnergy()
    if not harvestingEnriched or (harvestingEnriched and not (API.CheckAnim(50) or API.ReadPlayerMovin2())) then
        if harvest(enrichedWisp, enrichedSpring) then
            harvestingEnriched = true
            return
        end
    end

    local fragmentId = getInvFragment()
    if fragmentId ~= 0 and not EMPOWER_RIFT then
        API.DoAction_Inventory1(fragmentId, 0, 1, API.OFF_ACT_GeneralInterface_route)
        API.RandomSleep2(500, 250, 500)
    end

    if not (API.CheckAnim(50) or API.ReadPlayerMovin2()) then
        harvestingEnriched = false
        harvest(selectedWisp, selectedSpring)
    end
end

local function useEnergy()
    if getInvFragment() ~= 0 and EMPOWER_RIFT then
        API.DoAction_Object1(0x29, API.OFF_ACT_GeneralObject_route2, RIFT_IDS, 50)

        while (API.CheckAnim(50) or API.ReadPlayerMovin2()) do
            API.RandomSleep2(500, 250, 500)
        end
    end

    print("Adding energy to rift")
    API.DoAction_Object1(0xc8, API.OFF_ACT_GeneralObject_route0, RIFT_IDS, 50)
end

setupMenu()
while API.Read_LoopyLoop() do
    doRandomEvents()

    if (menu.return_click) then
        menu.return_click = false

        for _, v in ipairs(wispOptions) do
            if (menu.string_value == v.label) then
                selectedWisp = v.ids.wisp
                selectedSpring = v.ids.spring
                enrichedWisp = v.ids.enriched_wisp
                enrichedSpring = v.ids.enriched_spring
            end
        end
    end

    if selectedWisp ~= nil then
        if fullInvInterfacePresent() then
            print("Closing full inventory interface")

            -- Press space to close full inventory interface
            API.KeyboardPress32(0x20,0)
            API.RandomSleep2(1000, 500, 750)
        end

        if API.InvFull_() then
            useEnergy()
        else
            getEnergy()
        end
    end

    API.RandomSleep2(1000, 500, 2000)
end