-- Main UI Frame and button management

MageUtility.UI = {}
MageUtility.UI.frame = nil
MageUtility.UI.buttons = {}
MageUtility.UI.sectionTitles = {}

-- Local reference to color constants
local Colors = MageUtility.Colors

-- Initialize UI
function MageUtility.UI:Initialize()
    self:CreateMainFrame()
    
    if MageUtility.playerClass == "MAGE" then
        self:CreateButtonContainer()
    else
        self:CreateNonMageMessage()
    end
    
    self.frame:Hide()
end

-- Calculate optimal window width based on spell count
function MageUtility.UI:CalculateOptimalWidth()
    local maxButtons = 0
    
    -- Check all sections
    local sections = {
        MageUtility.Teleports,
        MageUtility.Portals,
        MageUtility.ManaGems
    }
    
    for _, module in ipairs(sections) do
        if module then
            local spells = module:GetSpells()
            local count = table.getn(spells)
            if count > maxButtons then
                maxButtons = count
            end
        end
    end
    
    -- Calculate width: buttons * 50px + padding
    local contentWidth = maxButtons * 50
    local totalWidth = contentWidth + 30

    -- Minimum width for title
    if totalWidth < 180 then totalWidth = 180 end

    return totalWidth
end

-- Create main frame
function MageUtility.UI:CreateMainFrame()
    local frame = CreateFrame("Frame", "MageUtilityFrame", UIParent)
    frame:SetWidth(300)  -- Default width, will be adjusted if mage
    frame:SetHeight(310)
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:SetClampedToScreen(true)
    frame:SetFrameStrata("DIALOG")
    
    -- Backdrop (classic WoW style)
    frame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        tileSize = 32,
        edgeSize = 32,
        insets = {left = 11, right = 12, top = 12, bottom = 11}
    })
    frame:SetBackdropColor(0, 0, 0, 1)
    
    -- Title text
    local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", 0, -15)
    title:SetText("Mage Utility")
    title:SetTextColor(1, 0.82, 0, 1)
    frame.title = title
    
    -- Close button
    local closeBtn = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    closeBtn:SetPoint("TOPRIGHT", -5, -5)
    closeBtn:SetScript("OnClick", function()
        MageUtility.UI:Hide()
    end)
    
    -- Drag functionality
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function()
        this:StartMoving()
    end)
    frame:SetScript("OnDragStop", function()
        this:StopMovingOrSizing()
        MageUtility.UI:SavePosition()
    end)
    
    -- Assign frame to self
    self.frame = frame
    
    -- Adjust width if mage
    if MageUtility.playerClass == "MAGE" then
        local width = self:CalculateOptimalWidth()
        frame:SetWidth(width)
    end
end

-- Create button container
function MageUtility.UI:CreateButtonContainer()
    local container = CreateFrame("Frame", "MageUtilityButtonContainer", self.frame)
    container:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 20, -45)
    container:SetWidth(260)
    container:SetHeight(340)
    self.buttonContainer = container
    
    -- Restore position after frame is created
    self:RestorePosition()
end

-- Create message for non-mage players
function MageUtility.UI:CreateNonMageMessage()
    local msg = self.frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    msg:SetPoint("CENTER", self.frame, "CENTER", 0, 0)
    msg:SetText("You are not a Mage...\n\nYou have no power here!")
    msg:SetTextColor(1, 0.82, 0, 1)
    msg:SetJustifyH("CENTER")
    
    -- Restore position after frame is created
    self:RestorePosition()
end

-- Get or create a section title
function MageUtility.UI:GetOrCreateSectionTitle(index)
    if self.sectionTitles[index] then
        return self.sectionTitles[index]
    end
    
    local title = self.buttonContainer:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    title:SetJustifyH("LEFT")
    
    self.sectionTitles[index] = title
    return title
end

-- Update button grid - show all spells from all modules
function MageUtility.UI:UpdateButtons()
    -- Don't create buttons for non-mages
    if MageUtility.playerClass ~= "MAGE" then
        return
    end
    
    -- Hide all existing buttons
    for _, btn in ipairs(self.buttons) do
        btn:Hide()
    end
    
    -- Hide all section titles
    for _, title in ipairs(self.sectionTitles) do
        title:Hide()
    end
    
    local buttonIndex = 1
    local currentRow = 0
    
    -- Define sections with their modules
    local sections = {
        {name = "Teleports", module = MageUtility.Teleports},
        {name = "Portals", module = MageUtility.Portals},
        {name = "Mana Gems", module = MageUtility.ManaGems}
    }
    
    for sectionIndex, section in ipairs(sections) do
        local spells = section.module:GetSpells()
        
        -- Only show section if there are spells
        if table.getn(spells) > 0 then
            -- Create or get section title
            local title = self:GetOrCreateSectionTitle(sectionIndex)
            title:SetText(section.name)
            title:SetTextColor(1, 0.82, 0)
            
            -- Position title at the start of current row
            title:ClearAllPoints()
            title:SetPoint("TOPLEFT", self.buttonContainer, "TOPLEFT", 0, -currentRow * 50 + 5)
            title:Show()
            
            -- Move to next row for buttons (less space)
            currentRow = currentRow + 0.5
            
            -- Create buttons horizontally for this section
            for spellIndex, spellData in ipairs(spells) do
                local btn = self:GetOrCreateButton(buttonIndex)
                if btn then
                    btn.spellData = spellData
                    btn.module = section.module
                    
                    -- Position button horizontally in current row
                    local xPos = (spellIndex - 1) * 50
                    local yPos = -currentRow * 50
                    
                    btn:ClearAllPoints()
                    btn:SetPoint("TOPLEFT", self.buttonContainer, "TOPLEFT", xPos, yPos)
                    
                    -- Set icon
                    btn.icon:SetTexture(spellData.icon)
                    
                    -- Update state
                    self:UpdateButtonState(btn)
                    
                    btn:Show()
                    buttonIndex = buttonIndex + 1
                end
            end
            
            -- Move to next row for next section (add some spacing)
            currentRow = currentRow + 1.3
        end
    end
end

-- Get or create a button at index
function MageUtility.UI:GetOrCreateButton(index)
    if self.buttons[index] then
        return self.buttons[index]
    end
    
    -- Ensure container exists
    if not self.buttonContainer then
        return nil
    end
    
    local btn = CreateFrame("Button", "MageUtilitySpellButton"..index, self.buttonContainer)
    btn:SetWidth(40)
    btn:SetHeight(40)
    btn:EnableMouse(true)
    
    -- Icon texture
    local icon = btn:CreateTexture(nil, "BACKGROUND")
    icon:SetWidth(36)
    icon:SetHeight(36)
    icon:SetPoint("CENTER", btn, "CENTER", 0, 0)
    icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
    icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
    btn.icon = icon
    
    -- Normal texture (button border)
    local normalTex = btn:CreateTexture(nil, "ARTWORK")
    normalTex:SetTexture("Interface\\Buttons\\UI-Quickslot2")
    normalTex:SetWidth(64)
    normalTex:SetHeight(64)
    normalTex:SetPoint("CENTER", btn, "CENTER", 0, 0)
    btn:SetNormalTexture(normalTex)
    
    -- Pushed texture
    local pushedTex = btn:CreateTexture(nil, "ARTWORK")
    pushedTex:SetTexture("Interface\\Buttons\\UI-Quickslot-Depress")
    pushedTex:SetWidth(36)
    pushedTex:SetHeight(36)
    pushedTex:SetPoint("CENTER", btn, "CENTER", 0, 0)
    btn:SetPushedTexture(pushedTex)
    
    -- Highlight texture
    local highlightTex = btn:CreateTexture(nil, "HIGHLIGHT")
    highlightTex:SetTexture("Interface\\Buttons\\ButtonHilight-Square")
    highlightTex:SetBlendMode("ADD")
    highlightTex:SetWidth(40)
    highlightTex:SetHeight(40)
    highlightTex:SetPoint("CENTER", btn, "CENTER", 0, 0)
    btn:SetHighlightTexture(highlightTex)
    
    -- Disabled overlay
    local disabled = btn:CreateTexture(nil, "OVERLAY")
    disabled:SetAllPoints(btn)
    disabled:SetTexture(0, 0, 0, 0.6)
    disabled:Hide()
    btn.disabled = disabled
    
    -- Reagent count display
    local countText = btn:CreateFontString(nil, "OVERLAY", "NumberFontNormalSmall")
    countText:SetPoint("BOTTOMRIGHT", btn, "BOTTOMRIGHT", -2, 2)
    countText:SetTextColor(1, 1, 1)
    countText:SetShadowOffset(1, -1)
    countText:SetShadowColor(0, 0, 0, 1)
    btn.countText = countText
    
    -- Click handler
    btn:SetScript("OnClick", function()
        MageUtility.UI:OnButtonClick(this)
    end)
    
    -- Tooltip handlers
    btn:SetScript("OnEnter", function()
        MageUtility.UI:OnButtonEnter(this)
    end)
    btn:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    
    -- Enable mouse even when disabled
    btn:RegisterForClicks("LeftButtonUp")
    
    self.buttons[index] = btn
    return btn
end

-- Update button visual state
function MageUtility.UI:UpdateButtonState(button)
    if not button.spellData or not button.module then
        return
    end
    
    local status = button.module:GetStatus(button.spellData)
    local spell = button.spellData
    
    -- Update reagent count if spell has reagents
    if spell.reagent and button.countText then
        local hasSpell = MageUtility:HasSpell(spell.name)
        
        if hasSpell then
            local hasReagent, totalCount = MageUtility:HasReagent(spell.reagent.id, spell.reagent.count)
            button.countText:SetText(totalCount)
            button.countText:Show()
        else
            button.countText:Hide()
        end
    else
        -- No reagent needed (mana gems), hide count
        if button.countText then
            button.countText:Hide()
        end
    end
    
    -- Update visual state based on status
    if status == "ready" then
        -- Ready to cast
        button:SetAlpha(1.0)
        button:Enable()
        button.disabled:Hide()
        button.isDisabled = false
        
    elseif status == "not_learned" or status == "no_reagent" then
        -- Not learned or missing reagent - show as disabled
        button:SetAlpha(0.4)
        button:Enable()
        button.disabled:Show()
        button.isDisabled = true
    end
end

-- Handle button click
function MageUtility.UI:OnButtonClick(button)
    if not button.spellData or not button.module then
        return
    end
    
    -- Don't allow clicking disabled buttons
    if button.isDisabled then
        return
    end
    
    local status = button.module:GetStatus(button.spellData)
    
    if status == "ready" then
        -- Cast the spell
        button.module:Cast(button.spellData)
        
        -- Close window based on module's closeOnCast setting
        if button.module.closeOnCast then
            self:Hide()
        end
    end
end

-- Handle button hover (show tooltip)
function MageUtility.UI:OnButtonEnter(button)
    if not button.spellData then
        return
    end
    
    local spell = button.spellData
    
    -- Find spell in spellbook to show original tooltip
    local spellID = nil
    local i = 1
    while true do
        local name = GetSpellName(i, BOOKTYPE_SPELL)
        if not name then
            break
        end
        if name == spell.name then
            spellID = i
            break
        end
        i = i + 1
    end
    
    if spellID then
        -- Show original spell tooltip from spellbook
        GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
        GameTooltip:SetSpell(spellID, BOOKTYPE_SPELL)
        GameTooltip:Show()
    else
        -- Spell not learned, show custom tooltip
        GameTooltip:SetOwner(button, "ANCHOR_RIGHT")
        GameTooltip:ClearLines()
        GameTooltip:AddLine(spell.name, 1, 1, 1)
        GameTooltip:AddLine("|c" .. Colors.RED .. "Not learned|r", 1, 0, 0)
        GameTooltip:Show()
    end
end

-- Refresh all button states (called on events)
function MageUtility.UI:RefreshAllButtons()
    for _, btn in ipairs(self.buttons) do
        if btn:IsVisible() then
            self:UpdateButtonState(btn)
        end
    end
end

-- Show window
function MageUtility.UI:Show()
    self.frame:Show()
    self:UpdateButtons()
end

-- Hide window
function MageUtility.UI:Hide()
    self.frame:Hide()
end

-- Toggle window visibility
function MageUtility.UI:Toggle()
    if self.frame:IsVisible() then
        self:Hide()
    else
        self:Show()
    end
end

-- Save window position
function MageUtility.UI:SavePosition()
    local x, y = self.frame:GetLeft(), self.frame:GetTop()
    if not MageUtility_Config then
        MageUtility_Config = {}
    end
    MageUtility_Config.position = {x = x, y = y}
end

-- Restore window position
function MageUtility.UI:RestorePosition()
    if not self.frame then
        return
    end
    
    if MageUtility_Config and MageUtility_Config.position then
        local pos = MageUtility_Config.position
        self.frame:ClearAllPoints()
        self.frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", pos.x, pos.y)
    end
end