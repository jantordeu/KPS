--[[[
@module Paladin Retribution Rotation
@author htordeux
@version 8.0.1
]]--
local spells = kps.spells.paladin
local env = kps.env.paladin

kps.rotations.register("PALADIN","RETRIBUTION",
{

    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat and mouseover.distance < 10' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat and mouseover.distance < 10' , "/target mouseover" },
    env.FocusMouseover,
    {{"macro"}, 'focus.exists and target.isUnit("focus")' , "/clearfocus" },
    {{"macro"}, 'not focus.isAttackable' , "/clearfocus" },
    
    {spells.greaterBlessingOfKings, 'not player.isInGroup and not player.hasBuff(spells.greaterBlessingOfKings)' },
    
    {spells.blessingOfFreedom , 'player.isRoot' },
    {spells.everyManForHimself, 'player.isStun' },
    {spells.divineShield, 'player.hp < 0.30' , "player" },
    {spells.divineShield, 'mouseover.isFriend and mouseover.isHealerInRaid and mouseover.hp < 0.30' ,"mouseover" },
    -- Def CD's
    {{"nested"}, 'kps.defensive', {
        -- "Main d’entrave" -- Movement speed reduced by 70%. 10 seconds remaining
        {spells.handOfHindrance, 'target.isMoving'},
        {spells.flashOfLight, 'player.hasTalent(6,1) and player.hp < 0.80 and player.buffStacks(spells.selflessHealer) >= 3', "player" },
        {spells.wordOfGlory , 'player.hasTalent(6,3) and player.hp < 0.80'},
        {spells.layOnHands, 'player.hp < 0.40', 'player'},
        {spells.flashOfLight, 'not player.hasTalent(6,1) and player.hp < 0.55 and not spells.flashOfLight.isRecastAt("player")', 'player'},
    }},
    
    -- Interrupt
    {{"nested"}, 'kps.interrupt',{
        {spells.hammerOfJustice, 'focus.distance < 10 and focus.isCasting and focus.isAttackable' , "focus" },
        {spells.hammerOfJustice, 'target.distance < 10 and target.isCasting and target.isAttackable' , "target" },
        -- " Réprimandes" "Rebuke" -- Interrupts spellcasting and prevents any spell in that school from being cast for 4 sec.
        {spells.rebuke, 'target.isCasting and target.isAttackable and target.castTimeLeft < 1' , "target" },
        {spells.rebuke, 'focus.isCasting and focus.isAttackable and focus.castTimeLeft < 1' , "focus" },
        --{spells.blindingLight, 'target.distance < 10 and player.plateCount > 2' , "target" },
        {spells.blindingLight, 'player.hasTalent(3,3) and target.distance < 10 and target.isCasting and target.isAttackable' , "target" },
        {spells.repentance, 'player.hasTalent(3,2) and target.isCasting and target.isAttackable' , "target" },
    }},

    {{"nested"},'kps.cooldowns', {
        {spells.cleanseToxins, 'heal.isPoisonDispellable' , kps.heal.isPoisonDispellable },
        {spells.cleanseToxins, 'heal.isDiseaseDispellable' , kps.heal.isDiseaseDispellable },
    }},
    -- "Pierre de soins" 5512
    {{"macro"}, 'player.useItem(5512) and player.hp <= 0.72' ,"/use item:5512" },
    -- "Blessing of Protection" -- Places a blessing on a party or raid member, protecting them from all physical attacks for 10 sec.
    {spells.blessingOfProtection, 'not player.isUnit("mouseover") and mouseover.hp < 0.40 and mouseover.isFriend' , "mouseover"},
    {spells.blessingOfProtection, 'player.hp < 0.55' , "player"},

    -- TRINKETS -- SLOT 0 /use 13
    {{"macro"}, 'player.useTrinket(0) and player.timeInCombat > 9 and target.isAttackable' , "/use 13" },
    -- TRINKETS -- SLOT 1 /use 14
    {{"macro"}, 'player.useTrinket(1) and player.timeInCombat > 9 and target.isAttackable' , "/use 14" },
    
    -- "Shield of Vengeance" -- Creates a barrier of holy light that absorbs (30 / 100 * Total health) damage for 15 sec.
    {spells.shieldOfVengeance, 'player.incomingDamage > player.incomingHeal and target.distance <= 10'},
    {spells.shieldOfVengeance, 'player.plateCount >= 3 and target.distance <= 10'},
    {spells.shieldOfVengeance, 'not player.isInGroup and target.distance <= 10'},
   
    {spells.inquisition, 'player.hasTalent(7,3) and player.holyPower > 2 and player.myBuffDuration(spells.inquisition) <= 20 and target.isAttackable' , "target" , "inquisition" },
    {spells.wakeOfAshes, 'player.hasBuff(spells.avengingWrath) and target.isAttackable and target.distance <= 10' , "target" },
    {spells.wakeOfAshes, 'player.holyPower <= 1 and spells.avengingWrath.cooldown > 45 and target.isAttackable and target.distance <= 10' , "target" , "wakeOfAshes_holyPower"},
    {spells.avengingWrath, 'player.hasTalent(7,3) and player.myBuffDuration(spells.inquisition) >= 20 and target.isAttackable and target.distance <= 10' , "target" },
    {spells.avengingWrath, 'player.hasTalent(7,3) and player.myBuffDuration(spells.inquisition) >= 20 and target.isAttackable and target.distance <= 10' , "target" },
    {spells.avengingWrath, 'not player.hasTalent(7,3)' },

    -- Templar's Verdict or Divine Storm at 3-4 Holy Power if following spells/buffs are active: Divine Purpose, Avenging Wrath/Crusade, Execution Sentence.
    -- Righteous Verdict Templar's Verdict increases the damage of your next Templar's Verdict by 15% for 6 sec.
    {spells.divineStorm, 'player.plateCount > 2 and player.holyPower == 5 and target.isAttackable' , "target" , "divineStorm_holyPower" },
    {spells.divineStorm, 'player.hasBuff(spells.avengingWrath) and player.plateCount > 2 and target.isAttackable'},
    {spells.divineStorm, 'player.plateCount > 2 and target.isAttackable'},
    
    {spells.templarsVerdict, 'player.holyPower == 5 and target.isAttackable' , "target" , "templarsVerdict_holyPower" },
    {spells.templarsVerdict, 'player.hasBuff(spells.avengingWrath) and target.isAttackable'}, 
    {spells.templarsVerdict, 'player.hasBuff(spells.righteousVerdict) and target.isAttackable' , "target" , "templarsVerdict_righteousVerdict" },

    {spells.judgment, 'target.isAttackable and player.holyPower <= 4' , "target" }, -- 10 sec cd -- Generates 1 Holy Power
    {spells.hammerOfWrath, 'player.hasTalent(2,3) and player.holyPower <= 4 and target.isAttackable' , "target" }, -- Generates 1 Holy Power.
    {spells.bladeOfJustice, 'player.hasTalent(2,2) and player.hasBuff(spells.bladeOfWrath) and target.isAttackable and target.distance <= 10' , "target" , "bladeOfJustice_bladeOfWrath" },
    {spells.bladeOfJustice, 'player.holyPower <= 3 and target.isAttackable and target.distance <= 10' , "target" },   -- Generates 2 Holy Power. 10 sec cd
    {spells.crusaderStrike, 'player.holyPower <= 4 and target.isAttackable'}, --Generates 1 Holy Power

    -- "Consecration" -- Generates 1 Holy Power.
    {spells.consecration, 'player.hasTalent(4,2) and player.holyPower <= 4 and target.distance <= 10' }, 

    {{"macro"}, 'true' , "/startattack" },

}
,"paladin_retribution_bfa")
