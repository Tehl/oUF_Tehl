local _, ns = ...

ns.stylesheet = {
    generic = {
        fontName = "Fonts\\FRIZQT__.TTF",
        fontSize = 12,
        fontFlags = "",
        backgroundAlpha = 0.5
    },
    hud = {
        anchor = "CENTER",
        relativeAnchor = "CENTER",
        posX = 180,
        posY = -220,
        combo = {
            size = 20,
            spacing = 7.5,
            margin = 20
        },
        power = {
            width = 130,
            height = 6,
            fontSize = 10,
            fontInset = 2
        },
        role = {
            HEALER = {
                posX = 332
            }
        }
    }
}

ns.colors =
    setmetatable(
    {
        power = setmetatable(
            {
                MANA =         { 98 / 255, 202 / 255, 255 / 255},
                RAGE =         {255 / 255,  98 / 255,  98 / 255},
                ENERGY =       {255 / 255, 253 / 255,  78 / 255},
                COMBO_POINTS = {255 / 255, 253 / 255,  78 / 255},
                HOLY_POWER =   {255 / 255, 253 / 255,  78 / 255},
            },
            {__index = oUF.colors.power}
        )
    },
    {__index = oUF.colors}
)

ns.colors.power.SOUL_SHARDS = ns.colors.power.FURY

ns.colors.power[0] = ns.colors.power.MANA
ns.colors.power[1] = ns.colors.power.RAGE
ns.colors.power[3] = ns.colors.power.ENERGY
ns.colors.power[4] = ns.colors.power.COMBO_POINTS
ns.colors.power[7] = ns.colors.power.SOUL_SHARDS
ns.colors.power[9] = ns.colors.power.HOLY_POWER

ns.assets = {
    STATUSBAR_DIAMOND = [=[Interface\AddOns\oUF_Tehl\assets\statusbar\diamond]=],
    STATUSBAR_FLAT    = [=[Interface\AddOns\oUF_Tehl\assets\statusbar\flat]=],
    BORDER_PIXEL      = [=[Interface\AddOns\oUF_Tehl\assets\border\pixel]=]
}
