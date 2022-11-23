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
    {spells.blessingOfProtection, 'player.hp < 0.35' , "player" },
    {spells.blessingOfProtection, 'heal.lowestInRaid.hp < 0.35 and not heal.lowestInRaid.isRaidTank' , kps.heal.lowestInRaid },
    
    -- "Divine Shield" -- Immune to all attacks and harmful effects. 8 seconds remaining
    {spells.divineShield, 'player.hp < 0.35' , "player" },
    {spells.divineShield, 'heal.lowestTankInRaid.hp < 0.35' , kps.heal.lowestTankInRaid },
    
    -- "Lay on Hands" -- Heals a friendly target for an amount equal to your maximum health.
    {spells.layOnHands, 'heal.lowestTankInRaid.hp < 0.35', kps.heal.lowestTankInRaid },
    {spells.layOnHands, 'player.hp < 0.35', "player" },
    {spells.flashOfLight, 'player.hp < 0.55 and player.buffStacks(spells.selflessHealer) > 2' , "player" , "FLASH_PLAYER" },
    {spells.wordOfGlory, 'player.hp < 0.55' , "player" },
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
        {spells.hammerOfJustice, 'target.isAttackable and target.distanceMax <= 10 and player.isPVP' , "target" },
        {spells.hammerOfJustice, 'target.isAttackable and target.distanceMax <= 10 and target.isInterruptable' , "target" },
        {spells.hammerOfJustice, 'target.isAttackable and target.distanceMax <= 10 and target.isCasting' , "target" },
    }},
    
    -- VENTHYR
    --{{"macro"}, 'keys.ctrl and spells.ashenHallow.cooldown == 0' , "/cast [@player] "..AshenHallow },
    --{{"macro"}, 'keys.alt and spells.doorOfShadows.cooldown == 0', "/cast [@cursor] "..DoorOfShadows},
    -- NECROLORD
    {spells.fleshcraft, 'not player.isMoving and not player.hasBuff(spells.avengingWrath)' , "player" },
    {spells.vanquishersHammer, 'not player.hasBuff(spells.vanquishersHammer)' , env.damageTarget},
    -- KYRIAN
    --{spells.divineToll, 'kps.multiTarget' },

    -- TRINKETS -- SLOT 0 /use 13
    --{{"macro"}, 'player.useTrinket(0) and player.timeInCombat > 9 and target.isAttackable' , "/use 13" },
    -- TRINKETS -- SLOT 1 /use 14
    --{{"macro"}, 'player.useTrinket(1) and player.timeInCombat > 30 and target.isAttackable' , "/use 14" },
    
    {spells.exorcism, 'not target.hasMyDebuff(spells.exorcism)' , env.damageTarget },
    {{"macro"}, 'spells.finalReckoning.cooldown == 0 and player.holyPower > 2', "/cast [@player] "..Reckoning },
    {spells.crusade, 'kps.multiTarget and player.holyPower > 2' , env.damageTarget },
    {spells.avengingWrath, 'kps.multiTarget and player.holyPower > 2' }, 
    {spells.divineStorm, 'player.holyPower == 5 and player.plateCount > 2' , env.damageTarget},
    {spells.templarsVerdict, 'player.holyPower == 5' , env.damageTarget},
    {spells.templarsVerdict, 'player.hasBuff(spells.vanquishersHammer)' , env.damageTarget}, -- use both charges of Vanquisher's Hammer after Seraphim
    {spells.bladeOfJustice, 'player.hasBuff(spells.bladeOfWrath)' , env.damageTarget},
    {spells.divineStorm, 'player.hasBuff(spells.empyreanPower)' , env.damageTarget},
    -- Holy Power generating
    {spells.judgment, 'true' , env.damageTarget }, -- 1 holypower
    {spells.wakeOfAshes, 'player.holyPower < 3',  env.damageTarget }, -- 3 holypower
    {spells.consecration, 'not player.isMoving and target.isAttackable and not target.isMoving and target.distanceMax <= 10' },
    {spells.hammerOfWrath, 'true' , env.damageTarget }, -- 1 holypower
    {spells.bladeOfJustice, 'player.holyPower < 4' , env.damageTarget }, -- 2 holypower
    {spells.crusaderStrike, 'spells.crusaderStrike.charges == 2' , env.damageTarget}, -- 1 holypower
    {spells.flashOfLight, 'not player.isMoving and player.hpIncoming < 0.40', 'player'},
    -- Holy Power spending
    {spells.executionSentence, 'true' , env.damageTarget },
    {spells.divineStorm, 'player.plateCount > 1' , env.damageTarget},
    {spells.templarsVerdict, 'true' , env.damageTarget},
    {spells.crusaderStrike, 'true' , env.damageTarget}, -- 1 holypower
    -- filler

    {{"macro"}, 'target.isAttackable and target.distanceMax <= 10' , "/startattack" },

}
,"Hekili")
