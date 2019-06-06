--[[[
@module Paladin Retribution Rotation
@author htordeux
@version 8.0.1
]]--
local spells = kps.spells.paladin
local env = kps.env.paladin

kps.rotations.register("PALADIN","RETRIBUTION",
{

    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat and mouseover.distance <= 10' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat and mouseover.distance <= 10' , "/target mouseover" },
    {{"macro"}, 'FocusMouseover()' , "/focus mouseover" },
    {{"macro"}, 'focus.exists and target.isUnit("focus")' , "/clearfocus" },
    {{"macro"}, 'focus.exists and not focus.isAttackable' , "/clearfocus" },
    
    {spells.greaterBlessingOfKings, 'not player.isInGroup and not player.hasBuff(spells.greaterBlessingOfKings)' },
    
    {spells.blessingOfFreedom , 'player.isRoot' },
    {spells.everyManForHimself, 'player.isStun' },
    {spells.divineShield, 'player.hp < 0.30' , "player" },
    {spells.divineShield, 'mouseover.isHealable and mouseover.hp < 0.30' ,"mouseover" },
    -- Def CD's
    {{"nested"}, 'kps.defensive', {
        -- "Main d’entrave" -- Movement speed reduced by 70%. 10 seconds remaining
        {spells.handOfHindrance, 'target.isMovingTimer(1.4)' , "target" },
        {spells.handOfHindrance, 'focus.isMovingTimer(1.4)' , "focus" },
        {spells.flashOfLight, 'player.hasTalent(6,1) and player.hp < 0.80 and player.buffStacks(spells.selflessHealer) >= 3', "player" },
        {spells.wordOfGlory , 'player.hasTalent(6,3) and player.hp < 0.80'},
        {spells.layOnHands, 'player.hp < 0.40', 'player'},
        {spells.flashOfLight, 'not player.hasTalent(6,1) and player.hp < 0.55 and not spells.flashOfLight.isRecastAt("player")', 'player'},
    }},
    
    -- Interrupt
    {{"nested"}, 'kps.interrupt',{
        {spells.hammerOfJustice, 'focus.distance <= 10 and focus.isCasting' , "focus" },
        {spells.hammerOfJustice, 'target.distance <= 10 and target.isCasting' , "target" },
        -- " Réprimandes" "Rebuke" -- Interrupts spellcasting and prevents any spell in that school from being cast for 4 sec.
        {spells.rebuke, 'target.isCasting and target.isInterruptable and target.castTimeLeft < 2' , "target" },
        {spells.rebuke, 'focus.isCasting and focus.isInterruptable and focus.castTimeLeft < 2' , "focus" },
        {spells.blindingLight, 'player.hasTalent(3,3) and target.distance <= 10 and target.isCasting' , "target" },
        {spells.repentance, 'player.hasTalent(3,2) and target.isCasting' , "target" },
    }},

    {{"nested"},'kps.cooldowns', {
        {spells.cleanseToxins, 'heal.isPoisonDispellable' , kps.heal.isPoisonDispellable },
        {spells.cleanseToxins, 'heal.isDiseaseDispellable' , kps.heal.isDiseaseDispellable },
    }},
    -- "Pierre de soins" 5512
    {{"macro"}, 'player.useItem(5512) and player.hp <= 0.72' ,"/use item:5512" },
    -- "Blessing of Protection" -- Places a blessing on a party or raid member, protecting them from all physical attacks for 10 sec.
    {spells.blessingOfProtection, 'mouseover.isHealable and mouseover.hp < 0.40' , "mouseover"},
    {spells.blessingOfProtection, 'player.hp < 0.55' , "player"},

    -- TRINKETS -- SLOT 0 /use 13
    {{"macro"}, 'player.useTrinket(0) and player.timeInCombat > 9 and player.hasBuff(spells.crusade) and target.isAttackable' , "/use 13" },
    {{"macro"}, 'player.useTrinket(0) and player.timeInCombat > 9 and player.hasBuff(spells.avengingWrath) and target.isAttackable' , "/use 13" },
   -- TRINKETS -- SLOT 1 /use 14
    {{"macro"}, 'player.useTrinket(1) and player.timeInCombat > 30 and player.hasBuff(spells.crusade) and target.isAttackable' , "/use 14" },
    {{"macro"}, 'player.useTrinket(1) and player.timeInCombat > 30 and player.hasBuff(spells.avengingWrath) and target.isAttackable' , "/use 14" },
    
    -- "Shield of Vengeance" -- Creates a barrier of holy light that absorbs (30 / 100 * Total health) damage for 15 sec.
    {spells.shieldOfVengeance, 'player.incomingDamage > player.incomingHeal and target.distance <= 10'},
    {spells.shieldOfVengeance, 'player.plateCount >= 3 and target.distance <= 10'},
   
    {spells.inquisition, 'player.hasTalent(7,3) and player.holyPower >= 3 and player.myBuffDuration(spells.inquisition) <= 20 and target.isAttackable' , "target" , "inquisition" },
    {spells.avengingWrath, 'kps.cooldowns and player.hasTalent(7,3) and player.myBuffDuration(spells.inquisition) >= 20 and target.isAttackable and target.distance <= 10' },
    {spells.avengingWrath, 'kps.cooldowns and player.hasTalent(7,1) and target.isAttackable and target.distance <= 10' },
    {spells.crusade, 'kps.cooldowns and player.hasTalent(7,2) and player.holyPower >= 3 and target.isAttackable and target.distance <= 10' },

    {{"nested"}, 'player.holyPower <= 1 and target.isAttackable and target.distance <= 10', {
        {spells.wakeOfAshes, 'player.hasBuff(spells.avengingWrath)' , "target" , "wakeOfAshes_avengingWrath" },
        {spells.wakeOfAshes, 'player.hasBuff(spells.crusade)' , "target" , "wakeOfAshes_crusade" },
        {spells.wakeOfAshes, 'not player.hasTalent(7,2) and spells.avengingWrath.cooldown > 45' , "target" , "wakeOfAshes_avengingWrath_cd" },
        {spells.wakeOfAshes, 'player.hasTalent(7,2) and spells.crusade.cooldown > 45' , "target" , "wakeOfAshes_crusade_cd" },
    }},

    {spells.divineStorm, 'kps.multiTarget and target.isAttackable' , "target" , "divineStorm" },
    {spells.templarsVerdict, 'target.isAttackable' , "target" , "templarsVerdict" },
    {spells.divineStorm, 'player.hasBuff(spells.empyreanPower) and target.isAttackable' , "target" , "divineStorm_empyreanPower" },
    {spells.divineStorm, 'player.plateCount > 2 and target.isAttackable' , "target" , "divineStorm" },
    {spells.hammerOfWrath, 'player.hasTalent(2,3) and target.isAttackable and player.hasBuff(spells.crusade)' , "target" }, -- Generates 1 Holy Power.

    -- "Empyrean Power" 286393 -- buff -- Your next Divine Storm is free and deals 0 additional damage.
    -- "Blade of Wrath" 281178 -- buff -- Your next Blade of Justice deals 25% increased damage.
    -- Templar's Verdict or Divine Storm at 3-4 Holy Power if following spells/buffs are active: Divine Purpose, Avenging Wrath/Crusade, Execution Sentence.
    -- Righteous Verdict Talent(1,2) -- Templar's Verdict increases the damage of your next Templar's Verdict by 15% for 6 sec.

    {spells.bladeOfJustice, 'player.holyPower <= 3 and target.isAttackable and target.distance <= 10' , "target" },   -- Generates 2 Holy Power. 10 sec cd
    {spells.judgment, 'target.isAttackable and target.distance <= 30' , "target" }, -- 10 sec cd -- Generates 1 Holy Power 
    {spells.hammerOfWrath, 'player.holyPower <= 4 and player.hasTalent(2,3) and target.isAttackable' , "target" }, -- Generates 1 Holy Power.
    {spells.consecration, 'player.holyPower <= 4 and player.hasTalent(4,2) target.isAttackable and target.distance <= 10' }, -- Generates 1 Holy Power.
    {spells.crusaderStrike, 'player.holyPower <= 4 and target.isAttackable and target.distance <= 10'}, --Generates 1 Holy Power

    --{{"macro"}, 'true' , "/startattack" },

}
,"paladin_retribution_bfa")
