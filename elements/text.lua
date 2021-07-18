local _, ns = ...

local stylesheet = ns.stylesheet

function ns.elements.AddText(self, parent, text, size, flags, font)
    local frame = parent or self
    local fontName = font or stylesheet.generic.fontName
    local fontSize = size or stylesheet.generic.fontSize
    local fontFlags = flags or stylesheet.generic.fontFlags

    local fontString = frame:CreateFontString(nil, "OVERLAY")
    fontString:SetFont(fontName, fontSize)
    fontString:SetShadowColor(0, 0, 0, 1)
    fontString:SetShadowOffset(1, -1)

    self:Tag(fontString, text)

    return fontString
end