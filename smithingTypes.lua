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

-- NOTE: All interface options in the smithing window share the same primary interface ID (37)

TYPES.itemLevels = {
    -- LEVEL_NAME = {<level index>, <interface index 2>}
    BASE = {1, 149},
    I = {2, 161},
    II = {3, 159},
    III = {4, 157},
    IV = {5, 155},
    V = {6, 153},
    -- BURIAL = {7, 151} -- TODO: Enable if support for Artisan's Workshop is added
}

TYPES.options = {
--[[ Example:
    BAR_NAME = {
        bar = {item ID, if index 2, if index 3, smithing ID (VB 8332 value)},
        items = {
            ITEM_NAME = {
                id = item ID,
                levels = {"BASE", "I", "II", "III", "IV", "V", "BURIAL"} -- subset of this table,
                ifidx = {if idx 2, if idx 3},
                stack = <number of items created per bar in a stack> -- only specify this field if the item is stackable
            },
            ...
        }
    },
]]
    BRONZE = {
        bar = {2349, 52, 1, 1490},
        items = {
            FULL_HELM = {
                id = 1155,
                levels = {"BASE"},
                ifidx = {103, 1},
            },
            MED_HELM = {
                id = 1139,
                levels = {"BASE"},
                ifidx = {103, 3},
            },
            PLATELEGS = {
                id = 1075,
                levels = {"BASE"},
                ifidx = {103, 5},
            },
            PLATESKIRT = {
                id = 1087,
                levels = {"BASE"},
                ifidx = {103, 7},
            },
            PLATEBODY = {
                id = 1117,
                levels = {"BASE"},
                ifidx = {103, 9},
            },
            CHAINBODY = {
                id = 1103,
                levels = {"BASE"},
                ifidx = {103, 11},
            },
            SQUARE_SHIELD = {
                id = 1173,
                levels = {"BASE"},
                ifidx = {103, 13},
            },
            KITESHIELD = {
                id = 1189,
                levels = {"BASE"},
                ifidx = {103, 15},
            },
            BOOTS = {
                id = 4119,
                levels = {"BASE"},
                ifidx = {103, 17},
            },
            GAUNTLETS = {
                id = 45431,
                levels = {"BASE"},
                ifidx = {103, 19},
            },
            DAGGER = {
                id = 1205,
                levels = {"BASE"},
                ifidx = {114, 1},
            },
            MACE = {
                id = 1422,
                levels = {"BASE"},
                ifidx = {114, 3},
            },
            SWORD = {
                id = 1277,
                levels = {"BASE"},
                ifidx = {114, 5},
            },
            SCIMITAR = {
                id = 1321,
                levels = {"BASE"},
                ifidx = {114, 7},
            },
            LONGSWORD = {
                id = 1291,
                levels = {"BASE"},
                ifidx = {114, 9},
            },
            WARHAMMER = {
                id = 1337,
                levels = {"BASE"},
                ifidx = {114, 11},
            },
            BATTLEAXE = {
                id = 1375,
                levels = {"BASE"},
                ifidx = {114, 13},
            },
            CLAWS = {
                id = 3095,
                levels = {"BASE"},
                ifidx = {114, 15},
            },
            TWO_HANDED_SWORD = {
                id = 1307,
                levels = {"BASE"},
                ifidx = {114, 17},
            },
            HATCHET = {
                id = 1351,
                levels = {"BASE"},
                ifidx = {114, 19},
            },
            HASTA = {
                id = 11367,
                levels = {"BASE"},
                ifidx = {114, 21},
            },
            SPEAR = {
                id = 1237,
                levels = {"BASE"},
                ifidx = {114, 23},
            },
            OFF_HAND_DAGGER = {
                id = 25692,
                levels = {"BASE"},
                ifidx = {125, 1},
            },
            OFF_HAND_MACE = {
                id = 25674,
                levels = {"BASE"},
                ifidx = {125, 3},
            },
            OFF_HAND_SWORD = {
                id = 25710,
                levels = {"BASE"},
                ifidx = {125, 5},
            },
            OFF_HAND_SCIMITAR = {
                id = 25743,
                levels = {"BASE"},
                ifidx = {125, 7},
            },
            OFF_HAND_LONGSWORD = {
                id = 25725,
                levels = {"BASE"},
                ifidx = {125, 9},
            },
            OFF_HAND_WARHAMMER = {
                id = 25779,
                levels = {"BASE"},
                ifidx = {125, 11},
            },
            OFF_HAND_BATTLEAXE = {
                id = 25761,
                levels = {"BASE"},
                ifidx = {125, 13},
            },
            OFF_HAND_CLAWS = {
                id = 25933,
                levels = {"BASE"},
                ifidx = {125, 15},
            },
            ARROWHEADS = {
                id = 39,
                levels = {"BASE"},
                ifidx = {136, 1},
                stack = 75
            },
            DART_TIP = {
                id = 819,
                levels = {"BASE"},
                ifidx = {136, 3},
                stack = 50
            },
            BOLTS = {
                id = 9375,
                levels = {"BASE"},
                ifidx = {136, 5},
                stack = 50
            },
            LIMBS = {
                id = 9420,
                levels = {"BASE"},
                ifidx = {136, 7},
            },
            KNIFE = {
                id = 864,
                levels = {"BASE"},
                ifidx = {136, 9},
                stack = 25
            },
            OFF_HAND_KNIFE = {
                id = 25897,
                levels = {"BASE"},
                ifidx = {136, 11},
                stack = 25
            },
            THROWING_AXE = {
                id = 800,
                levels = {"BASE"},
                ifidx = {136, 13},
                stack = 25
            },
            OFF_HAND_THROWING_AXE = {
                id = 25903,
                levels = {"BASE"},
                ifidx = {136, 15},
                stack = 25
            },
            ORE_BOX = {
                id = 44779,
                levels = {"BASE"},
                ifidx = {147, 1},
            },
            NAILS = {
                id = 4819,
                levels = {"BASE"},
                ifidx = {147, 3},
                stack = 75
            },
            WIRE = {
                id = 1794,
                levels = {"BASE"},
                ifidx = {147, 5},
            },
            PICKAXE = {
                id = 1265,
                levels = {"BASE"},
                ifidx = {147, 7},
            },
            MATTOCK = {
                id = 49539,
                levels = {"BASE"},
                ifidx = {147, 9},
            },
        }
    },
    IRON = {
        bar = {2351, 52, 3, 1491},
        items = {
            FULL_HELM = {
                id = 1153,
                levels = {"BASE", "I"},
                ifidx = {103, 1},
            },
            MED_HELM = {
                id = 1137,
                levels = {"BASE", "I"},
                ifidx = {103, 3},
            },
            PLATELEGS = {
                id = 1067,
                levels = {"BASE", "I"},
                ifidx = {103, 5},
            },
            PLATESKIRT = {
                id = 1081,
                levels = {"BASE", "I"},
                ifidx = {103, 7},
            },
            PLATEBODY = {
                id = 1115,
                levels = {"BASE", "I"},
                ifidx = {103, 9},
            },
            CHAINBODY = {
                id = 1101,
                levels = {"BASE", "I"},
                ifidx = {103, 11},
            },
            SQUARE_SHIELD = {
                id = 1175,
                levels = {"BASE", "I"},
                ifidx = {103, 13},
            },
            KITESHIELD = {
                id = 1191,
                levels = {"BASE", "I"},
                ifidx = {103, 15},
            },
            BOOTS = {
                id = 4121,
                levels = {"BASE", "I"},
                ifidx = {103, 17},
            },
            GAUNTLETS = {
                id = 45945,
                levels = {"BASE", "I"},
                ifidx = {103, 19},
            },
            DAGGER = {
                id = 1203,
                levels = {"BASE", "I"},
                ifidx = {114, 1},
            },
            MACE = {
                id = 1420,
                levels = {"BASE", "I"},
                ifidx = {114, 3},
            },
            SWORD = {
                id = 1279,
                levels = {"BASE", "I"},
                ifidx = {114, 5},
            },
            SCIMITAR = {
                id = 1323,
                levels = {"BASE", "I"},
                ifidx = {114, 7},
            },
            LONGSWORD = {
                id = 1293,
                levels = {"BASE", "I"},
                ifidx = {114, 9},
            },
            WARHAMMER = {
                id = 1335,
                levels = {"BASE", "I"},
                ifidx = {114, 11},
            },
            BATTLEAXE = {
                id = 1363,
                levels = {"BASE", "I"},
                ifidx = {114, 13},
            },
            CLAWS = {
                id = 3096,
                levels = {"BASE", "I"},
                ifidx = {114, 15},
            },
            TWO_HANDED_SWORD = {
                id = 1309,
                levels = {"BASE", "I"},
                ifidx = {114, 17},
            },
            HATCHET = {
                id = 1349,
                levels = {"BASE"},
                ifidx = {114, 19},
            },
            HASTA = {
                id = 11369,
                levels = {"BASE"},
                ifidx = {114, 21},
            },
            SPEAR = {
                id = 1239,
                levels = {"BASE"},
                ifidx = {114, 23},
            },
            OFF_HAND_DAGGER = {
                id = 25694,
                levels = {"BASE", "I"},
                ifidx = {125, 1},
            },
            OFF_HAND_MACE = {
                id = 25676,
                levels = {"BASE", "I"},
                ifidx = {125, 3},
            },
            OFF_HAND_SWORD = {
                id = 25712,
                levels = {"BASE", "I"},
                ifidx = {125, 5},
            },
            OFF_HAND_SCIMITAR = {
                id = 25745,
                levels = {"BASE", "I"},
                ifidx = {125, 7},
            },
            OFF_HAND_LONGSWORD = {
                id = 25727,
                levels = {"BASE", "I"},
                ifidx = {125, 9},
            },
            OFF_HAND_WARHAMMER = {
                id = 25781,
                levels = {"BASE", "I"},
                ifidx = {125, 11},
            },
            OFF_HAND_BATTLEAXE = {
                id = 25763,
                levels = {"BASE", "I"},
                ifidx = {125, 13},
            },
            OFF_HAND_CLAWS = {
                id = 25935,
                levels = {"BASE", "I"},
                ifidx = {125, 15},
            },
            ARROWHEADS = {
                id = 40,
                levels = {"BASE"},
                ifidx = {136, 1},
                stack = 75
            },
            DART_TIP = {
                id = 820,
                levels = {"BASE"},
                ifidx = {136, 3},
                stack = 50
            },
            BOLTS = {
                id = 9377,
                levels = {"BASE"},
                ifidx = {136, 5},
                stack = 50
            },
            LIMBS = {
                id = 9423,
                levels = {"BASE"},
                ifidx = {136, 7},
            },
            KNIFE = {
                id = 863,
                levels = {"BASE"},
                ifidx = {136, 9},
                stack = 25
            },
            OFF_HAND_KNIFE = {
                id = 25896,
                levels = {"BASE"},
                ifidx = {136, 11},
                stack = 25
            },
            THROWING_AXE = {
                id = 801,
                levels = {"BASE"},
                ifidx = {136, 13},
                stack = 25
            },
            OFF_HAND_THROWING_AXE = {
                id = 25904,
                levels = {"BASE"},
                ifidx = {136, 15},
                stack = 25
            },
            ORE_BOX = {
                id = 44781,
                levels = {"BASE"},
                ifidx = {147, 1},
            },
            NAILS = {
                id = 4820,
                levels = {"BASE"},
                ifidx = {147, 3},
                stack = 75
            },
            LANTERN_FRAME = {
                id = 4540,
                levels = {"BASE"},
                ifidx = {147, 5},
            },
            SPIT = {
                id = 7225,
                levels = {"BASE"},
                ifidx = {147, 7},
            },
            PICKAXE = {
                id = 1267,
                levels = {"BASE"},
                ifidx = {147, 9},
            },
            MATTOCK = {
                id = 49542,
                levels = {"BASE"},
                ifidx = {147, 11},
            },
        }
    },
    STEEL = {
        bar = {2353, 52, 5, 1492},
        items = {
            FULL_HELM = {
                id = 45458,
                levels = {"BASE", "I"},
                ifidx = {103, 1},
            },
            MED_HELM = {
                id = 45459,
                levels = {"BASE", "I"},
                ifidx = {103, 3},
            },
            PLATELEGS = {
                id = 45460,
                levels = {"BASE", "I"},
                ifidx = {103, 5},
            },
            PLATESKIRT = {
                id = 45461,
                levels = {"BASE", "I"},
                ifidx = {103, 7},
            },
            PLATEBODY = {
                id = 45462,
                levels = {"BASE", "I"},
                ifidx = {103, 9},
            },
            CHAINBODY = {
                id = 45463,
                levels = {"BASE", "I"},
                ifidx = {103, 11},
            },
            SQUARE_SHIELD = {
                id = 45464,
                levels = {"BASE", "I"},
                ifidx = {103, 13},
            },
            KITESHIELD = {
                id = 44465,
                levels = {"BASE", "I"},
                ifidx = {103, 15},
            },
            BOOTS = {
                id = 44466,
                levels = {"BASE", "I"},
                ifidx = {103, 17},
            },
            GAUNTLETS = {
                id = 47056,
                levels = {"BASE", "I"},
                ifidx = {103, 19},
            },
            DAGGER = {
                id = 45441,
                levels = {"BASE", "I"},
                ifidx = {114, 1},
            },
            MACE = {
                id = 45443,
                levels = {"BASE", "I"},
                ifidx = {114, 3},
            },
            SWORD = {
                id = 45445,
                levels = {"BASE", "I"},
                ifidx = {114, 5},
            },
            SCIMITAR = {
                id = 45447,
                levels = {"BASE", "I"},
                ifidx = {114, 7},
            },
            LONGSWORD = {
                id = 45449,
                levels = {"BASE", "I"},
                ifidx = {114, 9},
            },
            WARHAMMER = {
                id = 45451,
                levels = {"BASE", "I"},
                ifidx = {114, 11},
            },
            BATTLEAXE = {
                id = 45453,
                levels = {"BASE", "I"},
                ifidx = {114, 13},
            },
            CLAWS = {
                id = 45455,
                levels = {"BASE", "I"},
                ifidx = {114, 15},
            },
            TWO_HANDED_SWORD = {
                id = 45457,
                levels = {"BASE", "I"},
                ifidx = {114, 17},
            },
            HATCHET = {
                id = 1353,
                levels = {"BASE"},
                ifidx = {114, 19},
            },
            HASTA = {
                id = 11371,
                levels = {"BASE"},
                ifidx = {114, 21},
            },
            SPEAR = {
                id = 1241,
                levels = {"BASE"},
                ifidx = {114, 23},
            },
            OFF_HAND_DAGGER = {
                id = 45442,
                levels = {"BASE", "I"},
                ifidx = {125, 1},
            },
            OFF_HAND_MACE = {
                id = 45444,
                levels = {"BASE", "I"},
                ifidx = {125, 3},
            },
            OFF_HAND_SWORD = {
                id = 45446,
                levels = {"BASE", "I"},
                ifidx = {125, 5},
            },
            OFF_HAND_SCIMITAR = {
                id = 45448,
                levels = {"BASE", "I"},
                ifidx = {125, 7},
            },
            OFF_HAND_LONGSWORD = {
                id = 45450,
                levels = {"BASE", "I"},
                ifidx = {125, 9},
            },
            OFF_HAND_WARHAMMER = {
                id = 45452,
                levels = {"BASE", "I"},
                ifidx = {125, 11},
            },
            OFF_HAND_BATTLEAXE = {
                id = 45454,
                levels = {"BASE", "I"},
                ifidx = {125, 13},
            },
            OFF_HAND_CLAWS = {
                id = 45456,
                levels = {"BASE", "I"},
                ifidx = {125, 15},
            },
            ARROWHEADS = {
                id = 41,
                levels = {"BASE"},
                ifidx = {136, 1},
                stack = 75
            },
            DART_TIP = {
                id = 821,
                levels = {"BASE"},
                ifidx = {136, 3},
                stack = 50
            },
            BOLTS = {
                id = 9378,
                levels = {"BASE"},
                ifidx = {136, 5},
                stack = 50
            },
            LIMBS = {
                id = 9425,
                levels = {"BASE"},
                ifidx = {136, 7},
            },
            KNIFE = {
                id = 865,
                levels = {"BASE"},
                ifidx = {136, 9},
                stack = 25
            },
            OFF_HAND_KNIFE = {
                id = 25898,
                levels = {"BASE"},
                ifidx = {136, 11},
                stack = 25
            },
            THROWING_AXE = {
                id = 802,
                levels = {"BASE"},
                ifidx = {136, 13},
                stack = 25
            },
            OFF_HAND_THROWING_AXE = {
                id = 25905,
                levels = {"BASE"},
                ifidx = {136, 15},
                stack = 25
            },
            MASTERWORK_RIVETS = {
                id = 46003,
                levels = {"BASE"},
                ifidx = {147, 1},
                stack = 10
            },
            ORE_BOX = {
                id = 44783,
                levels = {"BASE"},
                ifidx = {147, 3},
            },
            NAILS = {
                id = 1539,
                levels = {"BASE"},
                ifidx = {147, 5},
                stack = 75
            },
            STUDS = {
                id = 2370,
                levels = {"BASE"},
                ifidx = {147, 7},
            },
            LANTERN = {
                id = 4544,
                levels = {"BASE"},
                ifidx = {147, 9},
            },
            PICKAXE = {
                id = 45467,
                levels = {"BASE", "I"},
                ifidx = {147, 11},
            },
            MATTOCK = {
                id = 49545,
                levels = {"BASE"},
                ifidx = {147, 13},
            },
        }
    },
    MITHRIL = {
        bar = {2359, 52, 7, 1493},
        items = {
            FULL_HELM = {
                id = 45485,
                levels = {"BASE", "I", "II"},
                ifidx = {103, 1},
            },
            MED_HELM = {
                id = 45486,
                levels = {"BASE", "I", "II"},
                ifidx = {103, 3},
            },
            PLATELEGS = {
                id = 45487,
                levels = {"BASE", "I", "II"},
                ifidx = {103, 5},
            },
            PLATESKIRT = {
                id = 45488,
                levels = {"BASE", "I", "II"},
                ifidx = {103, 7},
            },
            PLATEBODY = {
                id = 45489,
                levels = {"BASE", "I", "II"},
                ifidx = {103, 9},
            },
            CHAINBODY = {
                id = 45490,
                levels = {"BASE", "I", "II"},
                ifidx = {103, 11},
            },
            SQUARE_SHIELD = {
                id = 45491,
                levels = {"BASE", "I", "II"},
                ifidx = {103, 13},
            },
            KITESHIELD = {
                id = 45492,
                levels = {"BASE", "I", "II"},
                ifidx = {103, 15},
            },
            BOOTS = {
                id = 45493,
                levels = {"BASE", "I", "II"},
                ifidx = {103, 17},
            },
            GAUNTLETS = {
                id = 46278,
                levels = {"BASE", "I", "II"},
                ifidx = {103, 19},
            },
            DAGGER = {
                id = 45468,
                levels = {"BASE", "I", "II"},
                ifidx = {114, 1},
            },
            MACE = {
                id = 45470,
                levels = {"BASE", "I", "II"},
                ifidx = {114, 3},
            },
            SWORD = {
                id = 45472,
                levels = {"BASE", "I", "II"},
                ifidx = {114, 5},
            },
            SCIMITAR = {
                id = 45474,
                levels = {"BASE", "I", "II"},
                ifidx = {114, 7},
            },
            LONGSWORD = {
                id = 45476,
                levels = {"BASE", "I", "II"},
                ifidx = {114, 9},
            },
            WARHAMMER = {
                id = 45478,
                levels = {"BASE", "I", "II"},
                ifidx = {114, 11},
            },
            BATTLEAXE = {
                id = 45480,
                levels = {"BASE", "I", "II"},
                ifidx = {114, 13},
            },
            CLAWS = {
                id = 45482,
                levels = {"BASE", "I", "II"},
                ifidx = {114, 15},
            },
            TWO_HANDED_SWORD = {
                id = 45484,
                levels = {"BASE", "I", "II"},
                ifidx = {114, 17},
            },
            HATCHET = {
                id = 1355,
                levels = {"BASE"},
                ifidx = {114, 19},
            },
            HASTA = {
                id = 11373,
                levels = {"BASE"},
                ifidx = {114, 21},
            },
            SPEAR = {
                id = 1243,
                levels = {"BASE"},
                ifidx = {114, 23},
            },
            OFF_HAND_DAGGER = {
                id = 45469,
                levels = {"BASE", "I", "II"},
                ifidx = {125, 1},
            },
            OFF_HAND_MACE = {
                id = 45471,
                levels = {"BASE", "I", "II"},
                ifidx = {125, 3},
            },
            OFF_HAND_SWORD = {
                id = 45473,
                levels = {"BASE", "I", "II"},
                ifidx = {125, 5},
            },
            OFF_HAND_SCIMITAR = {
                id = 45475,
                levels = {"BASE", "I", "II"},
                ifidx = {125, 7},
            },
            OFF_HAND_LONGSWORD = {
                id = 45477,
                levels = {"BASE", "I", "II"},
                ifidx = {125, 9},
            },
            OFF_HAND_WARHAMMER = {
                id = 45479,
                levels = {"BASE", "I", "II"},
                ifidx = {125, 11},
            },
            OFF_HAND_BATTLEAXE = {
                id = 45481,
                levels = {"BASE", "I", "II"},
                ifidx = {125, 13},
            },
            OFF_HAND_CLAWS = {
                id = 45483,
                levels = {"BASE", "I", "II"},
                ifidx = {125, 15},
            },
            ARROWHEADS = {
                id = 42,
                levels = {"BASE"},
                ifidx = {136, 1},
                stack = 75
            },
            DART_TIP = {
                id = 822,
                levels = {"BASE"},
                ifidx = {136, 3},
                stack = 50
            },
            BOLTS = {
                id = 9379,
                levels = {"BASE"},
                ifidx = {136, 5},
                stack = 50
            },
            LIMBS = {
                id = 9427,
                levels = {"BASE"},
                ifidx = {136, 7},
            },
            KNIFE = {
                id = 866,
                levels = {"BASE"},
                ifidx = {136, 9},
                stack = 25
            },
            OFF_HAND_KNIFE = {
                id = 25899,
                levels = {"BASE"},
                ifidx = {136, 11},
                stack = 25
            },
            THROWING_AXE = {
                id = 803,
                levels = {"BASE"},
                ifidx = {136, 13},
                stack = 25
            },
            OFF_HAND_THROWING_AXE = {
                id = 25906,
                levels = {"BASE"},
                ifidx = {136, 15},
                stack = 25
            },
            ORE_BOX = {
                id = 44785,
                levels = {"BASE"},
                ifidx = {147, 1},
            },
            NAILS = {
                id = 4822,
                levels = {"BASE"},
                ifidx = {147, 3},
                stack = 75
            },
            GRAPPLE_TIP = {
                id = 9416,
                levels = {"BASE"},
                ifidx = {147, 5},
            },
            PICKAXE = {
                id = 45494,
                levels = {"BASE", "I", "II"},
                ifidx = {147, 7},
            },
            MATTOCK = {
                id = 49548,
                levels = {"BASE"},
                ifidx = {147, 9},
            },
        }
    },
    ADAMANT = {
        bar = {2361, 52, 9, 1494},
        items = {
            FULL_HELM = {
                id = 45512,
                levels = {"BASE", "I", "II"},
                ifidx = {103, 1},
            },
            MED_HELM = {
                id = 45513,
                levels = {"BASE", "I", "II"},
                ifidx = {103, 3},
            },
            PLATELEGS = {
                id = 45514,
                levels = {"BASE", "I", "II"},
                ifidx = {103, 5},
            },
            PLATESKIRT = {
                id = 45515,
                levels = {"BASE", "I", "II"},
                ifidx = {103, 7},
            },
            PLATEBODY = {
                id = 45516,
                levels = {"BASE", "I", "II"},
                ifidx = {103, 9},
            },
            CHAINBODY = {
                id = 45517,
                levels = {"BASE", "I", "II"},
                ifidx = {103, 11},
            },
            SQUARE_SHIELD = {
                id = 45518,
                levels = {"BASE", "I", "II"},
                ifidx = {103, 13},
            },
            KITESHIELD = {
                id = 45519,
                levels = {"BASE", "I", "II"},
                ifidx = {103, 15},
            },
            BOOTS = {
                id = 45520,
                levels = {"BASE", "I", "II"},
                ifidx = {103, 17},
            },
            GAUNTLETS = {
                id = 45058,
                levels = {"BASE", "I", "II"},
                ifidx = {103, 19},
            },
            DAGGER = {
                id = 45495,
                levels = {"BASE", "I", "II"},
                ifidx = {114, 1},
            },
            MACE = {
                id = 45497,
                levels = {"BASE", "I", "II"},
                ifidx = {114, 3},
            },
            SWORD = {
                id = 45499,
                levels = {"BASE", "I", "II"},
                ifidx = {114, 5},
            },
            SCIMITAR = {
                id = 45501,
                levels = {"BASE", "I", "II"},
                ifidx = {114, 7},
            },
            LONGSWORD = {
                id = 45503,
                levels = {"BASE", "I", "II"},
                ifidx = {114, 9},
            },
            WARHAMMER = {
                id = 44926,
                levels = {"BASE", "I", "II"},
                ifidx = {114, 11},
            },
            BATTLEAXE = {
                id = 45507,
                levels = {"BASE", "I", "II"},
                ifidx = {114, 13},
            },
            CLAWS = {
                id = 45509,
                levels = {"BASE", "I", "II"},
                ifidx = {114, 15},
            },
            TWO_HANDED_SWORD = {
                id = 45511,
                levels = {"BASE", "I", "II"},
                ifidx = {114, 17},
            },
            HATCHET = {
                id = 1357,
                levels = {"BASE"},
                ifidx = {114, 19},
            },
            HASTA = {
                id = 11375,
                levels = {"BASE"},
                ifidx = {114, 21},
            },
            SPEAR = {
                id = 1245,
                levels = {"BASE"},
                ifidx = {114, 23},
            },
            OFF_HAND_DAGGER = {
                id = 45496,
                levels = {"BASE", "I", "II"},
                ifidx = {125, 1},
            },
            OFF_HAND_MACE = {
                id = 45498,
                levels = {"BASE", "I", "II"},
                ifidx = {125, 3},
            },
            OFF_HAND_SWORD = {
                id = 45500,
                levels = {"BASE", "I", "II"},
                ifidx = {125, 5},
            },
            OFF_HAND_SCIMITAR = {
                id = 45502,
                levels = {"BASE", "I", "II"},
                ifidx = {125, 7},
            },
            OFF_HAND_LONGSWORD = {
                id = 45504,
                levels = {"BASE", "I", "II"},
                ifidx = {125, 9},
            },
            OFF_HAND_WARHAMMER = {
                id = 44936,
                levels = {"BASE", "I", "II"},
                ifidx = {125, 11},
            },
            OFF_HAND_BATTLEAXE = {
                id = 45508,
                levels = {"BASE", "I", "II"},
                ifidx = {125, 13},
            },
            OFF_HAND_CLAWS = {
                id = 45510,
                levels = {"BASE", "I", "II"},
                ifidx = {125, 15},
            },
            ARROWHEADS = {
                id = 43,
                levels = {"BASE"},
                ifidx = {136, 1},
                stack = 75
            },
            DART_TIP = {
                id = 823,
                levels = {"BASE"},
                ifidx = {136, 3},
                stack = 50
            },
            BOLTS = {
                id = 9380,
                levels = {"BASE"},
                ifidx = {136, 5},
                stack = 50
            },
            LIMBS = {
                id = 9429,
                levels = {"BASE"},
                ifidx = {136, 7},
            },
            KNIFE = {
                id = 867,
                levels = {"BASE"},
                ifidx = {136, 9},
                stack = 25
            },
            OFF_HAND_KNIFE = {
                id = 25900,
                levels = {"BASE"},
                ifidx = {136, 11},
                stack = 25
            },
            THROWING_AXE = {
                id = 804,
                levels = {"BASE"},
                ifidx = {136, 13},
                stack = 25
            },
            OFF_HAND_THROWING_AXE = {
                id = 25907,
                levels = {"BASE"},
                ifidx = {136, 15},
                stack = 25
            },
            ORE_BOX = {
                id = 44787,
                levels = {"BASE"},
                ifidx = {147, 1},
            },
            NAILS = {
                id = 4823,
                levels = {"BASE"},
                ifidx = {147, 3},
                stack = 75
            },
            PICKAXE = {
                id = 45521,
                levels = {"BASE", "I", "II"},
                ifidx = {147, 5},
            },
            MATTOCK = {
                id = 49551,
                levels = {"BASE"},
                ifidx = {147, 7},
            },
        }
    },
    RUNE = {
        bar = {2363, 52, 11, 1495},
        items = {
            FULL_HELM = {
                id = 45539,
                levels = {"BASE", "I", "II", "III"},
                ifidx = {103, 1},
            },
            MED_HELM = {
                id = 45540,
                levels = {"BASE", "I", "II", "III"},
                ifidx = {103, 3},
            },
            PLATELEGS = {
                id = 45541,
                levels = {"BASE", "I", "II", "III"},
                ifidx = {103, 5},
            },
            PLATESKIRT = {
                id = 45542,
                levels = {"BASE", "I", "II", "III"},
                ifidx = {103, 7},
            },
            PLATEBODY = {
                id = 45543,
                levels = {"BASE", "I", "II", "III"},
                ifidx = {103, 9},
            },
            CHAINBODY = {
                id = 45544,
                levels = {"BASE", "I", "II", "III"},
                ifidx = {103, 11},
            },
            SQUARE_SHIELD = {
                id = 45545,
                levels = {"BASE", "I", "II", "III"},
                ifidx = {103, 13},
            },
            KITESHIELD = {
                id = 45546,
                levels = {"BASE", "I", "II", "III"},
                ifidx = {103, 15},
            },
            BOOTS = {
                id = 45547,
                levels = {"BASE", "I", "II", "III"},
                ifidx = {103, 17},
            },
            GAUNTLETS = {
                id = 46929,
                levels = {"BASE", "I", "II", "III"},
                ifidx = {103, 19},
            },
            DAGGER = {
                id = 45522,
                levels = {"BASE", "I", "II", "III"},
                ifidx = {114, 1},
            },
            MACE = {
                id = 45524,
                levels = {"BASE", "I", "II", "III"},
                ifidx = {114, 3},
            },
            SWORD = {
                id = 45526,
                levels = {"BASE", "I", "II", "III"},
                ifidx = {114, 5},
            },
            SCIMITAR = {
                id = 45528,
                levels = {"BASE", "I", "II", "III"},
                ifidx = {114, 7},
            },
            LONGSWORD = {
                id = 45530,
                levels = {"BASE", "I", "II", "III"},
                ifidx = {114, 9},
            },
            WARHAMMER = {
                id = 45532,
                levels = {"BASE", "I", "II", "III"},
                ifidx = {114, 11},
            },
            BATTLEAXE = {
                id = 45534,
                levels = {"BASE", "I", "II", "III"},
                ifidx = {114, 13},
            },
            CLAWS = {
                id = 45536,
                levels = {"BASE", "I", "II", "III"},
                ifidx = {114, 15},
            },
            TWO_HANDED_SWORD = {
                id = 45538,
                levels = {"BASE", "I", "II", "III"},
                ifidx = {114, 17},
            },
            HATCHET = {
                id = 1359,
                levels = {"BASE"},
                ifidx = {114, 19},
            },
            HASTA = {
                id = 11377,
                levels = {"BASE"},
                ifidx = {114, 21},
            },
            SPEAR = {
                id = 1247,
                levels = {"BASE"},
                ifidx = {114, 23},
            },
            OFF_HAND_DAGGER = {
                id = 45523,
                levels = {"BASE", "I", "II", "III"},
                ifidx = {125, 1},
            },
            OFF_HAND_MACE = {
                id = 45525,
                levels = {"BASE", "I", "II", "III"},
                ifidx = {125, 3},
            },
            OFF_HAND_SWORD = {
                id = 45527,
                levels = {"BASE", "I", "II", "III"},
                ifidx = {125, 5},
            },
            OFF_HAND_SCIMITAR = {
                id = 45529,
                levels = {"BASE", "I", "II", "III"},
                ifidx = {125, 7},
            },
            OFF_HAND_LONGSWORD = {
                id = 45531,
                levels = {"BASE", "I", "II", "III"},
                ifidx = {125, 9},
            },
            OFF_HAND_WARHAMMER = {
                id = 45533,
                levels = {"BASE", "I", "II", "III"},
                ifidx = {125, 11},
            },
            OFF_HAND_BATTLEAXE = {
                id = 45535,
                levels = {"BASE", "I", "II", "III"},
                ifidx = {125, 13},
            },
            OFF_HAND_CLAWS = {
                id = 45537,
                levels = {"BASE", "I", "II", "III"},
                ifidx = {125, 15},
            },
            ARROWHEADS = {
                id = 44,
                levels = {"BASE"},
                ifidx = {136, 1},
                stack = 75
            },
            DART_TIP = {
                id = 824,
                levels = {"BASE"},
                ifidx = {136, 3},
                stack = 50
            },
            BOLTS = {
                id = 9381,
                levels = {"BASE"},
                ifidx = {136, 5},
                stack = 50
            },
            LIMBS = {
                id = 9431,
                levels = {"BASE"},
                ifidx = {136, 7},
            },
            KNIFE = {
                id = 868,
                levels = {"BASE"},
                ifidx = {136, 9},
                stack = 25
            },
            OFF_HAND_KNIFE = {
                id = 25901,
                levels = {"BASE"},
                ifidx = {136, 11},
                stack = 25
            },
            THROWING_AXE = {
                id = 805,
                levels = {"BASE"},
                ifidx = {136, 13},
                stack = 25
            },
            OFF_HAND_THROWING_AXE = {
                id = 25908,
                levels = {"BASE"},
                ifidx = {136, 15},
                stack = 25
            },
            ORE_BOX = {
                id = 44789,
                levels = {"BASE"},
                ifidx = {147, 1},
            },
            NAILS = {
                id = 4824,
                levels = {"BASE"},
                ifidx = {147, 3},
                stack = 75
            },
            PICKAXE = {
                id = 45548,
                levels = {"BASE", "I", "II", "III"},
                ifidx = {147, 5},
            },
            MATTOCK = {
                id = 49554,
                levels = {"BASE"},
                ifidx = {147, 7},
            },
        }
    },
    ORIKALKUM = {
        bar = {44838, 52, 13, 1496},
        items = {
            FULL_HELM = {
                id = 46591,
                levels = {"BASE", "I", "II", "III"},
                ifidx = {103, 1},
            },
            PLATELEGS = {
                id = 46604,
                levels = {"BASE", "I", "II", "III"},
                ifidx = {103, 3},
            },
            PLATEBODY = {
                id = 46617,
                levels = {"BASE", "I", "II", "III"},
                ifidx = {103, 5},
            },
            KITESHIELD = {
                id = 46630,
                levels = {"BASE", "I", "II", "III"},
                ifidx = {103, 7},
            },
            BOOTS = {
                id = 46643,
                levels = {"BASE", "I", "II", "III"},
                ifidx = {103, 9},
            },
            GAUNTLETS = {
                id = 46656,
                levels = {"BASE", "I", "II", "III"},
                ifidx = {103, 11},
            },
            WARHAMMER = {
                id = 46539,
                levels = {"BASE", "I", "II", "III"},
                ifidx = {114, 1},
            },
            TWO_HANDED_WARHAMMER = {
                id = 46565,
                levels = {"BASE", "I", "II", "III"},
                ifidx = {114, 3},
            },
            OFF_HAND_WARHAMMER = {
                id = 46552,
                levels = {"BASE", "I", "II", "III"},
                ifidx = {125, 1},
            },
            ORE_BOX = {
                id = 44791,
                levels = {"BASE"},
                ifidx = {136, 1},
            },
            PICKAXE = {
                id = 46578,
                levels = {"BASE", "I", "II", "III"},
                ifidx = {136, 3},
            },
            MATTOCK = {
                id = 49557,
                levels = {"BASE"},
                ifidx = {136, 5},
            },
        }
    },
    NECRONIUM = {
        bar = {44840, 52, 15, 1497},
        items = {
            FULL_HELM = {
                id = 46383,
                levels = {"BASE", "I", "II", "III", "IV"},
                ifidx = {103, 1},
            },
            PLATELEGS = {
                id = 46409,
                levels = {"BASE", "I", "II", "III", "IV"},
                ifidx = {103, 3},
            },
            PLATEBODY = {
                id = 46435,
                levels = {"BASE", "I", "II", "III", "IV"},
                ifidx = {103, 5},
            },
            KITESHIELD = {
                id = 46461,
                levels = {"BASE", "I", "II", "III", "IV"},
                ifidx = {103, 7},
            },
            BOOTS = {
                id = 46487,
                levels = {"BASE", "I", "II", "III", "IV"},
                ifidx = {103, 9},
            },
            GAUNTLETS = {
                id = 46513,
                levels = {"BASE", "I", "II", "III", "IV"},
                ifidx = {103, 11},
            },
            BATTLEAXE = {
                id = 46294,
                levels = {"BASE", "I", "II", "III", "IV"},
                ifidx = {114, 1},
            },
            TWO_HANDED_GREATAXE = {
                id = 46346,
                levels = {"BASE", "I", "II", "III", "IV"},
                ifidx = {114, 3},
            },
            OFF_HAND_BATTLEAXE = {
                id = 46320,
                levels = {"BASE", "I", "II", "III", "IV"},
                ifidx = {125, 1},
            },
            ORE_BOX = {
                id = 44793,
                levels = {"BASE"},
                ifidx = {136, 1},
            },
            PICKAXE = {
                id = 46372,
                levels = {"BASE", "I", "II", "III", "IV"},
                ifidx = {136, 3},
            },
            MATTOCK = {
                id = 49560,
                levels = {"BASE"},
                ifidx = {136, 5},
            },
        }
    },
    BANE = {
        bar = {44842, 52, 17, 1498},
        items = {
            FULL_HELM = {
                id = 45165,
                levels = {"BASE", "I", "II", "III", "IV"},
                ifidx = {103, 1},
            },
            PLATELEGS = {
                id = 45191,
                levels = {"BASE", "I", "II", "III", "IV"},
                ifidx = {103, 3},
            },
            PLATEBODY = {
                id = 45217,
                levels = {"BASE", "I", "II", "III", "IV"},
                ifidx = {103, 5},
            },
            SQUARE_SHIELD = {
                id = 45243,
                levels = {"BASE", "I", "II", "III", "IV"},
                ifidx = {103, 7},
            },
            BOOTS = {
                id = 45269,
                levels = {"BASE", "I", "II", "III", "IV"},
                ifidx = {103, 9},
            },
            GAUNTLETS = {
                id = 45295,
                levels = {"BASE", "I", "II", "III", "IV"},
                ifidx = {103, 11},
            },
            LONGSWORD = {
                id = 45076,
                levels = {"BASE", "I", "II", "III", "IV"},
                ifidx = {114, 1},
            },
            TWO_HANDED_SWORD = {
                id = 45128,
                levels = {"BASE", "I", "II", "III", "IV"},
                ifidx = {114, 3},
            },
            OFF_HAND_LONGSWORD = {
                id = 45102,
                levels = {"BASE", "I", "II", "III", "IV"},
                ifidx = {125, 1},
            },
            ORE_BOX = {
                id = 44795,
                levels = {"BASE"},
                ifidx = {147, 1},
            },
            PICKAXE = {
                id = 45154,
                levels = {"BASE", "I", "II", "III", "IV"},
                ifidx = {147, 3},
            },
            MATTOCK = {
                id = 49562,
                levels = {"BASE"},
                ifidx = {147, 5},
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
                ifidx = {136, 7},
                stack = 1000
            }
        }
    },
    PRIMAL = {
        bar = {57435, 52, 21, 13879},
        items = {
            FULL_HELM = {
                id = 57265,
                levels = {"BASE", "I", "II", "III", "IV", "V"},
                ifidx = {103, 1}
            },
            PLATELEGS = {
                id = 57358,
                levels = {"BASE", "I", "II", "III", "IV", "V"},
                ifidx = {103, 3}
            },
            PLATEBODY = {
                id = 57327,
                levels = {"BASE", "I", "II", "III", "IV", "V"},
                ifidx = {103, 5}
            },
            KITESHIELD = {
                id = 57296,
                levels = {"BASE", "I", "II", "III", "IV", "V"},
                ifidx = {103, 7}
            },
            BOOTS = {
                id = 57203,
                levels = {"BASE", "I", "II", "III", "IV", "V"},
                ifidx = {103, 9}
            },
            GAUNTLETS = {
                id = 57234,
                levels = {"BASE", "I", "II", "III", "IV", "V"},
                ifidx = {103, 11}
            },
            TWO_HANDED_SWORD = {
                id = 57404,
                levels = {"BASE", "I", "II", "III", "IV", "V"},
                ifidx = {114, 1}
            },
            ORE_BOX = {
                id = 57172,
                levels = {"BASE"},
                ifidx = {125, 1}
            },
            PICKAXE = {
                id = 57391,
                levels = {"BASE", "I", "II", "III", "IV", "V"},
                ifidx = {125, 3}
            },
            ARMOUR_SPIKES = {
                id = 57389,
                levels = {"BASE"},
                ifidx = {125, 5},
                stack = 1000
            }
        },
    },
    MASTERWORK = {
        bar = {45991, 62, 7, 1500},
        items = {
            MASTERWORK_PLATE = {
                id = 45993,
                levels = {"BASE"},
                ifidx = {103, 7}
            },
            CURVED_MASTERWORK_PLATE = {
                id = 45995,
                levels = {"BASE"},
                ifidx = {103, 9}
            },
            UNTEMPERED_MASTERWORK_ARMOUR_PIECE = {
                id = 45997,
                levels = {"BASE"},
                ifidx = {103, 11}
            },
            MASTERWORK_ARMOUR_PIECE = {
                id = 45999,
                levels = {"BASE"},
                ifidx = {103, 13}
            },
        }
    }
}

return TYPES
