local API = require("api")
local MAX_IDLE_TIME_MINUTES = 10

API.SetDrawTrackedSkills(true)
API.SetMaxIdleTime(MAX_IDLE_TIME_MINUTES)

local PRAYER_SWITCH = false
local ARCH_GLACOR = 28241
local MAGIC_ANIMS = {34272, 34273}
local RANGE_ANIMS = {34274, 34275}

local LOOT = { 1445, 1396, 52122, 1632, 52018, 51817, 990, 51809, 31867, 29863, 32821, 42954, 44813, 42009, 28550 }
local PRAYER_POTS = { 143, 141, 139, 2434 }

local ABILITIES = {
    SOUL_SPLIT = {"Soul Split", 26033},
    DEFLECT_MAGIC = {"Deflect Magic", 26041},
    DEFLECT_RANGED = {"Deflect Ranged", 26044}
}

local function getPrayerPot()
    for _, pot in ipairs(PRAYER_POTS) do
        if API.InvItemcount_1(pot) > 0 then
            return pot
        end
    end

    return nil
end

local function maintainPrayer()
    if API.GetPrayPrecent() > 20 then
        return
    end

    -- TODO: Add support for prayer shard

    local pot = getPrayerPot()
    if pot then
        print("Taking prayer pot!")
        API.DoAction_Inventory1(pot, 0, 1, API.OFF_ACT_GeneralInterface_route)
        API.RandomSleep2(500, 250, 500)
    end
end

local function maintainHealth()
    if API.GetHPrecent() > 50 then
        return
    end

    if API.DoAction_Ability_check("Eat Food", 1, API.OFF_ACT_GeneralInterface_route, true, true) then
        API.RandomSleep2(500, 250, 500)
    else
        API.DoAction_Ability("Retreat Teleport", 1, API.OFF_ACT_GeneralInterface_route)
        API.Write_LoopyLoop(false)
    end
end

while API.Read_LoopyLoop() do
    if API.GetGameState2() ~= 3 or not API.PlayerLoggedIn() then
        print("Bad game state, exiting.")
        break
    end

    local archGlacor = API.GetAllObjArray1({ ARCH_GLACOR }, 50, { 1 })[1]
    if archGlacor then
        if archGlacor.Life > 0 and API.ReadTargetInfo(true).Target_Name ~= "Arch-Glacor" then
            API.DoAction_NPC(0x2a, API.OFF_ACT_AttackNPC_route, { ARCH_GLACOR }, 50)
        end

        local ability = nil
        if PRAYER_SWITCH then
            if archGlacor.Anim == MAGIC_ANIMS[1] or archGlacor.Anim == MAGIC_ANIMS[2] then
                ability = ABILITIES.DEFLECT_MAGIC
            elseif archGlacor.Anim == RANGE_ANIMS[1] or archGlacor.Anim == RANGE_ANIMS[2] then
                ability = ABILITIES.DEFLECT_RANGED
            end
        end

        if not ability then
            ability = ABILITIES.SOUL_SPLIT
        end

        if not API.Buffbar_GetIDstatus(ability[2], false).found then
            print("Activating " .. ability[1])
            API.RandomSleep2(500, 250, 250)
            API.DoAction_Ability(ability[1], 1, API.OFF_ACT_GeneralInterface_route)
            API.RandomSleep2(500, 250, 250)
        end
    else
        if API.Buffbar_GetIDstatus(ABILITIES.SOUL_SPLIT[2], false).found then
            print("Deactivating soul split!")
            API.DoAction_Ability(ABILITIES.SOUL_SPLIT[1], 1, API.OFF_ACT_GeneralInterface_route)
        end

        if #API.GetAllObjArray1(LOOT, 50, { 3 }) > 0 then
            API.DoAction_Loot_w(LOOT, 50, API.PlayerCoordfloat(), 25)
        end
    end

    maintainPrayer()
    maintainHealth()

    API.RandomSleep2(500, 500, 500)
end