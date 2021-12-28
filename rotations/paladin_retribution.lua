--[[[
@module Paladin Retribution Rotation
@author Kirk24788
@version Hekili
]]--


local spells = kps.spells.paladin
local env = kps.env.paladin

local AshenHallow = spells.ashenHallow.name
local DoorOfShadows = spells.doorOfShadows.name

kps.rotations.register("PALADIN","RETRIBUTION",
{
    {{"macro"}, 'not target.isAttackable and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {{"macro"}, 'not target.exists and mouseover.isAttackable and mouseover.inCombat' , "/target mouseover" },
    {spells.blessingOfFreedom , 'player.isRoot' },
    {spells.everyManForHimself, 'player.isStun' },
    -- "Pierre de soins" 5512
    --{{"macro"}, 'player.hp < 0.70 and player.useItem(5512)' , "/use item:5512" },
    
    -- Venthyr
    --{{"macro"}, 'keys.shift and spells.ashenHallow.cooldown == 0', "/cast [@cursor] "..AshenHallow },
    --{{"macro"}, 'keys.alt and spells.doorOfShadows.cooldown == 0', "/cast [@cursor] "..DoorOfShadows},
    
    -- Necrolord
    {spells.fleshcraft, 'player.hp < 0.70' , "player" },
    {spells.fleshcraft, 'target.isElite' , "player" },
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
    {spells.flashOfLight, 'player.hp < 0.70 and player.hasBuff(spells.selflessHealer) and player.buffStacks(spells.selflessHealer) > 2' , "player" , "FLASH_PLAYER" },
    {spells.arcaneTorrent, 'true' },
    {spells.wordOfGlory, 'kps.groupSize() == 1 and player.hp < 0.50' , "player" },

    -- Interrupt
    {{"nested"}, 'kps.interrupt' ,{
        {spells.rebuke, 'target.isAttackable and target.distanceMax <= 10 and target.isCasting' , "target" },
        {spells.blindingLight, 'player.hasTalent(3,3) and target.isAttackable and target.distanceMax <= 10 and target.isCasting' , "target" },
        {spells.hammerOfJustice, 'target.isAttackable and target.distanceMax <= 10 and player.isPVP' , "target" },
        {spells.hammerOfJustice, 'target.isAttackable and target.distanceMax <= 10 and target.isInterruptable' , "target" },
        {spells.hammerOfJustice, 'target.isAttackable and target.distanceMax <= 10 and target.isCasting' , "target" },
    }},

    
    -- TRINKETS -- SLOT 0 /use 13
    --{{"macro"}, 'player.useTrinket(0) and player.timeInCombat > 9 and target.isAttackable' , "/use 13" },
    -- TRINKETS -- SLOT 1 /use 14
    --{{"macro"}, 'player.useTrinket(1) and player.timeInCombat > 30 and target.isAttackable' , "/use 14" },

    -- Blessing of Winter Frost damage and reduce enemies' movement speed 
    --{spells.blessingOfWinter, 'true' },
    -- Blessing of Autumn Cooldowns recover 30% faster.
    --{spells.blessingOfAutumn, 'spells.avengingWrath.cooldown > 9' },
    -- Blessing of Summer Attacks have a 40% chance to deal 30% additional damage as Holy.
    --{spells.blessingOfSummer, 'player.holyPower >= 3' },
    -- kyrian
    --{spells.divineToll, 'kps.multiTarget' },

	{spells.seraphim, 'player.hasTalent(5,3) and player.holyPower >= 3 and spells.finalReckoning.cooldown == 0' , env.damageTarget },  -- use Seraphim before using Wake of Ashes
	{spells.seraphim, 'player.hasTalent(5,3) and player.holyPower >= 3 and spells.executionSentence.cooldown == 0' , env.damageTarget },  -- use Seraphim before using Wake of Ashes
	{spells.avengingWrath, 'kps.multiTarget and player.holyPower >= 3' },
	{spells.templarsVerdict, 'player.holyPower == 5 and player.hasBuff(spells.vanquishersHammer)' , env.damageTarget}, -- use both charges of Vanquisher's Hammer after Seraphim 
	{spells.divineStorm, 'player.holyPower == 5 and player.plateCount >= 3' , env.damageTarget},
	{spells.templarsVerdict, 'player.holyPower == 5' , env.damageTarget},
	-- Necrolord
    {spells.vanquishersHammer, 'true' },
	{spells.shieldOfVengeance , 'player.plateCount >= 3' },
	{spells.shieldOfVengeance , 'target.isElite' },
	-- Holy Power generating
	{spells.bladeOfJustice, 'player.holyPower < 4' , env.damageTarget }, -- 2 holypower
	{spells.judgment, 'player.holyPower < 5' , env.damageTarget }, -- 1 holypower
	{spells.hammerOfWrath, 'player.holyPower < 5' , env.damageTarget }, -- 1 holypower
	{spells.crusaderStrike, 'player.holyPower < 5 and spells.crusaderStrike.charges == 2' , env.damageTarget}, -- 1 holypower
	{spells.wakeOfAshes, 'player.holyPower < 3',  env.damageTarget }, -- 3 holypower
	-- Holy Power spending
	{spells.templarsVerdict, 'player.hasBuff(spells.vanquishersHammer)' , env.damageTarget}, -- use both charges of Vanquisher's Hammer after Seraphim 
	{spells.finalReckoning, 'mouseover.isAttackable and player.holyPower >= 3' , env.damageTarget }, -- use Final Reckoning before Execution Sentence
	{spells.executionSentence, 'player.hasTalent(1,3)' , env.damageTarget }, -- use Judgment and Final Reckoning before using Execution Sentence
    {spells.divineStorm, 'player.plateCount >= 3' , env.damageTarget},
	{spells.templarsVerdict, 'true' , env.damageTarget},
	{spells.crusaderStrike, 'true' , env.damageTarget}, -- 1 holypower
	-- filler
	{spells.consecration, 'not player.isMoving and not target.hasMyDebuff(spells.consecration) and not target.isMoving and target.distanceMax <= 10' },


}
,"Hekili")
