-- MageUtility Core
-- Main addon initialization and event handling

local ADDON_NAME = "Mage Utility"
local ADDON_VERSION = "1.0.0"

if not MageUtility then
    MageUtility = {}
end

-- Color configuration
MageUtility.Colors = {
    MAGE_BLUE = "FF3FC7EB",
    GOLD = "FFFFDB00",
    RED = "FFFF0000"
} 

-- Reagent constants
MageUtility.Reagents = {
    TELEPORT_RUNE = {id = 17031, name = "Rune of Teleportation", count = 1},
    PORTAL_RUNE = {id = 17032, name = "Rune of Portals", count = 1}
}

MageUtility.playerFaction = nil
MageUtility.playerClass = nil
MageUtility.initialized = false

-- Local reference to color constants
local Colors = MageUtility.Colors

-- Event frame
local eventFrame = CreateFrame("Frame")

-- Initialize addon
function MageUtility:Initialize()
    -- Only initialize once
    if self.initialized then
        return
    end
    
    -- Detect player class
    local _, classFilename = UnitClass("player")
    self.playerClass = classFilename
    
    -- Detect player faction (only if mage)
    if self.playerClass == "MAGE" then
        self:DetectFaction()
    end
    
    -- Initialize UI
    if MageUtility.UI then
        MageUtility.UI:Initialize()
    end
    
    -- Load saved position
    if not MageUtility_Config then
        MageUtility_Config = {
            position = nil
        }
    end
    
    -- Mark as initialized
    self.initialized = true
end

-- Detect player faction (Alliance or Horde)
function MageUtility:DetectFaction()
    local faction = UnitFactionGroup("player")
    self.playerFaction = faction
end

-- Toggle main window
function MageUtility:ToggleWindow()
    if MageUtility.UI then
        MageUtility.UI:Toggle()
    end
end

-- Check if player has learned a spell
function MageUtility:HasSpell(spellName)
    local i = 1
    while true do
        local name = GetSpellName(i, BOOKTYPE_SPELL)
        if not name then
            break
        end
        if name == spellName then
            return true
        end
        i = i + 1
    end
    return false
end

-- Check if player has reagent in bags
function MageUtility:HasReagent(itemID, count)
    local totalCount = 0
    
    for bag = 0, 4 do
        for slot = 1, GetContainerNumSlots(bag) do
            local link = GetContainerItemLink(bag, slot)
            if link then
                local _, stackCount = GetContainerItemInfo(bag, slot)
                -- Extract itemID from link
                local _, _, foundID = string.find(link, "item:(%d+)")
                if foundID and tonumber(foundID) == itemID then
                    totalCount = totalCount + stackCount
                end
            end
        end
    end
    
    return totalCount >= count, totalCount
end

-- Cast spell by name
function MageUtility:CastSpell(spellName)
    CastSpellByName(spellName)
end

-- Event handlers
local function OnEvent()
    if event == "ADDON_LOADED" and arg1 == "MageUtility" then
        DEFAULT_CHAT_FRAME:AddMessage("|c" .. Colors.MAGE_BLUE .. ADDON_NAME .. ":|c" .. Colors.GOLD .. " v" .. ADDON_VERSION .. "|r loaded successfully! Type |c".. Colors.MAGE_BLUE .."/mage|r or |c".. Colors.MAGE_BLUE .."/mu|r to open.|r")

    elseif event == "PLAYER_ENTERING_WORLD" then
        MageUtility:Initialize()
        
    elseif event == "BAG_UPDATE" then
        if MageUtility.UI and MageUtility.UI.frame and MageUtility.UI.frame:IsVisible() then
            MageUtility.UI:RefreshAllButtons()
        end
    end
end

-- Register events
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("BAG_UPDATE")
eventFrame:SetScript("OnEvent", OnEvent)

-- Slash commands
SLASH_MAGEUTILITY1 = "/mage"
SLASH_MAGEUTILITY2 = "/mu"
SlashCmdList["MAGEUTILITY"] = function(msg)
    MageUtility:ToggleWindow()
end