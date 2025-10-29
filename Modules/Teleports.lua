-- Teleport spells data and logic

MageUtility.Teleports = {}

-- Teleport spell data
MageUtility.Teleports.Data = {
    Alliance = {
        {
            name = "Teleport: Stormwind",
            icon = "Interface\\Icons\\Spell_arcane_teleportstormwind",
            reagent = MageUtility.Reagents.TELEPORT_RUNE
        },
        {
            name = "Teleport: Ironforge",
            icon = "Interface\\Icons\\Spell_arcane_teleportironforge",
            reagent = MageUtility.Reagents.TELEPORT_RUNE
        },
        {
            name = "Teleport: Darnassus",
            icon = "Interface\\Icons\\Spell_arcane_teleportdarnassus",
            reagent = MageUtility.Reagents.TELEPORT_RUNE
        }
    },
    Horde = {
        {
            name = "Teleport: Orgrimmar",
            icon = "Interface\\Icons\\Spell_arcane_teleportorgrimmar",
            reagent = MageUtility.Reagents.TELEPORT_RUNE
        },
        {
            name = "Teleport: Thunder Bluff",
            icon = "Interface\\Icons\\Spell_arcane_teleportthunderbluff",
            reagent = MageUtility.Reagents.TELEPORT_RUNE
        },
        {
            name = "Teleport: Undercity",
            icon = "Interface\\Icons\\Spell_arcane_teleportundercity",
            reagent = MageUtility.Reagents.TELEPORT_RUNE
        }
    }
}

-- Get spells for player's faction
function MageUtility.Teleports:GetSpells()
    local faction = MageUtility.playerFaction
    if faction and self.Data[faction] then
        return self.Data[faction]
    end
    return {}
end

-- Check if spell is usable
function MageUtility.Teleports:IsUsable(spellData)
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
function MageUtility.Teleports:GetStatus(spellData)
    local usable, reason = self:IsUsable(spellData)
    return reason
end

-- Cast teleport spell
function MageUtility.Teleports:Cast(spellData)
    MageUtility:CastSpell(spellData.name)
end