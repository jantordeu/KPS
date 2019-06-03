--[[
Healers spells
]]--
kps.spells.healer = {
    -- Priests Discipline
    [047540] = "PRIEST", -- Penance XXX strange error received from user on 2015-10-15 (this spell was cast by a hunter...)
    [109964] = "PRIEST", -- Spirit shell -- not seen in disc
    [002060] = "PRIEST", -- Greater Heal
    [014914] = "PRIEST", -- Holy Fire
    [033206] = "PRIEST", -- Pain Suppression
    [000596] = "PRIEST", -- Prayer of Healing
    [000527] = "PRIEST", -- Purify
    [081749] = "PRIEST", -- Atonement
    [132157] = "PRIEST", -- Holy Nova

    -- Priests Holy
    [034861] = "PRIEST", -- Circle of Healing
    [064843] = "PRIEST", -- Divine Hymn
    [047788] = "PRIEST", -- Guardian Spirit
    [032546] = "PRIEST", -- Binding Heal
    [077485] = "PRIEST", -- Mastery: Echo of Light -- the passibe ability
    [077489] = "PRIEST", -- Echo of Light -- the aura applied by the afformentioned
    [000139] = "PRIEST", -- Renew

    -- Druids
    --[018562] = "DRUID", -- Swiftmend -- (also available through restoration afinity talent)
    [102342] = "DRUID", -- Ironbark
    [033763] = "DRUID", -- Lifebloom
    [088423] = "DRUID", -- Nature's Cure
    -- [008936] = "DRUID", -- Regrowth -- (also available through restoration afinity talent)
    [033891] = "DRUID", -- Incarnation: Tree of Life
    [048438] = "DRUID", -- Wild Growth
    [000740] = "DRUID", -- Tranquility
    -- [145108] = "DRUID", -- Ysera's Gift -- (also available through restoration afinity talent)
    -- [000774] = "DRUID", -- Rejuvination -- (also available through restoration afinity talent)

    -- Shamans
    [061295] = "SHAMAN", -- Riptide
    [077472] = "SHAMAN", -- Healing Wave
    [098008] = "SHAMAN", -- Spirit link totem
    [001064] = "SHAMAN", -- Chain Heal
    [073920] = "SHAMAN", -- Healing Rain

    -- Paladins
    [020473] = "PALADIN", -- Holy Shock
    [053563] = "PALADIN", -- Beacon of Light
    [082326] = "PALADIN", -- Holy Light
    [085222] = "PALADIN", -- Light of Dawn

    -- Monks
    [115175] = "MONK", -- Soothing Mist
    [115310] = "MONK", -- Revival
    [116670] = "MONK", -- Vivify
    [116680] = "MONK", -- Thunder Focus Tea
    [116849] = "MONK", -- Life Cocoon
    [119611] = "MONK", -- Renewing mist
}



kps.spells.crowdControl = {
    ----------------
    -- Demonhunter
    ----------------
    [179057] = "CC",                -- Chaos Nova
    [205630] = "CC",                -- Illidan's Grasp
    [208618] = "CC",                -- Illidan's Grasp (throw stun)
    [217832] = "CC",                -- Imprison
    [221527] = "CC",                -- Imprison (pvp talent)
    [204843] = "Snare",             -- Sigil of Chains
    [207685] = "CC",                -- Sigil of Misery
    [204490] = "Silence",           -- Sigil of Silence
    [211881] = "CC",                -- Fel Eruption
    [200166] = "CC",                -- Metamorfosis stun
    [247121] = "Snare",             -- Metamorfosis snare
    [196555] = "Immune",            -- Netherwalk
    [213491] = "CC",                -- Demonic Trample Stun
    [206649] = "Silence",           -- Eye of Leotheras (no silence, 4% dmg and duration reset for spell casted)
    [232538] = "Snare",             -- Rain of Chaos
    [213405] = "Snare",             -- Master of the Glaive
    [210003] = "Snare",             -- Razor Spikes
    [198813] = "Snare",             -- Vengeful Retreat
    

    ----------------
    -- Death Knight
    ----------------
    [108194] = "CC",                -- Asphyxiate
    [221562] = "CC",                -- Asphyxiate
    [47476]  = "Silence",           -- Strangulate
    [96294]  = "Root",              -- Chains of Ice (Chilblains)
    [45524]  = "Snare",             -- Chains of Ice
    [115018] = "Other",             -- Desecrated Ground (Immune to CC)
    [207319] = "Immune",            -- Corpse Shield (not immune, 90% damage redirected to pet)
    [48707]  = "ImmuneSpell",       -- Anti-Magic Shell
    [48792]  = "Other",             -- Icebound Fortitude
    [49039]  = "Other",             -- Lichborne
    [51271]  = "Other",             -- Pillar of Frost
    [207167] = "CC",                -- Blinding Sleet
    [207165] = "CC",                -- Abomination's Might
    [207171] = "Root",              -- Winter is Coming
    [287254] = "CC",                -- Dead of Winter (pvp talent)
    [210141] = "CC",                -- Zombie Explosion (Reanimation PvP Talent)
    [206961] = "CC",                -- Tremble Before Me
    [248406] = "CC",                -- Cold Heart (legendary)
    [233395] = "Root",              -- Deathchill (pvp talent)
    [204085] = "Root",              -- Deathchill (pvp talent)
    [273977] = "Snare",             -- Grip of the Dead
    [206930] = "Snare",             -- Heart Strike
    [228645] = "Snare",             -- Heart Strike
    [211831] = "Snare",             -- Abomination's Might (slow)
    [200646] = "Snare",             -- Unholy Mutation
    [143375] = "Snare",             -- Tightening Grasp
    [211793] = "Snare",             -- Remorseless Winter
    [208278] = "Snare",             -- Debilitating Infestation
    [212764] = "Snare",             -- White Walker
    [190780] = "Snare",             -- Frost Breath (Sindragosa's Fury) (artifact trait)
    [191719] = "Snare",             -- Gravitational Pull (artifact trait)
    [204206] = "Snare",             -- Chill Streak (pvp honor talent)
    
        ----------------
        -- Death Knight Ghoul
        ----------------
        [212332] = "CC",                -- Smash
        [212336] = "CC",                -- Smash
        [212337] = "CC",                -- Powerful Smash
        [47481]  = "CC",                -- Gnaw
        [91800]  = "CC",                -- Gnaw
        [91797]  = "CC",                -- Monstrous Blow (Dark Transformation)
        [91807]  = "Root",              -- Shambling Rush (Dark Transformation)
        [212540] = "Root",              -- Flesh Hook (Abomination)
    
    ----------------
    -- Druid
    ----------------
    [33786]  = "CC",                -- Cyclone
    [209753] = "CC",                -- Cyclone
    [99]     = "CC",                -- Incapacitating Roar
    [236748] = "CC",                -- Intimidating Roar
    [163505] = "CC",                -- Rake
    [22570]  = "CC",                -- Maim
    [203123] = "CC",                -- Maim
    [203126] = "CC",                -- Maim (pvp honor talent)
    [236025] = "CC",                -- Enraged Maim (pvp honor talent)
    [5211]   = "CC",                -- Mighty Bash
    [2637]   = "CC",                -- Hibernate
    [81261]  = "Silence",           -- Solar Beam
    [339]    = "Root",              -- Entangling Roots
    [235963] = "CC",                -- Entangling Roots (Earthen Grasp - feral pvp talent) -- Also -80% hit chance (CC and Root category)
    [45334]  = "Root",              -- Immobilized (Wild Charge - Bear)
    [102359] = "Root",              -- Mass Entanglement
    [102793] = "Snare",             -- Ursol's Vortex
    [50259]  = "Snare",             -- Dazed (Wild Charge - Cat)
    [58180]  = "Snare",             -- Infected Wounds
    [61391]  = "Snare",             -- Typhoon
    [127797] = "Snare",             -- Ursol's Vortex
    [50259]  = "Snare",             -- Wild Charge (Dazed)
    [102543] = "Other",             -- Incarnation: King of the Jungle
    [106951] = "Other",             -- Berserk
    [102558] = "Other",             -- Incarnation: Guardian of Ursoc
    [102560] = "Other",             -- Incarnation: Chosen of Elune
    [202244] = "CC",                -- Overrun (pvp honor talent)
    [209749] = "Disarm",            -- Faerie Swarm (pvp honor talent)
    
    ----------------
    -- Hunter
    ----------------
    [117526] = "Root",              -- Binding Shot
    [3355]   = "CC",                -- Freezing Trap
    [13809]  = "CC",                -- Ice Trap 1
    [195645] = "Snare",             -- Wing Clip
    [19386]  = "CC",                -- Wyvern Sting
    [128405] = "Root",              -- Narrow Escape
    [201158] = "Root",              -- Super Sticky Tar (root)
    [111735] = "Snare",             -- Tar
    [135299] = "Snare",             -- Tar Trap
    [5116]   = "Snare",             -- Concussive Shot
    [194279] = "Snare",             -- Caltrops
    [206755] = "Snare",             -- Ranger's Net (snare)
    [236699] = "Snare",             -- Super Sticky Tar (slow)
    [213691] = "CC",                -- Scatter Shot (pvp honor talent)
    [186265] = "Immune",            -- Deterrence (aspect of the turtle)
    [19574]  = "ImmuneSpell",       -- Bestial Wrath (only if The Beast Within (212704) it's active) (immune to some CC's)
    [190927] = "Root",              -- Harpoon
    [212331] = "Root",              -- Harpoon
    [212353] = "Root",              -- Harpoon
    [162480] = "Root",              -- Steel Trap
    [200108] = "Root",              -- Ranger's Net
    [212638] = "CC",                -- Tracker's Net (pvp honor talent) -- Also -80% hit chance melee & range physical (CC and Root category)
    [186387] = "Snare",             -- Bursting Shot
    [224729] = "Snare",             -- Bursting Shot
    [203337] = "CC",                -- Freezing Trap (Diamond Ice - pvp honor talent)
    [202748] = "Immune",            -- Survival Tactics (pvp honor talent) (not immune, 99% damage reduction)
    [248519] = "ImmuneSpell",       -- Interlope (pvp honor talent)
    --[202914] = "Silence",         -- Spider Sting (pvp honor talent) --no silence, this its the previous effect
    [202933] = "Silence",           -- Spider Sting (pvp honor talent) --this its the silence effect
    [5384]   = "Other",             -- Feign Death
    
        ----------------
        -- Hunter Pets
        ----------------
        [24394]  = "CC",                -- Intimidation
        [50433]  = "Snare",             -- Ankle Crack (Crocolisk)
        [54644]  = "Snare",             -- Frost Breath (Chimaera)
        [35346]  = "Snare",             -- Warp Time (Warp Stalker)
        [160067] = "Snare",             -- Web Spray (Spider)
        [160065] = "Snare",             -- Tendon Rip (Silithid)
        [54216]  = "Other",             -- Master's Call (root and snare immune only)
        [53148]  = "Root",              -- Charge (tenacity ability)
        [137798] = "ImmuneSpell",       -- Reflective Armor Plating (Direhorn)

    ----------------
    -- Mage
    ----------------
    [44572]  = "CC",                -- Deep Freeze
    [31661]  = "CC",                -- Dragon's Breath
    [118]    = "CC",                -- Polymorph
    [61305]  = "CC",                -- Polymorph: Black Cat
    [28272]  = "CC",                -- Polymorph: Pig
    [61721]  = "CC",                -- Polymorph: Rabbit
    [61780]  = "CC",                -- Polymorph: Turkey
    [28271]  = "CC",                -- Polymorph: Turtle
    [161353] = "CC",                -- Polymorph: Polar bear cub
    [126819] = "CC",                -- Polymorph: Porcupine
    [161354] = "CC",                -- Polymorph: Monkey
    [61025]  = "CC",                -- Polymorph: Serpent
    [161355] = "CC",                -- Polymorph: Penguin
    [277787] = "CC",                -- Polymorph: Direhorn
    [277792] = "CC",                -- Polymorph: Bumblebee
    [82691]  = "CC",                -- Ring of Frost
    [140376] = "CC",                -- Ring of Frost
    [122]    = "Root",              -- Frost Nova
    [111340] = "Root",              -- Ice Ward
    [120]    = "Snare",             -- Cone of Cold
    [116]    = "Snare",             -- Frostbolt
    [44614]  = "Snare",             -- Frostfire Bolt
    [31589]  = "Snare",             -- Slow
    [10]     = "Snare",             -- Blizzard
    [205708] = "Snare",             -- Chilled
    [212792] = "Snare",             -- Cone of Cold
    [205021] = "Snare",             -- Ray of Frost
    [135029] = "Snare",             -- Water Jet
    [59638]  = "Snare",             -- Frostbolt (Mirror Images)
    [228354] = "Snare",             -- Flurry
    [157981] = "Snare",             -- Blast Wave
    [2120]   = "Snare",             -- Flamestrike
    [236299] = "Snare",             -- Chrono Shift
    [45438]  = "Immune",            -- Ice Block
    [198121] = "Root",              -- Frostbite (pvp talent)
    [220107] = "Root",              -- Frostbite
    [157997] = "Root",              -- Ice Nova
    [228600] = "Root",              -- Glacial Spike
    [110959] = "Other",             -- Greater Invisibility
    [198144] = "Other",             -- Ice form (stun/knockback immune)
    [12042]  = "Other",             -- Arcane Power
    [198111] = "Immune",            -- Temporal Shield (heals all damage taken after 4 sec)

        ----------------
        -- Mage Water Elemental
        ----------------
        [33395]  = "Root",              -- Freeze

    ----------------
    -- Monk
    ----------------
    [123393] = "CC",                -- Breath of Fire (Glyph of Breath of Fire)
    [119392] = "CC",                -- Charging Ox Wave
    [119381] = "CC",                -- Leg Sweep
    [115078] = "CC",                -- Paralysis
    [116706] = "Root",              -- Disable
    [116095] = "Snare",             -- Disable
    [118585] = "Snare",             -- Leer of the Ox
    [123586] = "Snare",             -- Flying Serpent Kick
    [121253] = "Snare",             -- Keg Smash
    [196733] = "Snare",             -- Special Delivery
    [205320] = "Snare",             -- Strike of the Windlord (artifact trait)
    [125174] = "Immune",            -- Touch of Karma
    [198909] = "CC",                -- Song of Chi-Ji
    [233759] = "Disarm",            -- Grapple Weapon
    [202274] = "CC",                -- Incendiary Brew (honor talent)
    [202346] = "CC",                -- Double Barrel (honor talent)
    [123407] = "Root",              -- Spinning Fire Blossom (honor talent)
    [214326] = "Other",             -- Exploding Keg (artifact trait - blind)
    [199387] = "Snare",             -- Spirit Tether (artifact trait)

    ----------------
    -- Paladin
    ----------------
    [105421] = "CC",                -- Blinding Light
    [105593] = "CC",                -- Fist of Justice
    [853]    = "CC",                -- Hammer of Justice
    [20066]  = "CC",                -- Repentance
    [31935]  = "Silence",           -- Avenger's Shield
    [187219] = "Silence",           -- Avenger's Shield (pvp talent)
    [199512] = "Silence",           -- Avenger's Shield (unknow use)
    [217824] = "Silence",           -- Shield of Virtue (pvp honor talent)
    [204242] = "Snare",             -- Consecration (talent Consecrated Ground)
    [183218] = "Snare",             -- Hand of Hindrance
    [642]    = "Immune",            -- Divine Shield
    [184662] = "Other",             -- Shield of Vengeance
    [31821]  = "Other",             -- Aura Mastery
    [1022]   = "ImmunePhysical",    -- Hand of Protection
    [204018] = "ImmuneSpell",       -- Blessing of Spellwarding
    [228050] = "Immune",            -- Divine Shield (Guardian of the Forgotten Queen)
    [205273] = "Snare",             -- Wake of Ashes (artifact trait) (snare)
    [205290] = "CC",                -- Wake of Ashes (artifact trait) (stun)
    [255937] = "Snare",             -- Wake of Ashes (talent) (snare)
    [255941] = "CC",                -- Wake of Ashes (talent) (stun)
    [199448] = "Immune",            -- Blessing of Sacrifice (Ultimate Sacrifice pvp talent) (not immune, 100% damage transfered to paladin)

    ----------------
    -- Priest
    ----------------
    [605]    = "CC",                -- Dominate Mind
    [64044]  = "CC",                -- Psychic Horror
    [8122]   = "CC",                -- Psychic Scream
    [9484]   = "CC",                -- Shackle Undead
    [87204]  = "CC",                -- Sin and Punishment
    [15487]  = "Silence",           -- Silence
    [64058]  = "Disarm",            -- Psychic Horror
    [87194]  = "Root",              -- Glyph of Mind Blast
    [114404] = "Root",              -- Void Tendril's Grasp
    [15407]  = "Snare",             -- Mind Flay
    [47585]  = "Immune",            -- Dispersion
    [47788]  = "Other",             -- Guardian Spirit (prevent the target from dying)
    [213602] = "Immune",            -- Greater Fade (pvp honor talent - protects vs spells. melee, ranged attacks + 50% speed)
    [232707] = "Immune",            -- Ray of Hope (pvp honor talent - not immune, only delay damage and heal)
    [213610] = "Other",             -- Holy Ward (pvp honor talent - wards against the next loss of control effect)
    [226943] = "CC",                -- Mind Bomb
    [200196] = "CC",                -- Holy Word: Chastise
    [200200] = "CC",                -- Holy Word: Chastise (talent)
    [204263] = "Snare",             -- Shining Force
    [199845] = "Snare",             -- Psyflay (pvp honor talent - Psyfiend)
    [210979] = "Snare",             -- Focus in the Light (artifact trait)

    ----------------
    -- Rogue
    ----------------
    [2094]   = "CC",                -- Blind
    [1833]   = "CC",                -- Cheap Shot
    [1776]   = "CC",                -- Gouge
    [408]    = "CC",                -- Kidney Shot
    [6770]   = "CC",                -- Sap
    [196958] = "CC",                -- Strike from the Shadows (stun effect)
    [1330]   = "Silence",           -- Garrote - Silence
    [280322] = "Silence",           -- Garrote - Silence
    [3409]   = "Snare",             -- Crippling Poison
    [26679]  = "Snare",             -- Deadly Throw
    [185763] = "Snare",             -- Pistol Shot
    [185778] = "Snare",             -- Shellshocked
    [206760] = "Snare",             -- Night Terrors
    [222775] = "Snare",             -- Strike from the Shadows (daze effect)
    [152150] = "Immune",            -- Death from Above (in the air you are immune to CC)
    [31224]  = "ImmuneSpell",       -- Cloak of Shadows
    [51690]  = "Other",             -- Killing Spree
    [13750]  = "Other",             -- Adrenaline Rush
    [199754] = "Other",             -- Riposte
    [1966]   = "Other",             -- Feint
    [45182]  = "Immune",            -- Cheating Death (-85% damage taken)
    [5277]   = "Other",             -- Evasion
    [212183] = "Other",             -- Smoke Bomb
    [199804] = "CC",                -- Between the eyes
    [199740] = "CC",                -- Bribe
    [207777] = "Disarm",            -- Dismantle
    [185767] = "Snare",             -- Cannonball Barrage
    [207736] = "Other",             -- Shadowy Duel
    [212150] = "CC",                -- Cheap Tricks (pvp honor talent) (-75%  melee & range physical hit chance)
    [199743] = "CC",                -- Parley
    [198222] = "Snare",             -- System Shock (pvp honor talent) (90% slow)
    [226364] = "Other",             -- Evasion (Shadow Swiftness, artifact trait)
    [209786] = "Snare",             -- Goremaw's Bite (artifact trait)
    

    ----------------
    -- Shaman
    ----------------
    [77505]  = "CC",                -- Earthquake
    [51514]  = "CC",                -- Hex
    [210873] = "CC",                -- Hex (compy)
    [211010] = "CC",                -- Hex (snake)
    [211015] = "CC",                -- Hex (cockroach)
    [211004] = "CC",                -- Hex (spider)
    [196942] = "CC",                -- Hex (Voodoo Totem)
    [269352] = "CC",                -- Hex (skeletal hatchling)
    [277778] = "CC",                -- Hex (zandalari Tendonripper)
    [277784] = "CC",                -- Hex (wicker mongrel)
    [118905] = "CC",                -- Static Charge (Capacitor Totem)
    [64695]  = "Root",              -- Earthgrab (Earthgrab Totem)
    [3600]   = "Snare",             -- Earthbind (Earthbind Totem)
    [116947] = "Snare",             -- Earthbind (Earthgrab Totem)
    [77478]  = "Snare",             -- Earthquake (Glyph of Unstable Earth)
    [8056]   = "Snare",             -- Frost Shock
    [196840] = "Snare",             -- Frost Shock
    [51490]  = "Snare",             -- Thunderstorm
    [147732] = "Snare",             -- Frostbrand Attack
    [197385] = "Snare",             -- Fury of Air
    [207498] = "Other",             -- Ancestral Protection (prevent the target from dying)
    [8178]   = "ImmuneSpell",       -- Grounding Totem Effect (Grounding Totem)
    [204399] = "CC",                -- Earthfury (PvP Talent)
    [192058] = "CC",                -- Lightning Surge totem (capacitor totem)
    [210918] = "ImmunePhysical",    -- Ethereal Form
    [204437] = "CC",                -- Lightning Lasso
    [197214] = "CC",                -- Sundering
    [224126] = "Snare",             -- Frozen Bite (Doom Wolves, artifact trait)
    [207654] = "Immune",            -- Servant of the Queen (not immune, 80% damage reduction - artifact trait)
    
        ----------------
        -- Shaman Pets
        ----------------
        [118345] = "CC",                -- Pulverize (Shaman Primal Earth Elemental)
        [157375] = "CC",                -- Gale Force (Primal Storm Elemental)

    ----------------
    -- Warlock
    ----------------
    [710]    = "CC",                -- Banish
    [5782]   = "CC",                -- Fear
    [118699] = "CC",                -- Fear
    [130616] = "CC",                -- Fear (Glyph of Fear)
    [5484]   = "CC",                -- Howl of Terror
    [22703]  = "CC",                -- Infernal Awakening
    [6789]   = "CC",                -- Mortal Coil
    [30283]  = "CC",                -- Shadowfury
    [31117]  = "Silence",           -- Unstable Affliction
    [196364] = "Silence",           -- Unstable Affliction
    [110913] = "Other",             -- Dark Bargain
    [104773] = "Other",             -- Unending Resolve
    [212295] = "ImmuneSpell",       -- Netherward (reflects spells)
    [233582] = "Root",              -- Entrenched in Flame (pvp honor talent)

        ----------------
        -- Warlock Pets
        ----------------
        [32752]  = "CC",            -- Summoning Disorientation
        [89766]  = "CC",            -- Axe Toss (Felguard/Wrathguard)
        [115268] = "CC",            -- Mesmerize (Shivarra)
        [6358]   = "CC",            -- Seduction (Succubus)
        [171017] = "CC",            -- Meteor Strike (infernal)
        [171018] = "CC",            -- Meteor Strike (abisal)
        [213688] = "CC",            -- Fel Cleave (Fel Lord - PvP Talent)
        [170996] = "Snare",         -- Debilitate (Terrorguard)
        [170995] = "Snare",         -- Cripple (Doomguard)
        [6360]   = "Snare",         -- Whiplash (Succubus)

    ----------------
    -- Warrior
    ----------------
    [118895] = "CC",                -- Dragon Roar
    [5246]   = "CC",                -- Intimidating Shout (aoe)
    [132168] = "CC",                -- Shockwave
    [107570] = "CC",                -- Storm Bolt
    [132169] = "CC",                -- Storm Bolt
    [46968]  = "CC",                -- Shockwave
    [213427] = "CC",                -- Charge Stun Talent (Warbringer)
    [7922]   = "CC",                -- Charge Stun Talent (Warbringer)
    [237744] = "CC",                -- Charge Stun Talent (Warbringer)
    [107566] = "Root",              -- Staggering Shout
    [105771] = "Root",              -- Charge (root)
    [236027] = "Snare",             -- Charge (snare)
    [118000] = "Snare",             -- Dragon Roar
    [147531] = "Snare",             -- Bloodbath
    [1715]   = "Snare",             -- Hamstring
    [12323]  = "Snare",             -- Piercing Howl
    [6343]   = "Snare",             -- Thunder Clap
    [46924]  = "Immune",            -- Bladestorm (not immune to dmg, only to LoC)
    [227847] = "Immune",            -- Bladestorm (not immune to dmg, only to LoC)
    [199038] = "Immune",            -- Leave No Man Behind (not immune, 90% damage reduction)
    [218826] = "Immune",            -- Trial by Combat (warr fury artifact hidden trait) (only immune to death)
    [23920]  = "ImmuneSpell",       -- Spell Reflection
    [216890] = "ImmuneSpell",       -- Spell Reflection
    [213915] = "ImmuneSpell",       -- Mass Spell Reflection
    [114028] = "ImmuneSpell",       -- Mass Spell Reflection
    [18499]  = "Other",             -- Berserker Rage
    [118038] = "Other",             -- Die by the Sword
    [198819] = "Other",             -- Sharpen Blade (70% heal reduction)
    [198760] = "ImmunePhysical",    -- Intercept (pvp honor talent) (intercept the next ranged or melee hit)
    [176289] = "CC",                -- Siegebreaker
    [199085] = "CC",                -- Warpath
    [199042] = "Root",              -- Thunderstruck
    [236236] = "Disarm",            -- Disarm (pvp honor talent - protection)
    [236077] = "Disarm",            -- Disarm (pvp honor talent)
    
    ----------------
    -- Other
    ----------------
    [56]     = "CC",                -- Stun (low lvl weapons proc)
    [835]    = "CC",                -- Tidal Charm (trinket)
    [30217]  = "CC",                -- Adamantite Grenade
    [67769]  = "CC",                -- Cobalt Frag Bomb
    [67890]  = "CC",                -- Cobalt Frag Bomb (belt)
    [30216]  = "CC",                -- Fel Iron Bomb
    [224074] = "CC",                -- Devilsaur's Bite (trinket)
    [127723] = "Root",              -- Covered In Watermelon (trinket)
    [195342] = "Snare",             -- Shrink Ray (trinket)
    [13327]  = "CC",                -- Reckless Charge
    [107079] = "CC",                -- Quaking Palm (pandaren racial)
    [20549]  = "CC",                -- War Stomp (tauren racial)
    [255723] = "CC",                -- Bull Rush (highmountain tauren racial)
    [214459] = "Silence",           -- Choking Flames (trinket)
    [19821]  = "Silence",           -- Arcane Bomb
    [131510] = "Immune",            -- Uncontrolled Banish
    [8346]   = "Root",              -- Mobility Malfunction (trinket)
    [39965]  = "Root",              -- Frost Grenade
    [55536]  = "Root",              -- Frostweave Net
    [13099]  = "Root",              -- Net-o-Matic (trinket)
    [16566]  = "Root",              -- Net-o-Matic (trinket)
    [15752]  = "Disarm",            -- Linken's Boomerang (trinket)
    [15753]  = "CC",                -- Linken's Boomerang (trinket)
    [1604]   = "Snare",             -- Dazed
    [221792] = "CC",                -- Kidney Shot (Vanessa VanCleef (Rogue Bodyguard))
    [222897] = "CC",                -- Storm Bolt (Dvalen Ironrune (Warrior Bodyguard))
    [222317] = "CC",                -- Mark of Thassarian (Thassarian (Death Knight Bodyguard))
    [212435] = "CC",                -- Shado Strike (Thassarian (Monk Bodyguard))
    [212246] = "CC",                -- Brittle Statue (The Monkey King (Monk Bodyguard))
    [238511] = "CC",                -- March of the Withered
    [252717] = "CC",                -- Light's Radiance (Argus powerup)
    [148535] = "CC",                -- Ordon Death Chime (trinket)
    [30504]  = "CC",                -- Poultryized! (trinket)
    [30501]  = "CC",                -- Poultryized! (trinket)
    [30506]  = "CC",                -- Poultryized! (trinket)
    [46567]  = "CC",                -- Rocket Launch (trinket)
    [24753]  = "CC",                -- Trick
    [245855] = "CC",                -- Belly Smash
    [262177] = "CC",                -- Into the Storm
    [255978] = "CC",                -- Pallid Glare
    [256050] = "CC",                -- Disoriented (Electroshock Mount Motivator)
    [258258] = "CC",                -- Quillbomb
    [260149] = "CC",                -- Quillbomb
    [258236] = "CC",                -- Sleeping Quill Dart
    [269186] = "CC",                -- Holographic Horror Projector
    [255228] = "CC",                -- Polymorphed (Organic Discombobulation Grenade)
    [272188] = "CC",                -- Hammer Smash (quest)
    [264860] = "CC",                -- Binding Talisman
    [268966] = "Root",              -- Hooked Deep Sea Net
    [268965] = "Snare",             -- Tidespray Linen Net
    -- PvE
    --[123456] = "PvE",             -- This is just an example, not a real spell
    ------------------------
    ---- PVE BFA
    ------------------------
    -- Crucible of Storms Raid
    -- -- Trash
    -- -- The Restless Cabal
    [282540] = "CC",                -- Agent of Demise
    [282589] = "CC",                -- Cerebral Assault
    [285154] = "CC",                -- Cerebral Assault
    [282517] = "CC",                -- Terrifying Echo
    [287876] = "CC",                -- Enveloping Darkness (healing and damage done reduced by 99%)
    [282432] = "Snare",             -- Crushing Doubt
    -- -- Uu'nat
    [285345] = "CC",                -- Maddening Eyes of N'Zoth
    [285562] = "CC",                -- Unknowable Terror
    [285685] = "CC",                -- Gift of N'Zoth: Lunacy
    [287693] = "Immune",            -- Sightless Bond (damage taken reduced by 99%)
    ------------------------
    -- Battle of Dazar'alor Raid
    -- -- Trash
    -- -- Champion of the Light
    [288294] = "Immune",            -- Divine Protection (damage taken reduced 99%)
    [283651] = "CC",                -- Blinding Faith
    -- -- Grong
    [289406] = "CC",                -- Bestial Throw
    [289412] = "CC",                -- Bestial Impact
    [285998] = "CC",                -- Ferocious Roar
    -- -- Jadefire Masters
    -- -- Opulence
    [278193] = "CC",                -- Crush
    [283609] = "CC",                -- Crush
    [283610] = "CC",                -- Crush
    -- -- Conclave of the Chosen
    [282079] = "Immune",            -- Loa's Pact (damage taken reduced 90%)
    [282135] = "CC",                -- Crawling Hex
    [290573] = "CC",                -- Crawling Hex
    [285879] = "CC",                -- Mind Wipe
    [265495] = "CC",                -- Static Orb
    [286838] = "CC",                -- Static Orb
    -- -- King Rastakhan
    [284995] = "CC",                -- Zombie Dust
    [284377] = "Immune",            -- Unliving
    -- -- High Tinker Mekkatorque
    [287167] = "CC",                -- Discombobulation
    [284214] = "CC",                -- Trample
    [289138] = "CC",                -- Trample
    [289644] = "Immune",            -- Spark Shield (damage taken reduced 99%)
    [282408] = "CC",                -- Spark Pulse (stun)
    [289232] = "CC",                -- Spark Pulse (hit chance reduced 100%)
    [289226] = "CC",                -- Spark Pulse (pacify)
    [286480] = "CC",                -- Anti-Tampering Shock
    [286516] = "CC",                -- Anti-Tampering Shock
    -- -- Stormwall Blockade
    [284121] = "Silence",           -- Thunderous Boom
    [286495] = "CC",                -- Tempting Song
    [284369] = "Snare",             -- Sea Storm
    -- -- Lady Jaina Proudmoore
    [287490] = "CC",                -- Frozen Solid
    [289963] = "CC",                -- Frozen Solid
    [285704] = "CC",                -- Frozen Solid
    [285708] = "CC",                -- Frozen Solid
    [287199] = "Root",              -- Ring of Ice
    [287626] = "Root",              -- Grasp of Frost
    [288412] = "Root",              -- Hand of Frost
    [288434] = "Root",              -- Hand of Frost
    [289219] = "Root",              -- Frost Nova
    [289855] = "CC",                -- Frozen Siege
    [275809] = "CC",                -- Flash Freeze
    [271527] = "Immune",            -- Ice Block
    [287322] = "Immune",            -- Ice Block
    [282841] = "Immune",            -- Arctic Armor
    [287282] = "Immune",            -- Arctic Armor (damage taken reduced 90%)
    [287418] = "Immune",            -- Arctic Armor (damage taken reduced 90%)
    [288219] = "Immune",            -- Refractive Ice (damage taken reduced 99%)
    ------------------------
    -- Uldir Raid
    -- -- Trash
    [277498] = "CC",                -- Mind Slave
    [277358] = "CC",                -- Mind Flay
    [278890] = "CC",                -- Violent Hemorrhage
    [278967] = "CC",                -- Winged Charge
    [260275] = "CC",                -- Rumbling Stomp
    [262375] = "CC",                -- Bellowing Roar
    [263321] = "Snare",             -- Undulating Mass
    -- -- Taloc
    [271965] = "Immune",            -- Powered Down (damage taken reduced 99%)
    -- -- Fetid Devourer
    [277800] = "CC",                -- Swoop
    -- -- Zek'voz, Herald of N'zoth
    [265646] = "CC",                -- Will of the Corruptor
    [270589] = "CC",                -- Void Wail
    [270620] = "CC",                -- Psionic Blast
    -- -- Vectis
    [265212] = "CC",                -- Gestate
    -- -- Zul, Reborn
    [273434] = "CC",                -- Pit of Despair
    [276031] = "CC",                -- Pit of Despair
    [269965] = "CC",                -- Pit of Despair
    [274271] = "CC",                -- Deathwish
    -- -- Mythrax the Unraveler
    [272407] = "CC",                -- Oblivion Sphere
    [284944] = "CC",                -- Oblivion Sphere
    [274230] = "Immune",            -- Oblivion Veil (damage taken reduced 99%)
    [276900] = "Immune",            -- Critical Mass (damage taken reduced 80%)
    -- -- G'huun
    [269691] = "CC",                -- Mind Thrall
    [273401] = "CC",                -- Mind Thrall
    [263504] = "CC",                -- Reorigination Blast
    [273251] = "CC",                -- Reorigination Blast
    [267700] = "CC",                -- Gaze of G'huun
    [255767] = "CC",                -- Grasp of G'huun
    [263217] = "Immune",            -- Blood Shield (not immune, but heals 5% of maximum health every 0.5 sec)
    [275129] = "Immune",            -- Corpulent Mass (damage taken reduced by 99%)
    [268174] = "Root",              -- Tendrils of Corruption
    [263235] = "Root",              -- Blood Feast
    [263321] = "Snare",             -- Undulating Mass
    [270287] = "Snare",             -- Blighted Ground
    ------------------------
    -- BfA World Bosses
    -- -- T'zane
    [261552] = "CC",                -- Terror Wail
    -- -- Hailstone Construct
    [274895] = "CC",                -- Freezing Tempest
    -- -- Warbringer Yenajz
    [274904] = "CC",                -- Reality Tear
    -- -- The Lion's Roar and Doom's Howl
    [271778] = "Snare",             -- Reckless Charge
    -- -- Ivus the Decayed
    [287554] = "Immune",            -- Petrify
    [282615] = "Immune",            -- Petrify
    ------------------------
    -- Battle for Darkshore
    [283921] = "CC",                -- Lancer's Charge
    [288344] = "CC",                -- Massive Stomp
    [288339] = "CC",                -- Massive Stomp
    [286397] = "CC",                -- Massive Stomp
    [282676] = "CC",                -- Massive Stomp
    [283880] = "CC",                -- DRILL KILL
    [284949] = "CC",                -- Warden's Prison
    [284221] = "Snare",             -- Crippling Gash
    [284737] = "Snare",             -- Toxic Strike
    ------------------------
    -- Battle for Stromgarde
    [97933]  = "CC",                -- Intimidating Shout
    [273867] = "CC",                -- Intimidating Shout
    [262007] = "CC",                -- Polymorph
    [261488] = "CC",                -- Charge
    [264942] = "CC",                -- Scatter Shot
    [258186] = "CC",                -- Crushing Cleave
    [270411] = "CC",                -- Earthshatter
    [259833] = "CC",                -- Heroic Leap
    [259867] = "CC",                -- Storm Bolt
    [272856] = "CC",                -- Hex Bomb
    [266918] = "CC",                -- Fear
    [262610] = "Root",              -- Weighted Net
    [273665] = "Snare",             -- Seismic Disturbance
    [262538] = "Snare",             -- Thunder Clap
    [259850] = "Snare",             -- Reverberating Clap
    [20822]  = "Snare",             -- Frostbolt
    ------------------------
    -- BfA Island Expeditions
    [8377] = "Root",                -- Earthgrab
    [280061] = "CC",                -- Brainsmasher Brew
    [280062] = "CC",                -- Unluckydo
    [270399] = "Root",              -- Unleashed Roots
    [270196] = "Root",              -- Chains of Light
    [267024] = "Root",              -- Stranglevines
    [236467] = "Root",              -- Pearlescent Clam
    [267025] = "Root",              -- Animal Trap
    [276807] = "Root",              -- Crude Net
    [276806] = "Root",              -- Stoutthistle
    [267029] = "CC",                -- Glowing Seed
    [276808] = "CC",                -- Heavy Boulder
    [267028] = "CC",                -- Bright Lantern
    [276809] = "CC",                -- Crude Spear
    [276804] = "CC",                -- Crude Boomerang
    [267030] = "CC",                -- Heavy Crate
    [276805] = "CC",                -- Gloomspore Shroom
    [245638] = "CC",                -- Thick Shell
    [267026] = "CC",                -- Giant Flower
    [243576] = "CC",                -- Sticky Starfish
    [278818] = "CC",                -- Amber Entrapment
    [268345] = "CC",                -- Azerite Suppression
    [278813] = "CC",                -- Brain Freeze
    [272982] = "CC",                -- Bubble Trap
    [278823] = "CC",                -- Choking Mist
    [268343] = "CC",                -- Crystalline Stasis
    [268341] = "CC",                -- Cyclone
    [273392] = "CC",                -- Drakewing Bonds
    [278817] = "CC",                -- Drowning Waters
    [268337] = "CC",                -- Flash Freeze
    [278914] = "CC",                -- Ghostly Rune Prison
    [278822] = "CC",                -- Heavy Net
    [273612] = "CC",                -- Mental Fog
    [278820] = "CC",                -- Netted
    [278816] = "CC",                -- Paralyzing Pool
    [278811] = "CC",                -- Poisoned Water
    [278821] = "CC",                -- Sand Trap
    [274055] = "CC",                -- Sap
    [273914] = "CC",                -- Shadowy Conflagration
    [279986] = "CC",                -- Shrink Ray
    [278814] = "CC",                -- Sticky Ooze
    [259236] = "CC",                -- Stone Rune Prison
    [290626] = "CC",                -- Debilitating Howl
    [290625] = "CC",                -- Creeping Decay
    [290624] = "CC",                -- Necrotic Paralysis
    [290623] = "CC",                -- Stone Prison
    [274794] = "CC",                -- Hex
    [275651] = "CC",                -- Charge
    [262470] = "CC",                -- Blast-O-Matic Frag Bomb
    [262906] = "CC",                -- Arcane Charge
    [270460] = "CC",                -- Stone Eruption
    [262500] = "CC",                -- Crushing Charge
    [268203] = "CC",                -- Death Lens
    [244880] = "CC",                -- Charge
    [275087] = "CC",                -- Charge
    [262342] = "CC",                -- Hex
    [257748] = "CC",                -- Blind
    [262147] = "CC",                -- Wild Charge
    [262000] = "CC",                -- Wyvern Sting
    [258822] = "CC",                -- Blinding Peck
    [271227] = "CC",                -- Wildfire
    [244888] = "CC",                -- Bonk
    [273664] = "CC",                -- Crush
    [256600] = "CC",                -- Point Blank Blast
    [270457] = "CC",                -- Slam
    [258371] = "CC",                -- Crystal Gaze
    [266989] = "CC",                -- Swooping Charge
    [258390] = "CC",                -- Petrifying Gaze
    [275990] = "CC",                -- Conflagrating Exhaust
    [277375] = "CC",                -- Sucker Punch
    [278193] = "CC",                -- Crush
    [275671] = "CC",                -- Tremendous Roar
    --[262197] = "Immune",          -- Tenacity of the Pack (unkillable but not immune to damage)
    [264115] = "Immune",            -- Divine Shield
    [267487] = "ImmunePhysical",    -- Icy Reflection
    [275154] = "Silence",           -- Silencing Calm
    [265723] = "Root",              -- Web
    [274801] = "Root",              -- Net
    [265584] = "Root",              -- Frost Nova
    [265583] = "Root",              -- Grasping Claw
    [278176] = "Root",              -- Entangling Roots
    [275821] = "Root",              -- Earthen Hold
    [277109] = "Snare",             -- Sticky Stomp
    [266974] = "Snare",             -- Frostbolt
    [261962] = "Snare",             -- Brutal Whirlwind
    [258748] = "Snare",             -- Arctic Torrent
    [266286] = "Snare",             -- Tendon Rip
    [270606] = "Snare",             -- Frostbolt
    [266288] = "Snare",             -- Gnash
    [262465] = "Snare",             -- Bug Zapper
    [267195] = "Snare",             -- Slow
    [275038] = "Snare",             -- Icy Claw
    [274968] = "Snare",             -- Howl
    [256661] = "Snare",             -- Staggering Roar
    ------------------------
    -- BfA Mythics
    -- -- Atal'Dazar
    [255371] = "CC",                -- Terrifying Visage
    [255041] = "CC",                -- Terrifying Screech
    [252781] = "CC",                -- Unstable Hex
    [279118] = "CC",                -- Unstable Hex
    [252692] = "CC",                -- Waylaying Jab
    [255567] = "CC",                -- Frenzied Charge
    [258653] = "Immune",            -- Bulwark of Juju (90% damage reduction)
    [253721] = "Immune",            -- Bulwark of Juju (90% damage reduction)
    -- -- Kings' Rest
    [268796] = "CC",                -- Impaling Spear
    [269369] = "CC",                -- Deathly Roar
    [267702] = "CC",                -- Entomb
    [271555] = "CC",                -- Entomb
    [270920] = "CC",                -- Seduction
    [270003] = "CC",                -- Suppression Slam
    [270492] = "CC",                -- Hex
    [276031] = "CC",                -- Pit of Despair
    [267626] = "CC",                -- Dessication (damage done reduced by 50%)
    [270931] = "Snare",             -- Darkshot
    [270499] = "Snare",             -- Frost Shock
    -- -- The MOTHERLODE!!
    [257337] = "CC",                -- Shocking Claw
    [257371] = "CC",                -- Tear Gas
    [275907] = "CC",                -- Tectonic Smash
    [280605] = "CC",                -- Brain Freeze
    [263637] = "CC",                -- Clothesline
    [268797] = "CC",                -- Transmute: Enemy to Goo
    [268846] = "Silence",           -- Echo Blade
    [267367] = "CC",                -- Deactivated
    [278673] = "CC",                -- Red Card
    [278644] = "CC",                -- Slide Tackle
    [257481] = "CC",                -- Fracking Totem
    [269278] = "CC",                -- Panic!
    [260189] = "Immune",            -- Configuration: Drill (damage taken reduced 99%)
    [268704] = "Snare",             -- Furious Quake
    -- -- Shrine of the Storm
    [268027] = "CC",                -- Rising Tides
    [276268] = "CC",                -- Heaving Blow
    [269131] = "CC",                -- Ancient Mindbender
    [268059] = "Root",              -- Anchor of Binding
    [269419] = "Silence",           -- Yawning Gate
    [267956] = "CC",                -- Zap
    [269104] = "CC",                -- Explosive Void
    [268391] = "CC",                -- Mental Assault
    [269289] = "CC",                -- Disciple of the Vol'zith
    [264526] = "Root",              -- Grasp from the Depths
    [276767] = "ImmuneSpell",       -- Consuming Void
    [268375] = "ImmunePhysical",    -- Detect Thoughts
    [267982] = "Immune",            -- Protective Gaze (damage taken reduced 75%)
    [268212] = "Immune",            -- Minor Reinforcing Ward (damage taken reduced 75%)
    [268186] = "Immune",            -- Reinforcing Ward (damage taken reduced 75%)
    [267904] = "Immune",            -- Reinforcing Ward (damage taken reduced 75%)
    [267901] = "Snare",             -- Blessing of Ironsides
    [274631] = "Snare",             -- Lesser Blessing of Ironsides
    [267899] = "Snare",             -- Hindering Cleave
    [268896] = "Snare",             -- Mind Rend
    -- -- Temple of Sethraliss
    [280032] = "CC",                -- Neurotoxin
    [268993] = "CC",                -- Cheap Shot
    [268008] = "CC",                -- Snake Charm
    [263958] = "CC",                -- A Knot of Snakes
    [269970] = "CC",                -- Blinding Sand
    [256333] = "CC",                -- Dust Cloud (0% chance to hit)
    [260792] = "CC",                -- Dust Cloud (0% chance to hit)
    [269670] = "Immune",            -- Empowerment (90% damage reduction)
    [261635] = "Immune",            -- Stoneshield Potion
    [273274] = "Snare",             -- Polarized Field
    [275566] = "Snare",             -- Numb Hands
    -- -- Waycrest Manor
    [265407] = "Silence",           -- Dinner Bell
    [263891] = "CC",                -- Grasping Thorns
    [260900] = "CC",                -- Soul Manipulation
    [260926] = "CC",                -- Soul Manipulation
    [265352] = "CC",                -- Toad Blight
    [264390] = "Silence",           -- Spellbind
    [278468] = "CC",                -- Freezing Trap
    [267907] = "CC",                -- Soul Thorns
    [265346] = "CC",                -- Pallid Glare
    [268202] = "CC",                -- Death Lens
    [261265] = "Immune",            -- Ironbark Shield (99% damage reduction)
    [261266] = "Immune",            -- Runic Ward (99% damage reduction)
    [261264] = "Immune",            -- Soul Armor (99% damage reduction)
    [271590] = "Immune",            -- Soul Armor (99% damage reduction)
    [260923] = "Immune",            -- Soul Manipulation (99% damage reduction)
    [264027] = "Other",             -- Warding Candles (50% damage reduction)
    [264040] = "Snare",             -- Uprooted Thorns
    [264712] = "Snare",             -- Rotten Expulsion
    [261440] = "Snare",             -- Virulent Pathogen
    -- -- Tol Dagor
    [258058] = "Root",              -- Squeeze
    [259711] = "Root",              -- Lockdown
    [258313] = "CC",                -- Handcuff (Pacified and Silenced)
    [260067] = "CC",                -- Vicious Mauling
    [257791] = "CC",                -- Howling Fear
    [257793] = "CC",                -- Smoke Powder
    [257119] = "CC",                -- Sand Trap
    [256474] = "CC",                -- Heartstopper Venom
    [258317] = "ImmuneSpell",       -- Riot Shield (-75% spell damage and redirect spells to the caster)
    [258153] = "Immune",            -- Watery Dome (75% damage redictopm)
    [265271] = "Snare",             -- Sewer Slime
    [257777] = "Snare",             -- Crippling Shiv
    [259188] = "Snare",             -- Heavily Armed
    -- -- Freehold
    [274516] = "CC",                -- Slippery Suds
    [257949] = "CC",                -- Slippery
    [258875] = "CC",                -- Blackout Barrel
    [274400] = "CC",                -- Duelist Dash
    [274389] = "Root",              -- Rat Traps
    [276061] = "CC",                -- Boulder Throw
    [258182] = "CC",                -- Boulder Throw
    [268283] = "CC",                -- Obscured Vision (hit chance decreased 75%)
    [257274] = "Snare",             -- Vile Coating
    [257478] = "Snare",             -- Crippling Bite
    [257747] = "Snare",             -- Earth Shaker
    [257784] = "Snare",             -- Frost Blast
    [272554] = "Snare",             -- Bloody Mess
    -- -- Siege of Boralus
    [256957] = "Immune",            -- Watertight Shell
    [257069] = "CC",                -- Watertight Shell
    [257292] = "CC",                -- Heavy Slash
    [272874] = "CC",                -- Trample
    [257169] = "CC",                -- Terrifying Roar
    [274942] = "CC",                -- Banana Rampage
    [272571] = "Silence",           -- Choking Waters
    [275826] = "Immune",            -- Bolstering Shout (damage taken reduced 75%)
    [270624] = "Root",              -- Crushing Embrace
    [272834] = "Snare",             -- Viscous Slobber
    -- -- The Underrot
    [265377] = "Root",              -- Hooked Snare
    [272609] = "CC",                -- Maddening Gaze
    [265511] = "CC",                -- Spirit Drain
    [278961] = "CC",                -- Decaying Mind
    [269406] = "CC",                -- Purge Corruption
    [258347] = "Silence",           -- Sonic Screech
    ------------------------
    ---- PVE LEGION
    ------------------------
    -- EN Raid
    -- -- Trash
    [223914] = "CC",                -- Intimidating Roar
    [225249] = "CC",                -- Devastating Stomp
    [225073] = "Root",              -- Despoiling Roots
    [222719] = "Root",              -- Befoulment
    -- -- Nythendra
    [205043] = "CC",                -- Infested Mind (Nythendra)
    -- -- Ursoc
    [197980] = "CC",                -- Nightmarish Cacophony (Ursoc)
    -- -- Dragons of Nightmare
    [205341] = "CC",                -- Seeping Fog (Dragons of Nightmare)
    [225356] = "CC",                -- Seeping Fog (Dragons of Nightmare)
    [203110] = "CC",                -- Slumbering Nightmare (Dragons of Nightmare)
    [204078] = "CC",                -- Bellowing Roar (Dragons of Nightmare)
    [203770] = "Root",              -- Defiled Vines (Dragons of Nightmare)
    -- -- Il'gynoth
    [212886] = "CC",                -- Nightmare Corruption (Il'gynoth)
    -- -- Cenarius
    [210315] = "Root",              -- Nightmare Brambles (Cenarius)
    [214505] = "CC",                -- Entangling Nightmares (Cenarius)
    ------------------------
    -- ToV Raid
    -- -- Trash
    [228609] = "CC",                -- Bone Chilling Scream
    [228883] = "CC",                -- Unholy Reckoning
    [228869] = "CC",                -- Crashing Waves
    -- -- Odyn
    [228018] = "Immune",            -- Valarjar's Bond (Odyn)
    [229529] = "Immune",            -- Valarjar's Bond (Odyn)
    [227781] = "CC",                -- Glowing Fragment (Odyn)
    [227594] = "Immune",            -- Runic Shield (Odyn)
    [227595] = "Immune",            -- Runic Shield (Odyn)
    [227596] = "Immune",            -- Runic Shield (Odyn)
    [227597] = "Immune",            -- Runic Shield (Odyn)
    [227598] = "Immune",            -- Runic Shield (Odyn)
    -- -- Guarm
    [228248] = "CC",                -- Frost Lick (Guarm)
    -- -- Helya
    [232350] = "CC",                -- Corrupted (Helya)
    ------------------------
    -- NH Raid
    -- -- Trash
    [225583] = "CC",                -- Arcanic Release
    [225803] = "Silence",           -- Sealed Magic
    [224483] = "CC",                -- Slam
    [224944] = "CC",                -- Will of the Legion
    [224568] = "CC",                -- Mass Suppress
    [221524] = "Immune",            -- Protect (not immune, 90% less dmg)
    [226231] = "Immune",            -- Faint Hope
    [230377] = "CC",                -- Wailing Bolt
    -- -- Skorpyron
    [204483] = "CC",                -- Focused Blast (Skorpyron)
    -- -- Spellblade Aluriel
    [213621] = "CC",                -- Entombed in Ice (Spellblade Aluriel)
    -- -- Tichondrius
    [215988] = "CC",                -- Carrion Nightmare (Tichondrius)
    -- -- High Botanist Tel'arn
    [218304] = "Root",              -- Parasitic Fetter (Botanist)
    -- -- Star Augur
    [206603] = "CC",                -- Frozen Solid (Star Augur)
    [216697] = "CC",                -- Frigid Pulse (Star Augur)
    [207720] = "CC",                -- Witness the Void (Star Augur)
    [207714] = "Immune",            -- Void Shift (-99% dmg taken) (Star Augur)
    -- -- Gul'dan
    [206366] = "CC",                -- Empowered Bonds of Fel (Knockback Stun) (Gul'dan)
    [206983] = "CC",                -- Shadowy Gaze (Gul'dan)
    [208835] = "CC",                -- Distortion Aura (Gul'dan)
    [208671] = "CC",                -- Carrion Wave (Gul'dan)
    [229951] = "CC",                -- Fel Obelisk (Gul'dan)
    [206841] = "CC",                -- Fel Obelisk (Gul'dan)
    [227749] = "Immune",            -- The Eye of Aman'Thul (Gul'dan)
    [227750] = "Immune",            -- The Eye of Aman'Thul (Gul'dan)
    [227743] = "Immune",            -- The Eye of Aman'Thul (Gul'dan)
    [227745] = "Immune",            -- The Eye of Aman'Thul (Gul'dan)
    [227427] = "Immune",            -- The Eye of Aman'Thul (Gul'dan)
    [227320] = "Immune",            -- The Eye of Aman'Thul (Gul'dan)
    [206516] = "Immune",            -- The Eye of Aman'Thul (Gul'dan)
    ------------------------
    -- ToS Raid
    -- -- Trash
    [243298] = "CC",                -- Lash of Domination
    [240706] = "CC",                -- Arcane Ward
    [240737] = "CC",                -- Polymorph Bomb
    [239810] = "CC",                -- Sever Soul
    [240592] = "CC",                -- Serpent Rush
    [240169] = "CC",                -- Electric Shock
    [241234] = "CC",                -- Darkening Shot
    [241009] = "CC",                -- Power Drain (-90% damage)
    [241254] = "CC",                -- Frost-Fingered Fear
    [241276] = "CC",                -- Icy Tomb
    [241348] = "CC",                -- Deafening Wail
    -- -- Demonic Inquisition
    [233430] = "CC",                -- Unbearable Torment (Demonic Inquisition) (no CC, -90% dmg, -25% heal, +90% dmg taken)
    -- -- Harjatan
    [240315] = "Immune",            -- Hardened Shell (Harjatan)
    -- -- Sisters of the Moon
    [237351] = "Silence",           -- Lunar Barrage (Sisters of the Moon)
    -- -- Mistress Sassz'ine
    [234332] = "CC",                -- Hydra Acid (Mistress Sassz'ine)
    [230362] = "CC",                -- Thundering Shock (Mistress Sassz'ine)
    [230959] = "CC",                -- Concealing Murk (Mistress Sassz'ine) (no CC, hit chance reduced 75%)
    -- -- The Desolate Host
    [236241] = "CC",                -- Soul Rot (The Desolate Host) (no CC, dmg dealt reduced 75%)
    [236011] = "Silence",           -- Tormented Cries (The Desolate Host)
    [236513] = "Immune",            -- Bonecage Armor (The Desolate Host) (75% dmg reduction)
    -- -- Maiden of Vigilance
    [248812] = "CC",                -- Blowback (Maiden of Vigilance)
    [233739] = "CC",                -- Malfunction (Maiden of Vigilance
    -- -- Kil'jaeden
    [245332] = "Immune",            -- Nether Shift (Kil'jaeden)
    [244834] = "Immune",            -- Nether Gale (Kil'jaeden)
    [236602] = "CC",                -- Soul Anguish (Kil'jaeden)
    [236555] = "CC",                -- Deceiver's Veil (Kil'jaeden)
    ------------------------
    -- Antorus Raid
    -- -- Trash
    [246209] = "CC",                -- Punishing Flame
    [254502] = "CC",                -- Fearsome Leap
    [254125] = "CC",                -- Cloud of Confusion
    -- -- Garothi Worldbreaker
    [246920] = "CC",                -- Haywire Decimation
    -- -- Hounds of Sargeras
    [244086] = "CC",                -- Molten Touch
    [244072] = "CC",                -- Molten Touch
    [249227] = "CC",                -- Molten Touch
    [249241] = "CC",                -- Molten Touch
    [244071] = "CC",                -- Weight of Darkness
    -- -- War Council
    [244748] = "CC",                -- Shocked
    -- -- Portal Keeper Hasabel
    [246208] = "Root",              -- Acidic Web
    [244949] = "CC",                -- Felsilk Wrap
    -- -- Imonar the Soulhunter
    [247641] = "CC",                -- Stasis Trap
    [255029] = "CC",                -- Sleep Canister
    [247565] = "CC",                -- Slumber Gas
    [250135] = "Immune",            -- Conflagration (-99% damage taken)
    [248233] = "Immune",            -- Conflagration (-99% damage taken)
    -- -- Kin'garoth
    [246516] = "Immune",            -- Apocalypse Protocol (-99% damage taken)
    -- -- The Coven of Shivarra
    [253203] = "Immune",            -- Shivan Pact (-99% damage taken)
    [249863] = "Immune",            -- Visage of the Titan
    [256356] = "CC",                -- Chilled Blood
    -- -- Aggramar
    [244894] = "Immune",            -- Corrupt Aegis
    [246014] = "CC",                -- Searing Tempest
    [255062] = "CC",                -- Empowered Searing Tempest
    ------------------------
    -- The Deaths of Chromie Scenario
    [246941] = "CC",                -- Looming Shadows
    [245167] = "CC",                -- Ignite
    [248839] = "CC",                -- Charge
    [246211] = "CC",                -- Shriek of the Graveborn
    [247683] = "Root",              -- Deep Freeze
    [247684] = "CC",                -- Deep Freeze
    [244959] = "CC",                -- Time Stop
    [248516] = "CC",                -- Sleep
    [245169] = "Immune",            -- Reflective Shield
    [248716] = "CC",                -- Infernal Strike
    [247730] = "Root",              -- Faith's Fetters
    [245822] = "CC",                -- Inescapable Nightmare
    [245126] = "Silence",           -- Soul Burn
    ------------------------
    -- Legion Mythics
    -- -- The Arcway
    [195804] = "CC",                -- Quarantine
    [203649] = "CC",                -- Exterminate
    [203957] = "CC",                -- Time Lock
    [211543] = "Root",              -- Devour
    -- -- Black Rook Hold
    [194960] = "CC",                -- Soul Echoes
    [197974] = "CC",                -- Bonecrushing Strike
    [199168] = "CC",                -- Itchy!
    [204954] = "CC",                -- Cloud of Hypnosis
    [199141] = "CC",                -- Cloud of Hypnosis
    [199097] = "CC",                -- Cloud of Hypnosis
    [214002] = "CC",                -- Raven's Dive
    [200261] = "CC",                -- Bonebreaking Strike
    [201070] = "CC",                -- Dizzy
    [221117] = "CC",                -- Ghastly Wail
    [222417] = "CC",                -- Boulder Crush
    [221838] = "CC",                -- Disorienting Gas
    -- -- Court of Stars
    [207278] = "Snare",             -- Arcane Lockdown
    [207261] = "CC",                -- Resonant Slash
    [215204] = "CC",                -- Hinder
    [207979] = "CC",                -- Shockwave
    [224333] = "CC",                -- Enveloping Winds
    [209404] = "Silence",           -- Seal Magic
    [209413] = "Silence",           -- Suppress
    [209027] = "CC",                -- Quelling Strike
    [212773] = "CC",                -- Subdue
    [216000] = "CC",                -- Mighty Stomp
    [213233] = "CC",                -- Uninvited Guest
    -- -- Return to Karazhan
    [227567] = "CC",                -- Knocked Down
    [228215] = "CC",                -- Severe Dusting
    [227508] = "CC",                -- Mass Repentance
    [227545] = "CC",                -- Mana Drain
    [227909] = "CC",                -- Ghost Trap
    [228693] = "CC",                -- Ghost Trap
    [228837] = "CC",                -- Bellowing Roar
    [227592] = "CC",                -- Frostbite
    [228239] = "CC",                -- Terrifying Wail
    [241774] = "CC",                -- Shield Smash
    [230122] = "Silence",           -- Garrote - Silence
    [39331]  = "Silence",           -- Game In Session
    [227977] = "CC",                -- Flashlight
    [241799] = "CC",                -- Seduction
    [227917] = "CC",                -- Poetry Slam
    [230083] = "CC",                -- Nullification
    [229489] = "Immune",            -- Royalty (90% dmg reduction)
    -- -- Maw of Souls
    [193364] = "CC",                -- Screams of the Dead
    [198551] = "CC",                -- Fragment
    [197653] = "CC",                -- Knockdown
    [198405] = "CC",                -- Bone Chilling Scream
    [193215] = "CC",                -- Kvaldir Cage
    [204057] = "CC",                -- Kvaldir Cage
    [204058] = "CC",                -- Kvaldir Cage
    [204059] = "CC",                -- Kvaldir Cage
    [204060] = "CC",                -- Kvaldir Cage
    -- -- Vault of the Wardens
    [202455] = "Immune",            -- Void Shield
    [212565] = "CC",                -- Inquisitive Stare
    [225416] = "CC",                -- Intercept
    [6726]   = "Silence",           -- Silence
    [201488] = "CC",                -- Frightening Shout
    [203774] = "Immune",            -- Focusing
    [192517] = "CC",                -- Brittle
    [201523] = "CC",                -- Brittle
    [194323] = "CC",                -- Petrified
    [206387] = "CC",                -- Steal Light
    [197422] = "Immune",            -- Creeping Doom
    [210138] = "CC",                -- Fully Petrified
    [202615] = "Root",              -- Torment
    [193069] = "CC",                -- Nightmares
    [191743] = "Silence",           -- Deafening Screech
    [202658] = "CC",                -- Drain
    [193969] = "Root",              -- Razors
    [204282] = "CC",                -- Dark Trap
    -- -- Eye of Azshara
    [191975] = "CC",                -- Impaling Spear
    [191977] = "CC",                -- Impaling Spear
    [193597] = "CC",                -- Static Nova
    [192708] = "CC",                -- Arcane Bomb
    [195561] = "CC",                -- Blinding Peck
    [195129] = "CC",                -- Thundering Stomp
    [195253] = "CC",                -- Imprisoning Bubble
    [197144] = "Root",              -- Hooked Net
    [197105] = "CC",                -- Polymorph: Fish
    [195944] = "CC",                -- Rising Fury
    -- -- Darkheart Thicket
    [200329] = "CC",                -- Overwhelming Terror
    [200273] = "CC",                -- Cowardice
    [204246] = "CC",                -- Tormenting Fear
    [200631] = "CC",                -- Unnerving Screech
    [200771] = "CC",                -- Propelling Charge
    [199063] = "Root",              -- Strangling Roots
    -- -- Halls of Valor
    [198088] = "CC",                -- Glowing Fragment
    [215429] = "CC",                -- Thunderstrike
    [199340] = "CC",                -- Bear Trap
    [210749] = "CC",                -- Static Storm
    -- -- Neltharion's Lair
    [200672] = "CC",                -- Crystal Cracked
    [202181] = "CC",                -- Stone Gaze
    [193585] = "CC",                -- Bound
    [186616] = "CC",                -- Petrified
    -- -- Cathedral of Eternal Night
    [238678] = "Silence",           -- Stifling Satire
    [238484] = "CC",                -- Beguiling Biography
    [242724] = "CC",                -- Dread Scream
    [239217] = "CC",                -- Blinding Glare
    [238583] = "Silence",           -- Devour Magic
    [239156] = "CC",                -- Book of Eternal Winter
    [240556] = "Silence",           -- Tome of Everlasting Silence
    [242792] = "CC",                -- Vile Roots
    -- -- The Seat of the Triumvirate
    [246913] = "Immune",            -- Void Phased
    [244621] = "CC",                -- Void Tear
    [248831] = "CC",                -- Dread Screech
    [246026] = "CC",                -- Void Trap
    [245278] = "CC",                -- Void Trap
    [244751] = "CC",                -- Howling Dark
    [248804] = "Immune",            -- Dark Bulwark
    [247816] = "CC",                -- Backlash
    [254020] = "Immune",            -- Darkened Shroud
    [253952] = "CC",                -- Terrifying Howl
    [248298] = "Silence",           -- Screech
    [245706] = "CC",                -- Ruinous Strike
    [248133] = "CC",                -- Stygian Blast
}