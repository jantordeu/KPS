# KPS
[![Build Status](https://travis-ci.org/kirk24788/KPS.svg?branch=master)](https://travis-ci.org/kirk24788/KPS)


_JUST ANOTHER PLUA ADDON FOR WORLD OF WARCRAFT_

This addon in combination with enabled protected LUA will help you get the most
out of your WoW experience. This addon is based on JPS with a lot of refactoring
to clean up the codebase which has grown a lot in the last 4 years.

The main goal is to have a clean and fast codebase to allow further development.

*Huge thanks to htordeux and pcmd for their contributions to KPS*

*Thanks to jp-ganis, htordeux, nishikazuhiro, hax mcgee, pcmd
and many more for all their contributions to the original JPS*

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

Copyright (C) 2015 Mario Mancino


## Commands

 * `/kps` - Show enabled status.
 * `/kps enable/disable/toggle` - Enable/Disable the addon.
 * `/kps cooldowns/cds` - Toggle use of cooldowns.
 * `/kps pew` - Spammable macro to do your best moves, if for some reason you don't want it fully automated.
 * `/kps interrupt/int` - Toggle interrupting.
 * `/kps multitarget/multi/aoe` - Toggle manual MultiTarget mode.
 * `/kps defensive/def` - Toggle use of defensive cooldowns.
 * `/kps help` - Show this help text.




## Builds and Classes

All DPS Specs have at least one rotation automatically generated from SimCraft - those might not be fully functional and aren't tested.

**Fully Supported in 8.0.1:**

* Deathknight: Blood
* Demonhunter: Havoc, Vengeance
* Druid: Feral
* Hunter: Marksmanship
* Mage: Fire, Frost
* Paladin: Protection, Retribution
* Rogue: Outlaw
* Shaman: Elemental
* Warlock: Affliction, Destruction
* Warrior: Fury, Protection

**Outdated Rotations:**

* Deathknight: Frost (7.0.3), Unholy (7.0.3)
* Druid: Balance (7.0.3), Guardian (7.0.3), Restoration (7.0.3)
* Hunter: Beastmaster (7.2.0)
* Mage: Arcane (8.1.0)
* Monk: Mistweaver (7.0.3)
* Paladin: Holy (7.0.3)
* Priest: Discipline (8.1), Holy (8.1), Shadow (8.1)
* Shaman: Restoration (7.0.3)
* Warlock: Demonology (7.0.3)

**Automatically Generated Rotations:**
_(Might not be fully functional)_

* Hunter: Survival (8.0.1)
* Monk: Brewmaster (8.0.1), Windwalker (6.2.2)
* Rogue: Assassination (8.0.1), Subtlety (8.0.1)
* Shaman: Enhancement (8.0.1)
* Warrior: Arms (8.0.1)

**Special Thanks for contributing to the KPS rotations:**

* htordeux
* prescient



##  Development
If you want to help developing this AddOn, you are welcome, but there a few rules to make sure KPS is maintable.

### Prerequisites
If you don't have it yet please install Brew (http://brew.sh).
You also have to install the Command Line Utils to for `make` and of course you need to have LUA installed (also available via brew!).

If you don't have a Mac, you somehow have to provide these tools:

* python (at least 2.6)
* make

### Pull Requests
1. [Fork it!](https://github.com/kirk24788/KPS/fork)

2. Create a branch for your changes

        $ git checkout -b my_new_feature

3. Make any changes and run a `make test` in your KPS directory - only create the pull request if *ALL* tests
are OK!

4. Run `make readme` to update the current issues in the `README.md`.

4. Commit and Push your changes

        $ git commit -am "My new feature"
        $ git push origin my_new_feature

5. Open a [Pull Request](http://github.com/kirk24788/KPS/pulls)

### Code Guidelines
* Use 4 spaces for indentation - *NO TABS!*
* All variables must be _lower_ camel case
* All classes must be _upper_ camel case

### Project Structure
* `core`: Core functionality, please think twice before adding anything here, this should only contain backend stuff which isn't used in rotations.
* `gui`: All GUI-related stuff should be consolidated here.
* `libs`: External Libraries.
* `media`: Custom image and sound files.
* `modules`: Wrapper modules for blizzard functions which are used in the rotations.
* `rotations`: Class spells and rotation files. Spell Files are generated by `printClassSpells.py` don't edit these manually, your changes will be overwritten.
* `simc`: SimCraft rotation files used for rotation conversions.
* `utils`: Utility scripts for generating various files for this addon

### Automatic Code Generation
Some files are created automatically by the `makefile`. Please restrain from editing these files, as your changes will not be permanent.
Instead edit the apropriate files in the `utils` directory.

* `kps.toc`: Generated from `_test.lua` - if you need to change the order or add files, please add an additional `require(...)` statement there.
* `README.me`: Generated from `utils/generateREADME.py` - if you want to change the documentation, see the template at `utils/templates/README.md`.
* `modules/spell/spells.lua`: Generated by `utils/printGlobalSpells.py`
* `rotations/<classname>.lua`: Generated by `utils/printClassSpells.py` - if you need additional spells or functions, please add them there.
* `rotations/<classname>_<specname>.lua`: Generated by `utils/convertSimC.py` if not explicitly commented out in the `makefile` - if you want to write a custom rotation comment out the line in the makefile to prevent your rotation from being overwritten.

### Rotation Modules
#### Damage/Raid Status

Members:

 * `damage.count` - return the size of the current raidtarget group
 * `damage.enemyTarget` - Returns the enemy target for all raid members
 * `damage.enemyLowest` - Returns the lowest Health enemy target for all raid members
 * `damage.enemyCasting` - Returns the casting enemy target for all raid members


#### Heal/Raid Status
Helper functions for Raiders in Groups or Raids mainly aimed for healing rotations, but might be useful
for some DPS Rotations too.

Members:

 * `heal.count` - return the size of the current group
 * `heal.type` - return the group type - either 'group' or 'raid'
 * `heal.lowestTankInRaid` - Returns the lowest tank in the raid - a tank is either:
    * any group member that has the Group Role `TANK`
    * is `focus` target
    * `player` if neither Group Role nor `focus` are set
 * `heal.lowestUnitInRaid` - Returns the lowest unit in the raid - exclude tank
 * `heal.defaultTarget` - Returns the default healing target based on these rules:
    * `player` if the player is below 20% hp incoming
    * `focus` if the focus is below 50% hp incoming (if the focus is not healable, `focustarget` is checked instead)
    * `target` if the target is below 50% hp incoming (if the target is not healable, `targettarget` is checked instead)
    * lowest tank in raid which is below 50% hp incoming
    * lowest raid member
    When used as a _target_ in your rotation, you *must* write `kps.heal.defaultTarget`!
 * `heal.defaultTank` - Returns the default tank based on these rules:
    * `player` if the player is below 20% hp incoming
    * `focus` if the focus is below 50% hp incoming (if the focus is not healable, `focustarget` is checked instead)
    * `target` if the target is below 50% hp incoming (if the target is not healable, `targettarget` is checked instead)
    * lowest tank in raid
    When used as a _target_ in your rotation, you *must* write `kps.heal.defaultTank`!
 * `heal.averageHealthRaid` - Returns the average hp incoming for all raid members
 * `heal.lossHealthRaid` - Returns the loss Health for all raid members
 * `heal.incomingHealthRaid` - Returns the incoming Health for all raid members
 * `heal.countLossInRange(<PCT>)` - Returns the count for all raid members below threshold health e.g. heal.countLossInRange(0.90)
 * `heal.countLossInDistance(<PCT>,<DIST>)` - Returns the count for all raid members below threshold health (default countInRange) in a distance (default 10 yards) e.g. heal.countLossInRange(0.90)
 * `heal.aggroTankTarget` - Returns the tank with highest aggro on the current target (*not* the unit with the highest aggro!). If there is no tank in the target thread list, the `heal.defaultTank` is returned instead.
    When used as a _target_ in your rotation, you *must* write `kps.heal.aggroTankTarget`!
 * `heal.aggroTankFocus` - Returns the tank with highest aggro on the current focus (*not* the unit with the highest aggro!). If there is no tank in the focus thread list, the `heal.defaultTank` is returned instead.
    When used as a _target_ in your rotation, you *must* write `kps.heal.aggroTankFocus`!
 * `heal.aggroTank` - Returns the tank or unit if overnuked with highest aggro and lowest health Without otherunit specified.
 * `heal.hasDebuffDispellable` - Returns the raid unit with dispellable debuff e.g. kps.heal.hasDebuffDispellable("Magic")
 * `heal.isMagicDispellable` - Returns the raid unit with magic debuff to dispel e.g. {spells.purify, 'heal.isMagicDispellable' , kps.heal.isMagicDispellable },
 * `heal.isDiseaseDispellable` - Returns the raid unit with disease debuff to dispel
 * `heal.isPoisonDispellable` - Returns the raid unit with poison debuff to dispel
 * `heal.isCurseDispellable` - Returns the raid unit with curse debuff to dispel
 * `heal.hasAbsorptionHeal` - Returns the raid unit with an absorption Debuff
 * `heal.hasBossDebuff` - Returns the raid unit with a Boss Debuff
 * `heal.hasBuffCount(<BUFF>)` - Returns the buff count for a specific Buff on raid e.g. heal.hasBuffCount(spells.atonement) > 3
 * `heal.hasBuffAtonement` - Returns the UNIT with lowest health with Atonement Buff on raid e.g. heal.hasBuffAtonement.hp < 0.90
 * `heal.hasNotBuffAtonement` - Returns the UNIT with lowest health without Atonement Buff on raid e.g. heal.hasNotBuffAtonement.hp < 0.90
 * `heal.hasNotBuffMending` - Returns the lowest health unit without Prayer of Mending Buff on raid e.g. heal.hasNotBuffMending.hp < 0.90
 * `heal.hasNotBuffRenew` - Returns the lowest health unit without Renew Buff on raid e.g. heal.hasNotBuffRenew.hp < 0.90
 * `heal.atonementHealthRaid` - Returns the loss Health for all raid members with buff atonement
 * `heal.enemyTarget` - Returns the enemy target for all raid members
 * `heal.enemyLowest` - Returns the lowest Health enemy target for all raid members


#### Keys
Simple Module for checking if special keys are being pressed.

Members:

 * `keys.shift` - SHIFT Key
 * `keys.alt` - ALT Key
 * `keys.ctrl` - CTRL Key


#### Player Class
Provides access to specific player information. Since `player` extends the Unit Class all members of
`UNIT` are also members of `player`.

Members:

 * `player.isMounted` - returns true if the player is mounted (exception: Nagrand Mounts do not count as mounted since you can cast while riding)
 * `player.isFalling` - returns true if the player is currently falling.
 * `player.IsFallingSince(<seconds>)` - returns true if the player is falling longer than n seconds.
 * `player.isSwimming` - returns true if the player is currently swimming.
 * `player.timeToShard` - returns average time to the next soul shard.
 * `player.isInRaid` - returns true if the player is currently in Raid.
 * `player.isInGroup` - returns true if the player is currently in Group.
 * `player.isControlled` - Checks whether you are controlled over your character (you are feared, etc).
 * `player.isRoot` - Checks whether you are controlled over your character (you are feared, etc).
 * `player.isStun` - Checks whether you are controlled over your character (you are feared, etc).
 * `player.isStun` - Checks whether you are controlled over your character (you are feared, etc).
 * `player.timeInCombat` - returns number of seconds in combat
 * `player.hasTalent(<ROW>,<TALENT>)` - returns true if the player has the selected talent (row: 1-7, talent: 1-3).
 * `player.hasGlyph(<GLYPH>)` - returns true if the player has the given gylph - glyphs can be accessed via the spells (e.g.: `player.hasGlyph(spells.glyphOfDeathGrip)`).
 * `player.useItem(<ITEMID>)` - returns true if the player has the given item and cooldown == 0
 * `player.useTrinket(<SLOT>)` - returns true if the player has the given trinket and cooldown == 0
 * `player.hasTrinket(<SLOT>)` - returns true if the player has the given trinket ID e.g. 'player.hasTrinket(1) == 147007 and player.useTrinket(1)'
 * `player.lastEmpowermentCast` - returns the time of the last cast of Demonic Empowerment
 * `player.demons` - returns the number of active demons
 * `player.empoweredDemons` - returns the number of empowered demons
 * `player.empoweredDemonsDuration` - returns the remaning duration of for currently empowered demons - if the empowerment was casted twice, the lowest duration will be used so the duration matches all demons counted by `player.empowerDemons`.
 * `player.eclipseDirLunar` - returns true if the balance bar is currently going towards Lunar
 * `player.eclipseDirSolar` - returns true if the balance bar is currently going towards Solar
 * `player.eclipsePower` - returns current eclipse power - ranges from 100(solar) to -100(lunar)
 * `player.eclipsePhase` - returns the current eclipse phase:
    * 1: Lunar Up-cycle – going towards peak Lunar Eclipse. (8 sec, plus 2 sec of “peak”)
    * 2: Lunar Down-cycle – going towards Solar Eclipse.
    * 3: Solar Up-cycle – going towards peak Solar Eclipse. (2 sec of “peak, plus 8 sec.)
    * 4: Solar Down-cycle – going towards Lunar Eclipse
 * `player.eclipseSolar` - returns true if we're currently in solar phase
 * `player.eclipseLunar` - returns true if we're currently in lunar phase
 * `player.eclipsePhaseDuration` - returns the duration of each eclipse phase
 * `player.eclipseMax` - time until the next solar or lunar max
 * `player.eclipseLunarMax` - time until the next lunar max is reached
 * `player.eclipseSolarMax` - time until the next solar max is reached
 * `player.eclipseChange` - time until the eclipse energy hits 0
 * `player.rage` - Rage
 * `player.rageMax` - Max Rage
 * `player.focus` - Focus
 * `player.focusMax` - Max Focus
 * `player.focusRegen` - Focus Regeneration per Second
 * `player.focusTimeToMax` - Time until focus has completely regenerated
 * `player.energy` - Energy
 * `player.energyMax` - Max Energy
 * `player.energyRegen` - Energy Regeneration per Second
 * `player.energyTimeToMax` - Time until energy has completely regenerated
 * `player.comboPoints` - Combo Points
 * `player.runicPower` - Runic Power
 * `player.soulShards` - Soul Shards
 * `player.astralPower` - Astral Power (Druid)
 * `player.holyPower` - Holy Power
 * `player.maelstrom` - Shadow Orbs
 * `player.chi` - Chi
 * `player.chiMax` - Chi Max
 * `player.insanity` -- SPELL_POWER_INSANITY 13 Legion Insanity are used by Shadow Priests
 * `player.arcaneCharges` - Arcane Charges (Arcane Mage)
 * `player.fury` - Fury (Demon Hunter)
 * `player.pain` - Pain (Demon Hunter)
 * `player.hasProc` - returns true if the player has a proc (either mastery, crit, haste, int, strength or agility)
 * `player.hasMasteryProc` - returns true if the player has a mastery proc
 * `player.hasCritProc` - returns true if the player has a crit proc
 * `player.hasHasteProc` - returns true if the player has a haste proc
 * `player.haste` - returns the player haste
 * `player.hasIntProc` - returns true if the player has a int proc
 * `player.hasStrProc` - returns true if the player has a strength proc
 * `player.hasAgiProc` - returns true if the player has a agility proc
 * `player.gcd` - returns the current global cooldown
 * `player.bloodlust` - returns true if th player has bloodlus (or heroism, time warp...)
 * `player.timeToNextHolyPower` - returns the time until the next holy power (including the gcd or cast time of the next power generating spell)
 * `player.runes` - returns the total number of active runes
 * `player.runesCooldown` - returns the cooldown until the next rune is available
 * `player.hasSealOfTruth` - returns if the player has the seal of truth
 * `player.hasSealOfRighteousness` - returns if the player has the seal of righteousness
 * `player.hasSealOfJustice` - returns if the player has the seal of justice
 * `player.hasSealOfInsight` - returns if the player has the seal of insight
 * `player.stagger` - returns the stagger left on the player
 * `player.staggerTick` - returns the stagger damager per tick
 * `player.staggerPercent` - returns the percentage of stagger to the current player health
 * `player.staggerPercentTotal` - returns the percentage of stagger to the player max health
 * `<PLAYER>.isMoving` - returns true if the player is currently moving - oppposed to the `<UNIT>.isMoving` this one is more reliable.
 * `<PLAYER>.isMovingSince(<SECONDS>)` - returns true if the player is currently moving - oppposed to the `<UNIT>.isMoving` this one is more reliable.
 * `<PLAYER>.isNotMovingSince(<SECONDS>)` - returns true if the player is currently not moving for the given amount of seconds.
 * `<UNIT>.plateCount` - e.g. 'player.plateCount' returns namePlates count in combat (actives enemies)
 * `<UNIT>.plateCountDebuff` - e.g. 'player.plateCountDebuff(spells.shadowWordPain)' returns namePlates count with specified debuff in combat (actives enemies)
 * `<UNIT>.isTarget` - returns true if the unit is targeted by an enemy nameplate
 * `<UNIT>.isTargetCount` - returns the number of enemies targeting player.
 * `player.isBehind` - returns true if the player is behind the last target. Also returns true if the player never received an error - if you want to check if the player is in front *DON'T* use this function!
 * `player.isInFront` - returns true if the player is in front of the last target. Also returns true if the player never received an error - if you want to check if the player is behind *DON'T* use this function!


#### Spell Class
Provides access to specific spell information and provide an localization-independant access to WoW spells.

Assuming you want to cast `mySpell`, then `<SPELL>` may be one of:

 * `spells.mySpell`: If you are in a rotation *condition* - you can also use this short notation within your rotation spells, if you have previously defined spells like so (which is by default the first line in every class rotation):
   ```
      local spells = kps.spells.warlock
   ```
 * `kps.spells.warlock.mySpell`: This is the fully qualified spell, you can always use this if you're unsure or if you want to access other classes spells

Members:

 * `<SPELL>.spellbookType` - returns the spellbook type - either 'spell' for a player spell or 'pet' for a pet spell
 * `<SPELL>.spellbookIndex` - returns the index of this spell in the spellbook
 * `<SPELL>.isKnown` - returns true if this spell is known to the player
 * `<SPELL>.hasRange` - returns true if this spell has a range
 * `<SPELL>.inRange(<UNIT-STRING>)` - returns true if this spell is in range of the given unit (e.g.: `spells.immolate.inRange("target")`).
 * `<SPELL>.charges` - returns the current charges left of this spell if it has charges or 0 if this spell has no charges
 * `<SPELL>.castTime` - returns the total cast time of this spell
 * `<SPELL>.cooldown` - returns the current cooldown of this spell 
 * `<SPELL>.cooldownTotal` - returns the cooldown in seconds the spell has if casted - this is NOT the current cooldown of the spell! 
 * `<SPELL>.cost` - returns the cost (mana, rage...) for a given spell
 * `<SPELL>.isRecastAt(<UNIT-STRING>)` - returns true if this was last casted spell and the last targetted unit was the given unit (e.g.: `spell.immolate.isRecastAt("target")`). 
 * `<SPELL>.castTimeLeft(<UNIT-STRING>)` - returns the castTimeLeft or channelTimeLeft in seconds the spell has if casted (e.g.: 'spells.mindFlay.castTimeLeft("player") > 0.5' )
 * `<SPELL>.needsSelect` - returns true this is an AoE spell which needs to be targetted on the ground.
 * `<SPELL>.isBattleRez` - returns true if this spell is one of the batlle rez spells.
 * `<SPELL>.isPrioritySpell` - returns true if this is one of the user-casted spells which should be ignored for the spell queue. (internal use only!)
 * `<SPELL>.canBeCastAt(<UNIT-STRING>)` - returns true if the spell can be cast at the given unit (e.g.: `spell.immolate.canBeCastAt("focus")`). A spell can be cast if the target unit exists, the player has enough resources, the spell is not on cooldown and the target is in range.
 * `<SPELL>.lastCasted(<DURATION>)` - returns true if the spell was last casted within the given duration (e.g.: `spell.immolate.lastCasted(2)`).
 * `<SPELL>.shouldInterrupt(<BREAKPOINT>, flag)` - returns true if the casting spell overheals above brealpoint (e.g.: `spells.heal.shouldInterrupt(0.90)`).
 * `<SPELL>.tickTime` - returns the tick interval time of this spell - only useful for DoT's


#### Totem Class
Access to Totem data.
<TOTEM> may be one of:
 * `totem.fire`
 * `totem.earth`
 * `totem.water`
 * `totem.air`

Members:

 * `<TOTEM>.isActive` - returns true if the given totem is active
 * `<TOTEM>.duration` - returns the duration left on the given totem
 * `<TOTEM>.name` - returns the totem name


#### Unit Class
Provides access to specific unit information. <UNIT> may be one of:
 * `player`
 * `target`
 * `targettarget`
 * `pet`
 * `focus`
 * `focustarget`
 * `mouseover`
 * `mouseovertarget`

Members:

 * `<UNIT>.exists` - returns true if this unit exists
 * `<UNIT>.hasBuff(<SPELL>)` - return true if the unit has the given buff (`target.hasBuff(spells.renew)`)
 * `<UNIT>.hasDebuff(<SPELL>)` - returns true if the unit has the given debuff (`target.hasDebuff(spells.immolate)`)
 * `<UNIT>.hasMyDebuff(<SPELL>)` - returns true if the unit has the given debuff _AND_ the debuff was cast by the player (`target.hasMyDebuff(spells.immolate)`)
 * `<UNIT>.myBuffDuration(<SPELL>)` - returns the remaining duration of the buff on the given unit if the buff was cast by the player
 * `<UNIT>.myDebuffDuration(<SPELL>)` - returns the remaining duration of the debuff on the given unit if the debuff was cast by the player
 * `<UNIT>.myDebuffDurationMax(<SPELL>)` - returns the total duration of the given debuff if it was cast by the player
 * `<UNIT>.buffDuration(<SPELL>)` - returns the remaining duration of the given buff
 * `<UNIT>.debuffDuration(<SPELL>)` - returns the remaining duration of the given debuff
 * `<UNIT>.debuffStacks(<SPELL>)` - returns the debuff stacks on for the given <SPELL> on this unit
 * `<UNIT>.buffStacks(<SPELL>)` - returns the buff stacks on for the given <SPELL> on this unit
 * `<UNIT>.debuffCount(<SPELL>)` - returns the number of different debuffs (not counting the stacks!) on for the given <SPELL> on this unit
 * `<UNIT>.buffCount(<SPELL>)` - returns the number of different buffs (not counting the stacks!) on for the given <SPELL> on this unit
 * `<UNIT>.myDebuffCount(<SPELL>)` - returns the number of different debuffs (not counting the stacks!) on for the given <SPELL> on this unit if the spells were cast by the player
 * `<UNIT>.myBuffCount(<SPELL>)` - returns the number of different buffs (not counting the stacks!) on for the given <SPELL> on this unit if the spells were cast by the player
 * `<UNIT>.buffValue(<BUFF>)` - returns the amount of a given <BUFF> on this unit e.g. player.buffValue(spells.masteryEchoOfLight)
 * `<UNIT>.isDispellable(<DISPEL>)` - returns true if the FRIENDLY unit has a dispellable debuff. DISPEL TYPE "Magic", "Poison", "Disease", "Curse". e.g. player.isDispellable("Magic")
 * `<UNIT>.isBuffDispellable` - returns true if the ENEMY unit has a dispellable "Magic" buff. e.g. target.isBuffDispellable
 * `<UNIT>.absorptionHeal` - returns true if the unit has an Absorption Healing Debuff
 * `<UNIT>.immuneDamage` - returns true if the unit has an aura to avoid damaging
 * `<UNIT>.immuneHeal` - returns true if the unit has an Immune Healing Debuff
 * `<UNIT>.hasBossDebuff` - return true if the FRIENDLY unit has a boss debuff e.g. `target.hasBossDebuff`
 * `<UNIT>.isStealable` - return true if the ENEMY unit has a stealable buff e.g. `target.isStealable`
 * `<UNIT>.isControlled` - return true if the ENEMY unit has a CC debuff
 * `<UNIT>.castTimeLeft` - returns the casting time left for this unit or 0 if it is not casting
 * `<UNIT>.channelTimeLeft` - returns the channeling time left for this unit or 0 if it is not channeling
 * `<UNIT>.isCasting` - returns true if the unit is casting (or channeling) a spell
 * `<UNIT>.isCastingSpell(<SPELL>)` - returns true if the unit is casting (or channeling) the given <SPELL> (`target.isCastingSpell(spells.immolate)`)
 * `<UNIT>.isInterruptable` - returns true if the unit is currently casting (or channeling) a spell which can be interrupted.
 * `<UNIT>.incomingDamage` - returns incoming damage of the unit over last 4 seconds
 * `<UNIT>.incomingHeal` - returns incoming heal of the unit over last 4 seconds
 * `<UNIT>.name` - returns the unit name
 * `<UNIT>.guid` - returns the unit guid
 * `<UNIT>.npcId` - returns the unit id (as seen on wowhead)
 * `<UNIT>.level` - returns the unit level
 * `<UNIT>.isRaidBoss` - returns true if the unit is a raid boss
 * `<UNIT>.isElite` - returns true if the unit is a elite mob
 * `<UNIT>.isClassDistance` - returns true if the unit is a class distance
 * `<UNIT>.hp` - returns the unit hp (in a range between 0.0 and 1.0).
 * `<UNIT>.hpTotal` - returns the current hp as an absolute value.
 * `<UNIT>.hpMax` - returns the maximum hp as an absolute value
 * `<UNIT>.hpIncoming` - returns the unit hp with incoming heals (in a range between 0.0 and 1.0).
 * `<UNIT>.mana` - returns the unit mana (in a range between 0.0 and 1.0).
 * `<UNIT>.manaTotal` - returns the current unit mana as an absolute value.
 * `<UNIT>.manaMax` - returns the maximum unit mana as an ansolute value.
 * `<UNIT>.comboPoints` - returns the number of combo points _from_ the player _on_ this unit.
 * `<UNIT>.distance` - returns the approximated distance to the given unit (same as `<UNIT.distanceMax`).
 * `<UNIT>.distanceMin` - returns the min. approximated distance to the given unit.
 * `<UNIT>.distanceMax` - returns the max. approximated distance to the given unit.
 * `<UNIT>.lineOfSight` - returns false during 2 seconds if unit is out of line sight either returns true
 * `<UNIT>.isPVP` - returns true if the given unit is in PVP.
 * `<UNIT>.isAttackable` - returns true if the given unit can be attacked by the player.
 * `<UNIT>.inCombat` - returns true if the given unit is in Combat.
 * `<UNIT>.isMoving` - returns true if the given unit is currently moving.
 * `<UNIT>.isMovingTimer(<SECONDS>)` - returns true if the player is falling longer than n seconds.
 * `<UNIT>.isDead` - returns true if the unit is dead.
 * `<UNIT>.isDrinking` - returns true if the given unit is currently eating/drinking.
 * `<UNIT>.inVehicle` - returns true if the given unit is inside a vehicle.
 * `<UNIT>.isFriend` - returns true if the unit is a friend unit
 * `<UNIT>.isHealable` - returns true if the given unit is healable by the player.
 * `<UNIT>.hasPet` - returns true if the given unit has a pet.
 * `<UNIT>.isUnit(<UNIT-STRING>)` - returns true if the given unit is otherunit. heal.lowestInRaid.isUnit("player")
 * `<UNIT>.hasAttackableTarget` - returns true if the given unit has attackable target
 * `<UNIT>.isRaidTank` - returns true if the given unit is a tank
 * `<UNIT>.hasRoleInRaid(<STRING>)` - returns true if the given unit has role TANK, HEALER, DAMAGER, NONE


### Rotations
It is pretty simple to write your own rotation. The easiest way is to extend one of the rotation files in `rotations/CLASSNAME_SPECNAME.lua`.
But you may be better of if you create a seperate file or even another addon.

#### Rotation File Skeleton
No matter which way you choose, you should always start your
rotation with.
```
local spells = kps.spells.classname
local env = kps.env.classname
```

Replace `classname` with whatever class you're writing this rotation for. While not needed, this local definitions help you to write easier to read rotations.

Next will be your rotation(s), they can be registered with `kps.rotations.register(...)`. This function takes 4-5 parameters:

1. Classname (Uppercase String, e.g.: "SHAMAN")
1. Specname (Uppercase String, e.g.: "ENHANCEMENT")
1. Rotation Table
1. Description of the Rotation (will be shown in Dropdown if multiple Rotations exist)
1. _Optional:_ Required Talents for this Spec

```
kps.rotations.register("SHAMAN","ENHANCEMENT",
{
...
}
,"shaman enhancement", {...})
```

#### Rotation Table
This is your actual rotation, every element is evaluated until a tuple containing the spell object and a target are returned. The elements can be one of:

 * Simple Cast
 * Cast Sequence
 * Function
 * Macro
 * Nested Rotation Table

##### Simple Cast
_Syntax:_
```
  {SPELL, CONDITION, TARGET}
```

*SPELL*
The first element is mandatory, and must be a spell object - e.g.: `spells.lavaLash` - this is the reason why we needed the `local spells = kps.spells.classname` in the rotation skeleton, else we would also have to write `kps.spells.shaman.lavaLash`.

*CONDITION*
The second element is a little more complex, usually this is a string, like `'player.soulShards >= 3'`. For a detailed description
on the availabe modules check the _Rotation Modules_ section, but you can also call Lua functions within the condition.

But you can also supply a function here (_the function itself, not a call to a function!_). This function must not take any parameters
and should return a boolean value, like:
```
local function myCondition()
    return kps.env.player.soulShards >= 3
end

kps.rotations.register(
...
  {spells.chaosBolt, myCondition , "target"},
...
)
```
This would have the same effect as the string, but this should be avoided in most cases. The string will be compiled and doesn't need
to be parsed every time, so there is no speed benefit here to gain.

And finally you can also omit this parameter completely, if you want this spell to be case always (but you have to omit the target also!):
```
  {spells.incinerate},
```

*TARGET*
Just like the _CONDITION_, the _TARGET_ can either be a WoW Target String (e.g. `'target'` or `'focus'`).

But it can also be a function. This is pretty important if you have a healing rotation, e.g.:
```
    {spells.flashHeal, 'heal.defaultTank.hp < 0.4', kps.heal.defaultTank},
```


##### Cast Sequence
_Syntax:_
```
  {{SPELL, SPELL, SPELL,...}, CONDITION, TARGET}
```
This is basically the same as a simple cast, but instead of a single spell you supply a table of multiple spells.
If the condition is met, each spell will be cast in the give order at the given target.

##### Function
If you want, you can also supply a function instead of a table, this function must return a spell object and a target string:
```
local function mySpellFunction()
    if kps.env.player.soulShards >= 3 then
        return spells.chaosBolt, "target"
    end
end

kps.rotations.register(
...
  mySpellFunction,
...
)
```

While this might not be as useful on first sight - after all it could be written much easier, it can be used to trigger complex conditions like:
```
local burningRushLastMovement = 0
local function deactivateBurningRush()
    local player = kps.env.player
    if player.isMoving or not player.hasBuff(kps.spells.warlock.burningRush) then
        burningRushLastMovement = GetTime()
    else
        local nonMovingDuration = GetTime() - burningRushLastMovement
        if nonMovingDuration >= 1 then
            return "/cancelaura " .. kps.spells.warlock.burningRush
        end
    end
end

kps.rotations.register(
...
  deactivateBurningRush,
...
)
```

##### Macro
_Syntax:_
```
  {{"macro"}, CONDITION, MACRO_TEXT}
```
You can also run simple macro commands. You only have to set the first element to `{"macro"}` (all lowercase!).

The condition is the same as in _Simple Spell_ or _Cast Sequence_.

The *MACRO_TEXT* is a string containing your command, e.g.:`'/use Healthstone'`.

##### Nested Rotation Table
_Syntax:_
```
  {{"nested"}, CONDITION, { ... }}
```
You can also nest rotation tables, you only have to set the first element to `{"nested"}` (all lowercase!).

The condition is still the same as in _Simple Spell_, _Cast Sequence_ or _Macro_.

The third element is another Rotation Table which gets evaluated if the condition matches. This has two advantages, for once
it makes your conditions easier to read, as you don't have to repeat the common conditions and your rotation gets slightly faster.


#### Required Talents Table
If your rotation requires specific talents, you can use the optional fifth parameter of `kps.rotations.register(...)`.
This *must* be a Table with 7 elements (one for each talent row).
KPS will write a warning if the talent requirements are not met once per fight, but not more than once per minute.

Each element stands for one Talent Tier and should have numeric values between `-3` and `+3`:

 * If the value is `0` than this Tier doesn't have any requiremnts.
 * If the value is positive, this tier must have the given talent (e.g.: `1` = _first talent_).
 * If the value is negative, this tier must have any talent but not the given (e.g.: `-2` = _first or third talent_)

_Example:_
```
{3,0,0,-1,-2,1,2}
-- Tier   1: Third Talent must be selected
-- Tier 2/3: No Requirements
-- Tier   4: First or Second Talant must be selected
-- Tier   5: First or Thirst Talant must be selected
-- Tier   6: First Talent must be selected
-- Tier   7: Second Talent must be selected
```

### Custom Functions
In some cases you might need some custom functions, which are only relevant to a specific class. Those can be registered in the
environment and can be used within your conditions:
```
local burnPhase = false
function kps.env.mage.burnPhase()
    if not burnPhase then
        burnPhase = kps.env.player.timeInCombat < 5 or kps.spells.mage.evocation.cooldown < 2
    else
        burnPhase = kps.env.player.mana > 0.35
    end
    return burnPhase
end

kps.rotations.register(
...
    {spells.arcaneMissiles, 'burnPhase()', "target"  },
...
)
```

Don't forgot to actually call this function within your condition, a simple `'burnPhase'` would always yield `true`.

You can also use functions with parameters:
```
function kps.env.warlock.isHavocUnit(unit)
    if not UnitExists(unit) then  return false end
    if UnitIsUnit("target",unit) then return false end
    return true
end


kps.rotations.register(
...
    {spells.havoc, 'isHavocUnit("focus") and focus.isAttackable', "focus"  },
...
)
```



### Open Issues
 * `core/logger.lua:33` - Check if DEFAULT_CHAT_FRAME:AddMessage() has any significant advantages
 * `core/parser.lua:113` - syntax error in
 * `core/parser.lua:120` - Error Handling!
 * `gui/toggle.lua:75` - Right-Click Action
 * `libs/LibRangeCheck-2.0/LibRangeCheck-2.0.lua:31` - check if unit is valid, etc
 * `modules/unit/unit_casting.lua:88` - Blacklisted spells?




