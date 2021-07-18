local _, ns = ...

local stylesheet = ns.stylesheet

local function PowerBarPostUpdate(power, unit, cur, min, max)
    if power.OnUpdate then
		power.OnUpdate(cur, min, max)
	end
end

local function PowerBarPostUpdateColor(power, unit, r, g, b)
    local bg = power.bg
    if(bg) then
        local mu = bg.multiplier or 1
        bg:SetVertexColor(r * mu, g * mu, b * mu, stylesheet.generic.backgroundAlpha or 0.5)
    end
end

function ns.elements.AddPowerBar(self, unit)
    local power = CreateFrame("StatusBar", nil, self.frames or self)
    power:SetStatusBarTexture(ns.assets.STATUSBAR_FLAT)
    power.colorPower = true
    power.frequentUpdates = unit == "player" or unit == "target"
    power.displayAltPower = unit == "boss"

    local bg = power:CreateTexture(nil, "BACKGROUND")
    bg:SetTexture(ns.assets.STATUSBAR_FLAT)
    bg:SetAllPoints()
    bg.multiplier = 1 / 3
    power.bg = bg

    local border = CreateFrame("Frame", nil, power)
    Mixin(border, BackdropTemplateMixin)
    border:SetBackdrop({
        edgeFile = ns.assets.BORDER_PIXEL,
        edgeSize = 6,
        insets = { left = 1, right = 1, top = 1, bottom = 1 }
    })
    border:SetBackdropColor(0, 0, 0, 1)
    border:SetAllPoints()
    power.border = border

    power.PostUpdate = PowerBarPostUpdate
    power.PostUpdateColor = PowerBarPostUpdateColor

    self.Power = power

    return power
end
