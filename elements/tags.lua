local _, ns = ...

local tags = oUF.Tags.Methods
local tagEvents = oUF.Tags.Events
local tagSharedEvents = oUF.Tags.SharedEvents

local floor = math.floor
local format = string.format

local ShortenValue = ns.utility.ShortenValue
local Percent = ns.utility.Percent

local function UnitSmartPowerTag(unit)
    local cur, max = UnitPower(unit), UnitPowerMax(unit)
	if(max == 0) then return end

	local powerType, powerName = UnitPowerType(unit)
	if powerName == 'MANA' then
		return Percent(cur, max)
    else
        return format("%s", cur)
    end
end

tags['layout:smartPower'] = UnitSmartPowerTag
tagEvents['layout:smartPower'] = 'UNIT_POWER_FREQUENT UNIT_MAXPOWER UNIT_DISPLAYPOWER'