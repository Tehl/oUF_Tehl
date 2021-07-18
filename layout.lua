local addonName, ns = ...

local stylesheet = ns.stylesheet

oUF:Factory(function(self)
    self:SetActiveStyle(addonName .. "_HUD")
    self:Spawn('player')
end) 