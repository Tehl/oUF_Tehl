local addonName, ns = ...

local oUFVersion = GetAddOnMetadata('oUF', 'version')
if(not oUFVersion:find('project%-version')) then
	local major, minor, rev = strsplit('.', oUFVersion)
	oUFVersion = major * 1000 + minor * 100 + rev

	assert(oUFVersion >= 10000, 'oUF Layout requires oUF version >= 10.0.0')
end

ns.Debug = function() end
if(AdiDebug) then
	ns.Debug = AdiDebug:Embed({}, addonName)
end

ns.session = {
	playerClass = select(2, UnitClass('player')),
	playerPower = select(2, UnitPowerType('player'))
}

ns.utility = {}

function ns.utility.ShortenValue(value)
	if(value >= 1e9) then
		return format('%.2fb', value / 1e9)
	elseif(value >= 1e6) then
		return format('%.2fm', value / 1e6)
	elseif(value >= 1e3) then
		return format('%.2fk', value / 1e3)
	else
		return value
	end
end

function ns.utility.Percent(cur, max)
	if max > 0 then
        return format("%d%%", floor(cur / max * 100 + 0.5))
    else
        return nil
	end
end

function ns.utility.GetActiveRole()
	return select(5, GetSpecializationInfo(GetSpecialization()))
end