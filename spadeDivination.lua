--[[
@title Spade Divination
@author Spade

* If using divine-o-matic, equip the vacuum and add it anywhere in your action bar. Keep empty charges in inventory.
* Start script near wisps you'd like to harvest.

Note: Set IGNORE_FRAGMENTS if you want to ignore fragments, and set EMPOWER_RIFT based on how you'd like to use fragments.
--]]

local API = require("api")

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
local IGNORE_FRAGMENTS = true
local EMPOWER_RIFT = true   -- If false, chronicle fragments will be offered from inv instead of used to empower rift
local FRAGMENT_IDS = {29293, 51489}
local RIFT_IDS = { 93489, 87306 }
local EMPTY_CHARGE = 41073
local VACUUM_ID = 41083

local selectedWisp = nil
local selectedSpring = nil
local enrichedWisp = nil
local enrichedSpring = nil
local harvestingEnriched = false

API.SetMaxIdleTime(MAX_IDLE_TIME_MINUTES)

local function doRandomEvents()
    local eventIDs = { 19884, 26022, 27228, 27297, 28411, 30599, 15451 }
    if not IGNORE_FRAGMENTS then
        table.insert(eventIDs, 18204)

        -- Add 18205 if you want to gather chronicle fragments from others
        -- table.insert(eventIDs, 18205)
    end

    if #API.GetAllObjArrayInteract(eventIDs, 30, {0, 1, 12}) <= 0 then
        return
    end

    API.RandomSleep2(1000, 2000, 2000)
    API.DoAction_NPC(0x29, API.OFF_ACT_InteractNPC_route, eventIDs, 50)
    API.RandomSleep2(500, 1000, 1000)
end

local fullInvInterface = {
    InterfaceComp5.new(1186, 2, -1, 0),
}

local function fullInvInterfacePresent()
    return #API.ScanForInterfaceTest2Get(true, fullInvInterface) > 0
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
    local wispObjs = API.GetAllObjArrayInteract({ wispId }, 50, {0, 1, 12})
    local springObjs = API.GetAllObjArrayInteract({ springId }, 50, {0, 1, 12})
    if #springObjs > 0 then
        API.DoAction_NPC__Direct(0xc8, API.OFF_ACT_InteractNPC_route, springObjs[math.random(1, #springObjs)])
        return true
    elseif #wispObjs > 0 then
        API.DoAction_NPC__Direct(0xc8, API.OFF_ACT_InteractNPC_route, wispObjs[math.random(1, #wispObjs)])
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

        while (API.CheckAnim(75) or API.ReadPlayerMovin2()) do
            API.RandomSleep2(500, 250, 500)
        end
    end

    print("Adding energy to rift")
    API.DoAction_Object1(0xc8, API.OFF_ACT_GeneralObject_route0, RIFT_IDS, 50)
end

local function rechargeVacuum()
    if API.InvItemcount_1(EMPTY_CHARGE) <= 0 then
        return
    end

    local vacuumContainer = API.Container_Get_all(94)[4]
    if vacuumContainer.item_id ~= VACUUM_ID then
        return
    end

    local vacuumCharge = vacuumContainer.Extra_ints[2] & 0x7F
    if vacuumCharge <= math.random(1, 5) then
        print("Recharging vacuum!")

        -- Withdraw from vacuum
        -- API.DoAction_Interface(0xffffffff,0xa07b,4,1430,90,-1,API.OFF_ACT_GeneralInterface_route)
        API.DoAction_Ability("Divine-o-matic vacuum", 4, API.OFF_ACT_GeneralInterface_route)
        API.RandomSleep2(500, 500, 500)

        -- Add all empty charges to vacuum
        API.DoAction_Inventory1(EMPTY_CHARGE, 0, 3, API.OFF_ACT_GeneralInterface_route)
        API.RandomSleep2(500, 500, 500)
    end
end

local function handleElidinisEvents()
    local lostSoul = 17720
    local unstableSoul = 17739
    local mimickingSoul = 18222
    local eventIDs = { lostSoul, unstableSoul, mimickingSoul }

    local found = false
    local eventObjs = API.GetAllObjArray1(eventIDs, 50, { 1 })
    if #eventObjs > 0 then
        print("Elidinis soul detected!")
        found = true
    end

    local originTile = API.PlayerCoordfloat()
    while #eventObjs > 0 and API.Read_LoopyLoop() do
        if eventObjs[1].Id == mimickingSoul then
            API.DoAction_TileF(eventObjs[1].Tile_XYZ)
        elseif eventObjs[1].Id == unstableSoul or eventObjs[1].Id == lostSoul then
            -- API.DoAction_NPC(0x29, API.OFF_ACT_InteractNPC_route, { eventObjs[1].Id }, 50)
            API.DoAction_NPC__Direct(0x29, API.OFF_ACT_InteractNPC_route, eventObjs[1])
        end

        API.RandomSleep2(1000, 250, 500)
        eventObjs = API.GetAllObjArray1(eventIDs, 50, { 1 })
    end

    if found then API.DoAction_TileF(originTile) end
end

for _, v in ipairs(wispOptions) do
    if #API.GetAllObjArray1({ v.ids.wisp, v.ids.spring }, 50, { 0, 1, 12 }) > 0 then
        selectedWisp = v.ids.wisp
        selectedSpring = v.ids.spring
        enrichedWisp = v.ids.enriched_wisp
        enrichedSpring = v.ids.enriched_spring

        print("Harvesting " .. v.label)
        break
    end
end

if not selectedWisp then
    print("Please start near wisps!")
    API.Write_LoopyLoop(false)
end

while API.Read_LoopyLoop() do
    if API.GetGameState2() ~= 3 or not API.PlayerLoggedIn() then
        print("Bad game state, exiting.")
        break
    end

    doRandomEvents()
    handleElidinisEvents()
    rechargeVacuum()

    if selectedWisp ~= nil then
        if fullInvInterfacePresent() then
            print("Closing full inventory interface")

            -- Press space to close full inventory interface
            API.KeyboardPress32(0x20,0)
            API.RandomSleep2(1000, 500, 750)
        end

        if API.InvFull_() and not (API.CheckAnim(75) or API.ReadPlayerMovin2()) then
            useEnergy()
        else
            getEnergy()
        end
    end

    API.RandomSleep2(1000, 500, 2000)
end