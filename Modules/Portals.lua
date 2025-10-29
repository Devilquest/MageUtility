-- Portal spells data and logic

MageUtility.Portals = {}

-- Portal spell data
MageUtility.Portals.Data = {
    Alliance = {
        {
            name = "Portal: Stormwind",
            icon = "Interface\\Icons\\Spell_arcane_portalstormwind",
            reagent = MageUtility.Reagents.PORTAL_RUNE
        },
        {
            name = "Portal: Ironforge",
            icon = "Interface\\Icons\\Spell_arcane_portalironforge",
            reagent = MageUtility.Reagents.PORTAL_RUNE
        },
        {
            name = "Portal: Darnassus",
            icon = "Interface\\Icons\\Spell_arcane_portaldarnassus",
            reagent = MageUtility.Reagents.PORTAL_RUNE
        }
    },
    Horde = {
        {
            name = "Portal: Orgrimmar",
            icon = "Interface\\Icons\\Spell_arcane_portalorgrimmar",
            reagent = MageUtility.Reagents.PORTAL_RUNE
        },
        {
            name = "Portal: Thunder Bluff",
            icon = "Interface\\Icons\\Spell_arcane_portalthunderbluff",
            reagent = MageUtility.Reagents.PORTAL_RUNE
        },
        {
            name = "Portal: Undercity",
            icon = "Interface\\Icons\\Spell_arcane_portalundercity",
            reagent = MageUtility.Reagents.PORTAL_RUNE
        }
    }
}

-- Get spells for player's faction
function MageUtility.Portals:GetSpells()
    local faction = MageUtility.playerFaction
    if faction and self.Data[faction] then
        return self.Data[faction]
    end
    return {}
end

-- Check if spell is usable
function MageUtility.Portals:IsUsable(spellData)
    -- Check if spell is learned
    if not MageUtility:HasSpell(spellData.name) then
        return false, "not_learned"
    end
    
    -- Check reagent
    if spellData.reagent then
        local hasReagent = MageUtility:HasReagent(spellData.reagent.id, spellData.reagent.count)
        if not hasReagent then
            return false, "no_reagent"
        end
    end
    
    return true, "ready"
end

-- Get spell status
function MageUtility.Portals:GetStatus(spellData)
    local usable, reason = self:IsUsable(spellData)
    return reason
end

-- Cast portal spell
function MageUtility.Portals:Cast(spellData)
    MageUtility:CastSpell(spellData.name)
end