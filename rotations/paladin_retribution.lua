--[[[
@module Paladin Retribution Rotation
@author Kirk24788
@version Hekili
]]--


local spells = kps.spells.paladin
local env = kps.env.paladin

local AshenHallow = spells.ashenHallow.name
local DoorOfShadows = spells.doorOfShadows.name
local Reckoning = spells.finalReckoning.name

kps.runAtEnd(function()
kps.gui.addCustomToggle("PALADIN","RETRIBUTION", "hekili", "Interface\\Icons\\spell_nature_slow", "hekili")
end)

kps.rotations.register("PALADIN","RETRIBUTION",
{
    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    
    {spells.blessingOfFreedom , 'player.isRoot' },
    {spells.everyManForHimself, 'player.isStun' },
    -- "Pierre de soins" 5512
    --{{"macro"}, 'player.hp < 0.70 and player.useItem(5512)' , "/use item:5512" },

    -- "Divine Protection" -- Protects the caster (PLAYER) from all attacks and spells for 8 sec.
    {spells.divineProtection, 'player.hp < 0.70' , "player" },
    -- "Blessing of Protection" -- immunity to Physical damage and harmful effects for 10 sec. bosses will not attack targets affected by Blessing of Protection 
    -- can be used to clear harmful physical damage debuffs and bleeds from the target.
    {spells.blessingOfProtection, 'player.hp < 0.55' , "player" },
    {spells.blessingOfProtection, 'heal.lowestInRaid.hp < 0.55 and not heal.lowestInRaid.isRaidTank' , kps.heal.lowestInRaid },
    
    -- "Divine Shield" -- Immune to all attacks and harmful effects. 8 seconds remaining
    {spells.divineShield, 'player.hp < 0.35' , "player" },
    {spells.divineShield, 'heal.lowestTankInRaid.hp < 0.35' , kps.heal.lowestTankInRaid },
    
    -- "Lay on Hands" -- Heals a friendly target for an amount equal to your maximum health.
    {spells.layOnHands, 'heal.lowestTankInRaid.hp < 0.35', kps.heal.lowestTankInRaid },
    {spells.layOnHands, 'player.hp < 0.35', "player" },
    {spells.flashOfLight, 'player.hp < 0.65 and player.buffStacks(spells.selflessHealer) > 2' , "player" , "FLASH_PLAYER" },
    {spells.wordOfGlory, 'player.hp < 0.65' , "player" },
    {spells.shieldOfVengeance , 'true' },
    {spells.arcaneTorrent, 'true' },

    {{"nested"},'kps.cooldowns', {
        {spells.cleanseToxins, 'mouseover.isHealable and ( mouseover.isDispellable("Poison") or mouseover.isDispellable("Disease"))' , "mouseover" },
        {spells.cleanseToxins, 'player.isDispellable("Disease")' , "player" },
        {spells.cleanseToxins, 'player.isDispellable("Poison")' , "player" },
        {spells.cleanseToxins, 'heal.isPoisonDispellable' , kps.heal.isPoisonDispellable },
    }},
    -- Interrupt
    {{"nested"}, 'kps.interrupt' ,{
        {spells.rebuke, 'target.isAttackable and target.distanceMax <= 10 and target.isCasting' , "target" },
        {spells.blindingLight, 'target.isAttackable and target.distanceMax <= 10 and target.isCasting' , "target" },
        {spells.hammerOfJustice, 'target.isAttackable and target.distanceMax <= 10 and target.isInterruptable' , "target" },
        {spells.hammerOfJustice, 'target.isAttackable and target.distanceMax <= 10 and target.isCasting' , "target" },
    }},
    
    -- VENTHYR
    --{{"macro"}, 'keys.ctrl and spells.ashenHallow.cooldown == 0' , "/cast [@player] "..AshenHallow },
    --{{"macro"}, 'keys.alt and spells.doorOfShadows.cooldown == 0', "/cast [@cursor] "..DoorOfShadows},
    -- NECROLORD
    --{spells.fleshcraft, 'not player.isMoving and not player.hasBuff(spells.avengingWrath)' , "player" },
    --{spells.vanquishersHammer, 'not player.hasBuff(spells.vanquishersHammer)' , env.damageTarget},
    -- KYRIAN


    -- TRINKETS -- SLOT 0 /use 13
    {{"macro"}, 'player.useTrinket(0) and player.timeInCombat > 5' , "/use 13" },
    -- TRINKETS -- SLOT 1 /use 14
    {{"macro"}, 'player.useTrinket(1) and player.timeInCombat > 10' , "/use 14" },
    
    {spells.exorcism, 'not target.hasMyDebuff(spells.exorcism)' , env.damageTarget },
    
    {kps.hekili({
        spells.cleanseToxins,
        spells.vanquishersHammer
    }), 'kps.hekili'},
    

    {spells.crusade, 'kps.multiTarget and player.holyPower > 2 and spells.seraphim.cooldown == 0' , env.damageTarget }, -- cd 2 min -- duration 25 sec
    -- {spells.avengingWrath, 'kps.multiTarget and player.holyPower > 2' }, -- replaces avengingWrath
    {spells.divineToll, 'kps.multiTarget and player.hasBuff(spells.seraphim)' },
    {{"macro"}, 'spells.finalReckoning.cooldown == 0 and player.hasBuff(spells.seraphim)', "/cast [@player] "..Reckoning }, -- cd 1 min -- no cost Holy Power
    {spells.executionSentence, 'player.hasBuff(spells.seraphim)' , env.damageTarget }, -- cd 1 min -- cost 3 Holy Power

    {spells.seraphim, 'player.hasBuff(spells.crusade)' , env.damageTarget}, -- cd 45 sec -- The Light magnifies your power for 15 sec -- cost 3 Holy Power
    {spells.seraphim, 'player.holyPower > 2 and spells.crusade.cooldown > 50 and spells.executionSentence.cooldown < 9 and spells.finalReckoning.cooldown < 9' , env.damageTarget}, -- cd 45 sec -- The Light magnifies your power for 15 sec -- cost 3 Holy Power
    {spells.divineStorm, 'player.holyPower == 5 and player.plateCount > 2' , env.damageTarget}, -- cd 1 min
    {spells.templarsVerdict, 'player.holyPower == 5' , env.damageTarget},
    {spells.divineStorm, 'player.hasBuff(spells.empyreanPower)' , env.damageTarget},
    {spells.bladeOfJustice, 'player.hasBuff(spells.bladeOfWrath)' , env.damageTarget},
    {spells.exorcism, 'not target.hasMyDebuff(spells.exorcism)' , env.damageTarget },

    -- Holy Power generating
    {spells.judgment, 'true' , env.damageTarget }, -- 1 holypower
    {spells.divineToll, 'not target.hasMyDebuff(spells.judgment)' }, -- cd 1 min
    {spells.wakeOfAshes, 'player.holyPower < 3',  env.damageTarget }, -- 3 holypower
    {spells.consecration, 'not player.isMoving and target.isAttackable and not target.isMoving and target.distanceMax <= 10' },
    {spells.hammerOfWrath, 'player.holyPower < 5' , env.damageTarget }, -- 1 holypower
    {spells.bladeOfJustice, 'player.holyPower < 5' , env.damageTarget }, -- 1 holypower
    {spells.crusaderStrike, 'spells.crusaderStrike.charges == 2' , env.damageTarget}, -- 1 holypower
    {spells.flashOfLight, 'not player.isMoving and player.hpIncoming < 0.40', 'player'},
    -- Holy Power spending -- seraphim cost 3 Holy Power
    {spells.divineStorm, 'spells.seraphim.cooldown > 0 and player.plateCount > 1' , env.damageTarget},
    {spells.templarsVerdict, 'spells.seraphim.cooldown > 0' , env.damageTarget},
    -- filler
    {spells.crusaderStrike, 'true' , env.damageTarget}, -- 1 holypower

    --{{"macro"}, 'target.isAttackable and target.distanceMax <= 10' , "/startattack" },

}
,"Dragonflight")
