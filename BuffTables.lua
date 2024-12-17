local addonName, addon = ...
-- Table to track instant cast proc auras, like Nature's Swiftness.
addon.instantCastBuffsTable = {
    ["Druid"] = {
        ["Predator's Swiftness"] = {
            ["arena1"] = false,
            ["arena2"] = false,
            ["arena3"] = false,
            ["arena4"] = false,
            ["arena5"] = false,
            ["spells"] = { ["Cyclone"] = true, ["Hibernate"] = true, ["Entangling Roots"] = true, ["Healing Touch"] = true, ["Nourish"] = true, ["Regrowth"] = true, ["Wrath"] = true }
        },
        ["Nature's Swiftness"] = {
            ["arena1"] = false,
            ["arena2"] = false,
            ["arena3"] = false,
            ["arena4"] = false,
            ["arena5"] = false,
            ["spells"] = { ["Cyclone"] = true, ["Hibernate"] = true, ["Entangling Roots"] = true, ["Healing Touch"] = true, ["Nourish"] = true, ["Regrowth"] = true, ["Starfire"] = true, ["Wrath"] = true }
        }
    },
    ["Mage"] = {
        ["!Fireball"] = {
            ["arena1"] = false,
            ["arena2"] = false,
            ["arena3"] = false,
            ["arena4"] = false,
            ["arena5"] = false,
            ["spells"] = { ["Fireball"] = true, ["Frostfire Bolt"] = true }
        },
        ["Hot Streak"] = {
            ["arena1"] = false,
            ["arena2"] = false,
            ["arena3"] = false,
            ["arena4"] = false,
            ["arena5"] = false,
            ["spells"] = { ["Pyroblast"] = true }
        },
        ["Presence of Mind"] = {
            ["arena1"] = false,
            ["arena2"] = false,
            ["arena3"] = false,
            ["arena4"] = false,
            ["arena5"] = false,
            ["spells"] = { ["Polymorph"] = true, ["Arcane Blast"] = true, ["Pyroblast"] = true, ["Frostfire Bolt"] = true,  ["Fireball"] = true,  ["Frostbolt"] = true, ["Scorch"] = true, ["Flamestrike"] = true }
        },
        ["Firestarter"] = {
            ["arena1"] = false,
            ["arena2"] = false,
            ["arena3"] = false,
            ["arena4"] = false,
            ["arena5"] = false,
            ["spells"] = { ["Flamestrike"] = true }
        }
    },
    ["Paladin"] = {
        ["Infusion of Light"] = {
            ["arena1"] = false,
            ["arena2"] = false,
            ["arena3"] = false,
            ["arena4"] = false,
            ["arena5"] = false,
            ["spells"] = { ["Flash of Light"] = true }
        },
        ["The Art of War"] = {
            ["arena1"] = false,
            ["arena2"] = false,
            ["arena3"] = false,
            ["arena4"] = false,
            ["arena5"] = false,
            ["spells"] = { ["Flash of Light"] = true, ["Exorcism"] = true }
        }
    },
    ["Priest"] = {
        ["Surge of Light"] = {
            ["arena1"] = false,
            ["arena2"] = false,
            ["arena3"] = false,
            ["arena4"] = false,
            ["arena5"] = false,
            ["spells"] = { ["Flash Heal"] = true, ["Smite"] = true }
        }
    },
    ["Shaman"] = {
        ["Maelstrom Weapon"] = {
            ["arena1"] = false,
            ["arena2"] = false,
            ["arena3"] = false,
            ["arena4"] = false,
            ["arena5"] = false,
            ["spells"] = { ["Lightning Bolt"] = true, ["Chain Lightning"] = true, ["Lesser Healing Wave"] = true, ["Healing Wave"] = true, ["Chain Heal"] = true, ["Hex"] = true }
        },
        ["Elemental Mastery"] = {
            ["arena1"] = false,
            ["arena2"] = false,
            ["arena3"] = false,
            ["arena4"] = false,
            ["arena5"] = false,
            ["spells"] = { ["Lightning Bolt"] = true, ["Chain Lightning"] = true, ["Lava Burst"] = true }
        },  
         ["Nature's Swiftness"] = {
            ["arena1"] = false,
            ["arena2"] = false,
            ["arena3"] = false,
            ["arena4"] = false,
            ["arena5"] = false,
            ["spells"] = { ["Healing Wave"] = true, ["Lesser Healing Wave"] = true, ["Chain Heal"] = true, ["Hex"] = true, ["Lightning Bolt"] = true, ["Chain Lightning"] = true }
        }
    },
    ["Warlock"] = {
        ["Backlash"] = {
            ["arena1"] = false,
            ["arena2"] = false,
            ["arena3"] = false,
            ["arena4"] = false,
            ["arena5"] = false,
            ["spells"] = { ["Incinerate"] = true, ["Shadow Bolt"] = true }
        },
        ["Shadow Trance"] = {
            ["arena1"] = false,
            ["arena2"] = false,
            ["arena3"] = false,
            ["arena4"] = false,
            ["arena5"] = false,
            ["spells"] = { ["Shadow Bolt"] = true }
        }
    },
}

-- Table to track haste auras that reduce the GCD, such as Heroism.
addon.hasteBuffsTable = {
    ["Heroism"] = {
        ["arena1"] = false,
        ["arena2"] = false,
        ["arena3"] = false,
        ["arena4"] = false,
        ["arena5"] = false, 
        -- No spell key if applies to all spells
    },
    ["Death Knight"] = {
        ["Unholy Presence"] = {
            ["arena1"] = false,
            ["arena2"] = false,
            ["arena3"] = false,
            ["arena4"] = false,
            ["arena5"] = false,
        }
    },
    ["Druid"] = {
        ["Power Infusion"] = {
            ["arena1"] = false,
            ["arena2"] = false,
            ["arena3"] = false,
            ["arena4"] = false,
            ["arena5"] = false,
        }
    },
    ["Mage"] = {
        ["Power Infusion"] = {
            ["arena1"] = false,
            ["arena2"] = false,
            ["arena3"] = false,
            ["arena4"] = false,
            ["arena5"] = false,
        },
        ["Icy Veins"] = {
            ["arena1"] = false,
            ["arena2"] = false,
            ["arena3"] = false,
            ["arena4"] = false,
            ["arena5"] = false,
        },
        ["Berserking"] = {
            ["arena1"] = false,
            ["arena2"] = false,
            ["arena3"] = false,
            ["arena4"] = false,
            ["arena5"] = false,
        }
    },
    ["Paladin"] = {
        ["Judgements of the Pure"] = {
            ["arena1"] = false,
            ["arena2"] = false,
            ["arena3"] = false,
            ["arena4"] = false,
            ["arena5"] = false,
        }
    },
    ["Priest"] = {
        ["Power Infusion"] = {
            ["arena1"] = false,
            ["arena2"] = false,
            ["arena3"] = false,
            ["arena4"] = false,
            ["arena5"] = false,
        },
        ["Berserking"] = {
            ["arena1"] = false,
            ["arena2"] = false,
            ["arena3"] = false,
            ["arena4"] = false,
            ["arena5"] = false,
        }
    },
    ["Shaman"] = {
        ["Elemental Mastery"] = {
            ["arena1"] = false,
            ["arena2"] = false,
            ["arena3"] = false,
            ["arena4"] = false,
            ["arena5"] = false,
        },
        ["Lava Flows"] = {
            ["arena1"] = false,
            ["arena2"] = false,
            ["arena3"] = false,
            ["arena4"] = false,
            ["arena5"] = false,
        },
        ["Berserking"] = {
            ["arena1"] = false,
            ["arena2"] = false,
            ["arena3"] = false,
            ["arena4"] = false,
            ["arena5"] = false,
        }
    },
    ["Warlock"] = {
        ["Backdraft"] = {
            ["arena1"] = false,
            ["arena2"] = false,
            ["arena3"] = false,
            ["arena4"] = false,
            ["arena5"] = false,
            ["spells"] = { ["Shadowflame"] = true, ["Incinerate"] = true, ["Shadow Bolt"] = true } -- Can only be spells that are instant casts or can be instant due to proc
        },
        ["Eradication"] = {
            ["arena1"] = false,
            ["arena2"] = false,
            ["arena3"] = false,
            ["arena4"] = false,
            ["arena5"] = false,
        },
        ["Power Infusion"] = {
            ["arena1"] = false,
            ["arena2"] = false,
            ["arena3"] = false,
            ["arena4"] = false,
            ["arena5"] = false,
        },
    },
}
