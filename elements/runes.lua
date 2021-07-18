local _, ns = ...

local maxRunes = 6

local function PostUpdateRunes(runes, runemap)
    if not runes.OnUpdate then
        return 
    end

    local readyCount = 0
    for i = 1, maxRunes do
        local rune = runes[i]
        local cur = rune:GetValue()
        local _, max = rune:GetMinMaxValues()
        if cur == 1 and max == 1 then
            readyCount = readyCount + 1
        end
    end

    runes.OnUpdate(readyCount, maxRunes, "RUNES")
end

function ns.elements.AddRunes(self, size, spacing)
	local runes = {}
    local container = CreateFrame('Frame', nil, self.frames or self)
    
    runes.container = container

    local totalWidth = size * maxRunes + spacing * (maxRunes - 1)
    container:SetSize(totalWidth, size)

    for i = 1, maxRunes do
        local rune = CreateFrame('StatusBar', nil, container)
        rune:SetStatusBarTexture(ns.assets.STATUSBAR_DIAMOND)
        rune:SetOrientation("VERTICAL")
        rune:SetSize(size, size)
        rune:SetPoint('LEFT', container, 'LEFT', (i - 1) * (size + spacing), 0)

		local bg = container:CreateTexture(nil, 'BACKGROUND')
		bg:SetTexture(ns.assets.STATUSBAR_DIAMOND)
        bg:SetSize(size, size)
        bg:SetPoint('LEFT', container, 'LEFT', (i - 1) * (size + spacing), 0)
		bg.multiplier = 0.3
		rune.bg = bg

        runes[i] = rune
	end

	runes.colorSpec = true
	runes.sortOrder = 'asc'
    runes.PostUpdate = PostUpdateRunes
    
    self.Runes = runes
    
    return runes
end
