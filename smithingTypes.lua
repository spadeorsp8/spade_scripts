local TYPES = {}

TYPES.buffs = {
    powerburst = {
        debuffId = 48960,
        potionIds = {49093, 49091, 49089, 49087}
    },
    juju = {
        buffId = 32781,
        potionIds = {32777, 32779, 32781, 32783}
    }
}

TYPES.itemLevels = {
    -- LEVEL_NAME = {<level index>, <interface index>}
    BASE = {1, 149},
    I = {2, 161},
    II = {3, 159},
    III = {4, 157},
    IV = {5, 155},
    V = {6, 153},
    -- BURIAL = {7, 151} -- TODO: Enable if support for Artisan's Workshop is added
}

TYPES.options = {
    RUNE = {
        bar = {2363, 52, 11, 1495}, -- {item id, if idx 2, if idx 3, smithing id}
        items = {
            DART_TIP = {
                id = 824,
                levels = {"BASE"},
                ifidx = {136, 3},
                stack = 50,
            },
        }
    },
    ELDER_RUNE = {
        bar = {44844, 52, 19, 1499},
        items = {
            FULL_HELM = {
                id = 45655,
                levels = {"BASE", "I", "II", "III", "IV", "V"},
                ifidx = {103, 1}
            },
            PLATELEGS = {
                id = 45686,
                levels = {"BASE", "I", "II", "III", "IV", "V"},
                ifidx = {103, 3}
            },
            PLATEBODY = {
                id = 45717,
                levels = {"BASE", "I", "II", "III", "IV", "V"},
                ifidx = {103, 5}
            },
            ROUND_SHIELD = {
                id = 45748,
                levels = {"BASE", "I", "II", "III", "IV", "V"},
                ifidx = {103, 7}
            },
            BOOTS = {
                id = 45779,
                levels = {"BASE", "I", "II", "III", "IV", "V"},
                ifidx = {103, 9}
            },
            GAUNTLETS = {
                id = 45810,
                levels = {"BASE", "I", "II", "III", "IV", "V"},
                ifidx = {103, 11}
            },
            LONGSWORD = {
                id = 45549,
                levels = {"BASE", "I", "II", "III", "IV", "V"},
                ifidx = {114, 1}
            },
            TWO_HANDED_SWORD = {
                id = 45611,
                levels = {"BASE", "I", "II", "III", "IV", "V"},
                ifidx = {114, 3}
            },
            OFF_HAND_LONGSWORD = {
                id = 45580,
                levels = {"BASE", "I", "II", "III", "IV", "V"},
                ifidx = {125, 1}
            },
            ORE_BOX = {
                id = 44797,
                levels = {"BASE"},
                ifidx = {136, 1}
            },
            PICKAXE = {
                id = 45642,
                levels = {"BASE", "I", "II", "III", "IV", "V"},
                ifidx = {136, 3}
            },
            MATTOCK = {
                id = 49564,
                levels = {"BASE"},
                ifidx = {136, 5}
            },
            ARMOUR_SPIKES = {
                id = 47071,
                levels = {"BASE"},
                ifidx = {136, 7}
            }
        }
    },
}

return TYPES
