--[[
@title Spade Smither
@author Spade

NOTE: Please make sure you have enough bars in storage to make the items you select. I do not check storage reserves yet.

* Start script near Fort Forinthry workshop (with powerburst and perfect juju smithing potions in your inventory if you want).
* Select:
    * Bar type
    * Item
    * Goal item level: base through +5 depending on the item; burial is not supported at the Fort
    * Starting item level: item level to start smithing at. Examples:
        * Starting from scratch: choose "BAR"
        * Starting from existing items in your inventory: choose the lowest level of the item(s)/unfinished item(s) in your inventory.
    * Quantity: quantity of the item at goal level that you want to exist by the end of the script.
        * NOTE: If you start with items in your inventory that are already at your goal level, they must be included in this quantity value.
        * NOTE: For stackable items that create multiples per bar, this is the number of bars you want to use.
            * Ex. Dart tips produce x50 per bar. For 100 dart tips, enter '2' for quantity.
--]]

local API = require("api")
local TYPES = require("smithingTypes")
local MAX_IDLE_TIME_MINUTES = 10

API.SetDrawTrackedSkills(true)
API.SetMaxIdleTime(MAX_IDLE_TIME_MINUTES)

local UNFINISHED_ITEM = 47068
local FORGE = 125136
local ANVIL = 125135
local BANK = 125115

local OPTIONS = TYPES.options
local ITEM_LEVELS = TYPES.itemLevels
local BUFFS = TYPES.buffs

local backlogCount = 0

local SMITHING_IFACE = {
    InterfaceComp5.new(37, 17, -1, -1, 0),
    InterfaceComp5.new(37, 18, -1, 17, 0)
}

local function smithingInterfacePresent()
    return #API.ScanForInterfaceTest2Get(true, SMITHING_IFACE) > 0
end

local function takePots()
    for name, buff in pairs(BUFFS) do
        if (buff.buffId and not API.Buffbar_GetIDstatus(buff.buffId).found) or 
            (buff.debuffId and not API.DeBuffbar_GetIDstatus(buff.debuffId).found) then
            for _, pot in ipairs(buff.potionIds) do
                if API.InvItemcount_1(pot) > 0 then
                    print(string.format("Drinking %s potion!", name))
                    API.DoAction_Inventory1(pot, 0, 1, API.OFF_ACT_GeneralInterface_route)
                    API.RandomSleep2(500, 500, 750)
                    break
                end
            end
        end
    end
end

local function valueInTable(val, tbl)
    for _, v in ipairs(tbl) do
        if val == v then
            return true
        end
    end

    return false
end

local function getOptionSelection(option_string, tbl)
    local options = {}
    for k, _ in pairs(tbl) do
        local option = string.gsub(k, "_", " ")
        table.insert(options, option)
    end

    table.sort(options)

    local selection = string.upper(API.ScriptDialogWindow2(option_string, options, "Start", "Close").Name)
    return string.gsub(selection, " ", "_")
end

local function atFullHeat()
    local chatTexts = API.GatherEvents_chat_check()
    for _, v in ipairs(chatTexts) do
        if (string.find(v.text, "Your unfinished item is at full heat")) then
            return true
        end
    end

    return false
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

local function heatItem()
    API.DoAction_Object1(0x3f, API.OFF_ACT_GeneralObject_route0, { FORGE }, 15)

    local timeout = os.time() + 10
    while not atFullHeat() and API.Read_LoopyLoop() and os.time() < timeout do
        API.RandomSleep2(1000, 1500, 2000)
    end
end

-- Bar Choice
local BAR_SELECTION = getOptionSelection("Bar Category", OPTIONS)
if not OPTIONS[BAR_SELECTION] then
    return
end

-- Item Choice
local ITEM_SELECTION = getOptionSelection("Item", OPTIONS[BAR_SELECTION].items)
if not OPTIONS[BAR_SELECTION].items[ITEM_SELECTION] then
    return
end

-- Goal Level Choice
local GOAL_LEVEL = "BASE"
if #OPTIONS[BAR_SELECTION].items[ITEM_SELECTION].levels > 1 then
    GOAL_LEVEL = API.ScriptDialogWindow2("Goal Item Level", OPTIONS[BAR_SELECTION].items[ITEM_SELECTION].levels, "Start", "Close").Name
    if not valueInTable(GOAL_LEVEL, OPTIONS[BAR_SELECTION].items[ITEM_SELECTION].levels) then
        return
    end
end

-- Starting Level Choice
local STARTING_LEVEL = nil
if GOAL_LEVEL then
    local STARTING_LEVELS = {"BAR"}
    for _, v in ipairs(OPTIONS[BAR_SELECTION].items[ITEM_SELECTION].levels) do
        table.insert(STARTING_LEVELS, v)
    end

    STARTING_LEVEL = API.ScriptDialogWindow2("Starting Item Level", STARTING_LEVELS, "Start", "Close").Name
    if not valueInTable(STARTING_LEVEL, STARTING_LEVELS) then
        return
    end
    if STARTING_LEVEL == "BAR" then STARTING_LEVEL = nil end
end

-- Quantity Choice
local quantity = tonumber(API.ScriptAskBox("Quantity of Items:", false)[1])
if quantity <= 0 then
    print("Please enter a positive quantity!")
    return
end

-- Returns the number of items to forge when accounting for pre-existing items in inventory
local function getItemsToMake(level)
    local item = OPTIONS[BAR_SELECTION].items[ITEM_SELECTION]
    local itemsToMake = (quantity - API.InvItemcount_1(UNFINISHED_ITEM))
    if level == 0 or item.stack then
        return itemsToMake
    end

    local finishedItemName = string.lower(ITEM_SELECTION)
    finishedItemName = string.gsub(finishedItemName, "_", " ")
    if finishedItemName == "two handed sword" then finishedItemName = "2h sword" end

    -- Take any existing items from future levels into account
    for lvl = ITEM_LEVELS[GOAL_LEVEL][1], level, -1 do
        local tempItemName = finishedItemName
        if lvl > 1 then
            if lvl == 7 then
                tempItemName = string.format("burial %s", finishedItemName)
            else
                tempItemName = string.format("%s %%+ %d", finishedItemName, lvl - 1)
            end
        end

        for _, v in ipairs(API.ReadInvArrays33()) do
            if string.find(v.textitem, tempItemName .. "$") then
                itemsToMake = itemsToMake - 1
            end
        end
    end

    return itemsToMake
end

local STARTING_LEVEL_IDX = 0
if STARTING_LEVEL then
    if ITEM_LEVELS[STARTING_LEVEL][1] > ITEM_LEVELS[GOAL_LEVEL][1] then
        print("Starting level must be <= goal level!")
        return
    end

    STARTING_LEVEL_IDX = ITEM_LEVELS[STARTING_LEVEL][1]
end

local currentLevelIdx = STARTING_LEVEL_IDX

--[[ TODO: Remove this
    * For non-stacking: (quantity - getItemsToMake(currentLevelIdx + 1)) = pre-made items in inventory
    * First inventory items made = (pre-made items) + API.Invfreecount_()
    * backlogCount = quantity - (first inventory items made)
    * quantity = first inventory items made
]]

local function updateBacklog()
    if getItemsToMake(currentLevelIdx + 1) > API.Invfreecount_() then
        -- Backlog count excludes pre-made items in inventory and free inventory space
        backlogCount = getItemsToMake(currentLevelIdx + 1) - API.Invfreecount_()
        quantity = quantity - backlogCount
        print(string.format("Backlog: %d, Current Quantity: %d", backlogCount, quantity))
    end
end

local function makeUnfinishedItems()
    local bar = OPTIONS[BAR_SELECTION].bar
    local item = OPTIONS[BAR_SELECTION].items[ITEM_SELECTION]
    local unfinishedItemCount = API.InvItemcount_1(UNFINISHED_ITEM)

    if currentLevelIdx >= ITEM_LEVELS[GOAL_LEVEL][1] then        
        if backlogCount > 0 then
            if not item.stack then
                print("Loading bank preset")

                API.DoAction_Object1(0x33, API.OFF_ACT_GeneralObject_route3, { BANK }, 20)
                API.RandomSleep2(1000, 500, 1000)
                while (API.CheckAnim(50) or API.ReadPlayerMovin2()) and API.Read_LoopyLoop() do
                    API.RandomSleep2()
                end
            end

            quantity = backlogCount
            updateBacklog()

            -- TODO: Could we get rid of the starting level idx argument altogether since we skip levels that have 0 items to make now?
            -- TODO: i.e. always start at level 1 and allow it to skip to the proper level
            currentLevelIdx = STARTING_LEVEL_IDX
        else
            API.Write_LoopyLoop(false)
            return
        end
    end
    currentLevelIdx = currentLevelIdx + 1

    local itemsToMake = getItemsToMake(currentLevelIdx)
    if itemsToMake < 0 then
        print("Please enter a quantity that includes any complete items in your inventory!")
        API.Write_LoopyLoop(false)
        return
    elseif itemsToMake == 0 then
        print(string.format("Skipping level %d!", currentLevelIdx))
        makeUnfinishedItems()
        return
    end

    -- Open interface differently based on whether we have unfinished items in inventory or not
    if not smithingInterfacePresent() then
        if unfinishedItemCount <= 0 then
            API.DoAction_Object1(0x3f, API.OFF_ACT_GeneralObject_route0, { FORGE }, 50)
        else
            API.DoAction_Object1(0x29, API.OFF_ACT_GeneralObject_route3, { FORGE }, 50)
        end
    end

    -- Wait for interface to open
    while not smithingInterfacePresent() and API.Read_LoopyLoop() do
        API.RandomSleep2(500, 250, 500)
    end

    -- Choose bar
    if API.VB_FindPSettinOrder(8332, -1).state ~= bar[4] then
        API.DoAction_Interface(0xffffffff, bar[1], 1, 37, bar[2], bar[3], API.OFF_ACT_GeneralInterface_route)
        API.RandomSleep2(1000, 250, 500)
    end

    -- Choose item
    if API.VB_FindPSettinOrder(8336, -1).state ~= item.id then
        API.DoAction_Interface(0xffffffff, item.id, 1, 37, item.ifidx[1], item.ifidx[2], API.OFF_ACT_GeneralInterface_route)
        API.RandomSleep2(1000, 250, 500)
    end

    -- Choose level
    local currentSelectedLevel = ((API.VB_FindPSettinOrder(8329, -1).state - 4) / 4096) + 1
    if currentSelectedLevel == 51 then
        -- Burial value is stored differently from the rest
        currentSelectedLevel = 7
    end

    if currentSelectedLevel ~= currentLevelIdx then
        local levelIfIdx = nil
        for k, _ in pairs(ITEM_LEVELS) do
            if ITEM_LEVELS[k][1] == currentLevelIdx then
                levelIfIdx = ITEM_LEVELS[k][2]
                break
            end
        end

        if levelIfIdx then
            API.DoAction_Interface(0x24, 0xffffffff, 1, 37, levelIfIdx, -1, API.OFF_ACT_GeneralInterface_route)
            API.RandomSleep2(1000, 250, 500)
        end
    end

    -- Choose quantity
    local currentQuantity = API.VB_FindPSettinOrder(8336, -1).state
    local quantityDelta = itemsToMake - currentQuantity
    for i = 1, math.abs(quantityDelta) do
        if quantityDelta > 0 then
            API.DoAction_Interface(0xffffffff, 0xffffffff, 1, 37, 34, 7, API.OFF_ACT_GeneralInterface_route)
        else
            API.DoAction_Interface(0xffffffff, 0xffffffff, 1, 37, 34, 0, API.OFF_ACT_GeneralInterface_route)
        end
        
        API.RandomSleep2(250, 250, 500)
    end

    -- Press space to confirm
    API.RandomSleep2(500, 250, 500)
    API.KeyboardPress32(0x20, 0)
    API.RandomSleep2(1000, 250, 500)
end

local function smithItem()
    takePots()
    API.DoAction_Object1(0x3f, API.OFF_ACT_GeneralObject_route0, { ANVIL }, 50)
end

local state = 1
local previousState = nil
local STATES = {
    {
        desc = "Making unfinished items",
        pre = function() return not API.CheckAnim(50) and API.InvItemcount_1(UNFINISHED_ITEM) <= 0 end,
        callback = makeUnfinishedItems
    },
    {
        desc = "Smithing item",
        pre = function() return not API.CheckAnim(25) and API.InvItemcount_1(UNFINISHED_ITEM) > 0 end,
        callback = smithItem
    },
    {
        desc = "Heating item",
        pre = function() return API.InvItemcount_1(UNFINISHED_ITEM) > 0 and getProgress(5) < 150 and API.CheckAnim(50) end,
        callback = heatItem
    },
}

updateBacklog()

print(string.format("%s %s (%d)", BAR_SELECTION, ITEM_SELECTION, quantity))
if STARTING_LEVEL then print(string.format("Starting item level = %s", STARTING_LEVEL)) end
if GOAL_LEVEL then print(string.format("Goal item level = %s", GOAL_LEVEL)) end

if #API.GetAllObjArray1({ FORGE, ANVIL }, 50, { 0 }) <= 0 then
    print("Please start near the Fort Forinthry workshop!")
    return
end

while API.Read_LoopyLoop() do
    if API.GetGameState2() ~= 3 or not API.PlayerLoggedIn() then
        print("Bad game state, exiting.")
        break
    end

    API.DoRandomEvents()

    if state ~= previousState and STATES[state].pre and STATES[state].pre() then
        print("State: " .. STATES[state].desc)
        STATES[state].callback()
        previousState = state
    end

    state = (state % #STATES) + 1
    API.RandomSleep2(1000, 250, 500)
end
