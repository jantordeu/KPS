--[[[
@module Paladin Retribution Rotation
@author Kirk24788
@version Hekili
]]--


local spells = kps.spells.paladin
local env = kps.env.paladin

kps.rotations.register("PALADIN","RETRIBUTION",
{
    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {spells.blessingOfFreedom , 'player.isRoot' },
    {spells.everyManForHimself, 'player.isStun' },
    -- "Pierre de soins" 5512
    --{{"macro"}, 'player.hp < 0.70 and player.useItem(5512)' , "/use item:5512" },

    -- "Divine Protection" -- Protects the caster (PLAYER) from all attacks and spells for 8 sec.
    {spells.divineProtection, 'player.hp < 0.80' },

    -- "Blessing of Protection" -- immunity to Physical damage and harmful effects for 10 sec. bosses will not attack targets affected by Blessing of Protection 
    -- can be used to clear harmful physical damage debuffs and bleeds from the target.
    {spells.blessingOfProtection, 'player.hp < 0.30' , "player" },
    {spells.blessingOfProtection, 'heal.lowestInRaid.hp < 0.30 and not heal.lowestInRaid.isRaidTank' , kps.heal.lowestInRaid },
    
    -- "Divine Shield" -- Immune to all attacks and harmful effects. 8 seconds remaining
    {spells.divineShield, 'player.hp < 0.30' , "player" },
    {spells.divineShield, 'heal.lowestTankInRaid.hp < 0.30' , kps.heal.lowestTankInRaid },
    
    -- "Lay on Hands" -- Heals a friendly target for an amount equal to your maximum health.
    {spells.layOnHands, 'heal.lowestTankInRaid.hp < 0.30', kps.heal.lowestTankInRaid },
    {spells.layOnHands, 'player.hp < 0.30', "player" },
    {spells.wordOfGlory, 'player.hp < 0.70' , "player" },
    {spells.wordOfGlory, 'kps.groupSize() == 1 and player.hp < 0.80' , "player" },
    {spells.flashOfLight, 'player.hp < 0.80 and player.hasBuff(spells.selflessHealer) and player.buffStacks(spells.selflessHealer) > 2' , "player" , "FLASH_PLAYER" },
    {spells.arcaneTorrent, 'true' },

    -- Interrupt
    {{"nested"}, 'kps.interrupt' ,{
        {spells.blindingLight, 'player.hasTalent(3,3) and target.distanceMax <= 10 and target.isCasting' , "target" },
        {spells.hammerOfJustice, 'target.distanceMax <= 10 and player.isPVP' , "target" },
        {spells.hammerOfJustice, 'target.distanceMax <= 10 and target.isInterruptable' , "target" },
        {spells.hammerOfJustice, 'focus.distanceMax <= 10 and focus.isInterruptable' , "focus" },
        --{spells.hammerOfJustice, 'target.isAttackable and target.distanceMax <= 10 and target.isMoving' , "target" },
        --{spells.hammerOfJustice, 'target.isAttackable and target.distanceMax <= 10 and target.isCasting' , "target" },
    }},
    
    -- TRINKETS -- SLOT 0 /use 13
    {{"macro"}, 'player.useTrinket(0) and player.timeInCombat > 9 and target.isAttackable' , "/use 13" },
    -- TRINKETS -- SLOT 1 /use 14
    {{"macro"}, 'player.useTrinket(1) and player.timeInCombat > 30 and target.isAttackable' , "/use 14" },


    {spells.consecration, 'not player.isMoving and not target.hasMyDebuff(spells.consecration) and not target.isMoving and target.distanceMax <= 10' },
    {spells.seraphim, 'true' , env.damageTarget }, -- use Seraphim before using Wake of Ashes Icon Wake of Ashes
    {spells.avengingWrath, 'player.holyPower >= 3' },
    {spells.divineToll, 'kps.multiTarget' },
    {spells.divineToll, 'spells.executionSentence.lastCasted(5)' }, -- cast Divine Toll Icon Divine Toll during Execution Sentence Icon Execution Sentence (if talented).
    {spells.executionSentence, 'true' , env.damageTarget }, -- use Judgment and Final Reckoning before using Execution Sentence
    {spells.finalReckoning, 'mouseover.isAttackable' , env.damageTarget }, -- use Final Reckoning before Execution Sentence
    {spells.divineStorm, 'kps.multiTarget and player.holyPower == 5' , env.damageTarget},
    {spells.templarsVerdict, 'player.holyPower == 5' , env.damageTarget},    {spells.consecration, 'not player.isMoving and not target.isMoving and target.distanceMax <= 10' },
    {spells.wakeOfAshes, 'true',  env.damageTarget },
    {spells.hammerOfWrath, 'true' , env.damageTarget },
    {spells.bladeOfJustice, 'true' , env.damageTarget },
    {spells.judgment, 'true' , env.damageTarget },


    {spells.crusaderStrike, 'target.distanceMax  <= 10' , env.damageTarget},
    {spells.divineStorm, 'kps.multiTarget and target.distanceMax  <= 10' , env.damageTarget},
    {spells.templarsVerdict, 'target.distanceMax  <= 10' , env.damageTarget},
    {spells.shieldOfVengeance , 'true' },
    

--    {kps.hekili({
--    })}
}
,"Hekili")
