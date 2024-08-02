--[[
@title Spade Disassembler
@author Spade

* Put noted items you'd like to disassemble in first inventory slot and Disassemble in the ability bar
* Start script
--]]

local API = require("api")
local MAX_IDLE_TIME_MINUTES = 10

API.SetDrawTrackedSkills(true)
API.SetMaxIdleTime(MAX_IDLE_TIME_MINUTES)

while API.Read_LoopyLoop() do
    API.DoRandomEvents()

    local item = API.ReadInvArrays33()[1].itemid1
    if item == -1 then break end

    if not API.isProcessing() then
        API.DoAction_Ability("Disassemble", 1, API.OFF_ACT_Bladed_interface_route)
        API.RandomSleep2(500, 250, 500)
        API.DoAction_Inventory1(item, 0, 0, API.OFF_ACT_GeneralInterface_route1)
    end

    API.RandomSleep2(500, 250, 500)
end
