local _, ns = ...

local stylesheet = ns.stylesheet
local playerClass = ns.session.playerClass

local function ClassPowerPostUpdate(classPower, power, maxPower, maxPowerChanged, powerType)
	if classPower.OnUpdate then
		classPower.OnUpdate(power, maxPower, powerType)
	end

	if (not maxPower or not maxPowerChanged) then return end

    local maxIndex = maxPower ~= 10 and maxPower or 5
    local size = classPower.size
	local spacing = classPower.spacing

    local totalWidth = size * maxPower + spacing * (maxPower - 1)
    classPower.container:SetSize(totalWidth, size)

	for i = 1, maxPower do
		local bar = classPower[i]
		bar:SetPoint('LEFT', classPower.container, 'LEFT', (i - 1) * (size + spacing), 0)
		
		if bar.bg then
			bar.bg:SetPoint('LEFT', classPower.container, 'LEFT', (i - 1) * (size + spacing), 0)
		end
	end
end

local function ClassPowerUpdateColor(classPower, powerType)
	local color = classPower.__owner.colors.power[powerType]
	local r, g, b = color[1], color[2], color[3]

	local isAnticipationRogue = playerClass == 'ROGUE'
	    and UnitPowerMax('player', SPELL_POWER_COMBO_POINTS) == 10

	for i = 1, #classPower do
		if(i > 5 and isAnticipationRogue) then
			r, g, b = 1, 0, 0
		end

		local bar = classPower[i]
		bar:SetStatusBarColor(r, g, b)

		local bg = bar.bg
		if(bg) then
			local mu = bg.multiplier or 1
			bg:SetVertexColor(r * mu, g * mu, b * mu, stylesheet.generic.backgroundAlpha or 0.5)
		end
	end
end

function ns.elements.AddClassPower(self, size, spacing)
    local classPower = {}
    local container = CreateFrame('Frame', nil, self.frames or self)

    classPower.size = size
    classPower.spacing = spacing
    classPower.container = container

	-- rogues with the anticipation talent have max 10 combo points
	-- create one extra to force __max to be different from UnitPowerMax
	-- needed for sizing and positioning in PostUpdate
	local maxPower = 11

	for i = 1, maxPower do
		local bar = CreateFrame('StatusBar', nil, container)
        bar:SetStatusBarTexture(ns.assets.STATUSBAR_DIAMOND)
        bar:SetSize(size, size)

		-- 6-10 will be stacked on top of 1-5 for rogues with the anticipation talent
		if(i > 5) then
			bar:SetFrameLevel(bar:GetFrameLevel() + 1)
		end

		local bg = container:CreateTexture(nil, 'BACKGROUND')
		bg:SetTexture(ns.assets.STATUSBAR_DIAMOND)
		bg:SetSize(size, size)
		bg.multiplier = 0.3
		bar.bg = bg

		classPower[i] = bar
	end

	classPower.PostUpdate = ClassPowerPostUpdate
	classPower.UpdateColor = ClassPowerUpdateColor

    self.ClassPower = classPower
    
    return classPower
end
