-- Mana Gem conjure spells data and logic

MageUtility.ManaGems = {}

-- Get close behavior from constants
function MageUtility.ManaGems:GetCloseOnCast()
    return MageUtility.CloseOnCast.MANAGEMS
end

MageUtility.ManaGems.closeOnCast = MageUtility.CloseOnCast.MANAGEMS

-- Mana Gem spell data (no faction dependency, no reagents)
MageUtility.ManaGems.Data = {
    {
        name = "Conjure Mana Agate",
        icon = "Interface\\Icons\\Inv_misc_gem_emerald_01"
    },
    {
        name = "Conjure Mana Jade",
        icon = "Interface\\Icons\\Inv_misc_gem_emerald_02"
    },
    {
        name = "Conjure Mana Citrine",
        icon = "Interface\\Icons\\Inv_misc_gem_opal_01"
    },
    {
        name = "Conjure Mana Ruby",
        icon = "Interface\\Icons\\Inv_misc_gem_ruby_01"
    }
}

-- Get all mana gem spells
function MageUtility.ManaGems:GetSpells()
    return self.Data
end

-- Check if spell is usable
function MageUtility.ManaGems:IsUsable(spellData)
    -- Check if spell is learned
    if not MageUtility:HasSpell(spellData.name) then
        return false, "not_learned"
    end
    
    return true, "ready"
end

-- Get spell status
function MageUtility.ManaGems:GetStatus(spellData)
    local usable, reason = self:IsUsable(spellData)
    return reason
end

-- Cast mana gem conjure spell
function MageUtility.ManaGems:Cast(spellData)
    MageUtility:CastSpell(spellData.name)
end