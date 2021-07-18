local addonName, ns = ...

local stylesheet = ns.stylesheet
local playerClass = ns.session.playerClass

local function VisibilityClassPowerComparison(cur, max, powerType)
    if powerType == "RUNES" then
        return cur < max
    elseif powerType == "SOUL_SHARDS" then
        return cur ~= 3
    else
        return cur > 0
    end
end

local function VisibilityPowerComparison(cur, max, powerType)
    if powerType == "RAGE"
        or powerType == "RUNIC_POWER"
        or powerType == "INSANITY"
        or powerType == "FURY"
    then
        return cur > 0
    else
        return cur < max
    end
end

local function VisibilityPowerOverride(role, cur, max, powerType)
    -- if powerType == "MANA" then
    --     return role == "HEALER"
    --         or cur < max
    -- end
    return true
end

local function UpdatePowerVisibility(self)
    local power, roleData = self.data.power, self.data.role
    local powerVisible = VisibilityPowerOverride(roleData.cur, power.cur, power.max, power.type)
    
    if powerVisible then
        if not self.data.powerVisible then
            self.Power:Show()
        end
        self.data.powerVisible = true
    else
        if self.data.powerVisible then
            self.Power:Hide()
        end
        self.data.powerVisible = false
    end
end

local function UpdateVisibility(self)
    local power, classPower = self.data.power, self.data.classPower
    local frames = self.frames
    local visible = self.data.visible
    
    if InCombatLockdown()
        or VisibilityClassPowerComparison(classPower.cur, classPower.max, classPower.type)
        or VisibilityPowerComparison(power.cur, power.max, power.type)
    then
        if not visible then
            frames:Show()
        end
        self.data.visible = true

        UpdatePowerVisibility(self)
    else
        if visible then
            frames:Hide()
        end
        self.data.visible = false
    end
end

local function UpdateLayout(self)
    local roleData = self.data.role
    if roleData.last ~= roleData.cur then
        local roleStyle = stylesheet.hud.role[roleData.cur]
        local posX = roleStyle and roleStyle.posX or stylesheet.hud.posX
        local posY = roleStyle and roleStyle.posY or stylesheet.hud.posY

        self:SetPoint(
            stylesheet.hud.anchor,
            UIParent,
            stylesheet.hud.relativeAnchor,
            posX,
            posY
        )

        roleData.last = roleData.cur
    end

    local hasClassPower = self.data.classPower.max > 0
    if self.data.hasClassPower ~= hasClassPower then
        self.Power:SetPoint(
            'CENTER', self, 'CENTER', 0,
            hasClassPower and (-stylesheet.hud.combo.margin) or 0
        )
        self.data.hasClassPower = hasClassPower
    end
end

local function AddHudClassPower(self)
    local classPowerFunction
    if playerClass == "DEATHKNIGHT" then
        classPowerFunction = "AddRunes"
        self.data.classPower.type = "RUNES"
    else
        classPowerFunction = "AddClassPower"
    end

    local classPower = ns.elements[classPowerFunction](
        self,
        stylesheet.hud.combo.size,
        stylesheet.hud.combo.spacing
    )
    classPower.container:SetPoint('CENTER', self, 'CENTER', 0, 0)

    return classPower
end

local function AddHudPower(self)
    local power = ns.elements.AddPowerBar(self, unit)
    power:SetSize(
        stylesheet.hud.power.width,
        stylesheet.hud.power.height
    )
    power:SetPoint('CENTER', self, 'CENTER', 0, 0)
    
    ns.elements.AddText(
        self,
        power.border,
        '[layout:smartPower]',
        stylesheet.hud.power.fontSize
    ):SetPoint('RIGHT', power, 'RIGHT', -stylesheet.hud.power.fontInset, 0)
    
    return power
end

local function OnUpdateRole(self)
    self.data.role.cur = ns.utility.GetActiveRole()

    UpdateLayout(self)
end

local function Shared(self, unit)
	self:SetSize(1, 1)

    self.colors = ns.colors
    
    self.data = {
        classPower = { cur = 0, max = 0, type = nil },
        power = { cur = 0, min = 0, max = 0, type = nil },
        role = { cur = nil, last = nil },
        visible = true,
        powerVisible = true,
        hasClassPower = nil
    }
    
    self.frames = CreateFrame('Frame', nil, self)
    self.frames:SetAllPoints()

    local classPower = AddHudClassPower(self)
    local power = AddHudPower(self)

    classPower.OnUpdate = function(cur, max, powerType)
        self.data.classPower.cur = cur or 0
        self.data.classPower.max = max or 0
        self.data.classPower.type = powerType
        UpdateVisibility(self)
        UpdateLayout(self)
    end

    power.OnUpdate = function(cur, min, max)
        self.data.power.cur = cur or 0
        self.data.power.min = min or 0
        self.data.power.max = max or 0
        self.data.power.type = select(2, UnitPowerType('player'))
        UpdateVisibility(self)
    end
    
    self.data.role.cur = ns.utility.GetActiveRole()
    self:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED", OnUpdateRole)

    UpdateVisibility(self)
    UpdateLayout(self)
end

oUF:RegisterStyle(addonName .. '_HUD', Shared)
