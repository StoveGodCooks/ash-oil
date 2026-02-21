# ECONOMY & SHOP SYSTEM - COMPLETE DESIGN
> **Version:** V1 - Production Ready
> **Design Philosophy:** Player is slightly gold-starved, choices matter, no grinding required
> **Balance Target:** ~1500 gold earned across full campaign, ~1800 gold total spending available

---

## CORE ECONOMIC PRINCIPLES

### 1. Scarcity Creates Choices
- Player cannot afford everything
- Must prioritize: healing vs upgrades vs gear vs cards
- Early game: tight economy (forces careful play)
- Late game: more generous (enables build completion)

### 2. No Grinding Required
- Fixed mission count (~15 main missions)
- Linear progression (can't replay missions for gold farming)
- Economy balanced for single playthrough
- Gold comes from mission rewards, not grinding

### 3. Multiple Spending Paths
Players spend gold on:
- **Healing:** Treat injuries between missions
- **Gear:** Purchase missing gear pieces
- **Cards:** Buy specific cards from shop
- **Upgrades:** Upgrade cards permanently
- **Services:** Cleanse, remove cards, rest units

### 4. RNG Mitigation
- Bad gear drops? Buy from shop
- Bad card unlocks? Purchase from shop
- Shop rerolls available for small fee

---

## GOLD INCOME (BY SOURCE)

### Mission Completion Rewards

#### Act 1 (Missions 1-5):
```
Mission 1 (Tutorial): 40 gold
Mission 2: 60 gold
Mission 3: 70 gold
Mission 4: 80 gold
Mission 5 (Boss): 100 gold

Act 1 Total: 350 gold
```

#### Act 2 (Missions 6-10):
```
Mission 6: 100 gold
Mission 7: 110 gold
Mission 8: 120 gold
Mission 9: 130 gold
Mission 10 (Boss): 150 gold

Act 2 Total: 610 gold
```

#### Act 3 (Missions 11-15):
```
Mission 11: 140 gold
Mission 12: 150 gold
Mission 13: 160 gold
Mission 14: 170 gold
Mission 15 (Final Boss): 200 gold

Act 3 Total: 820 gold
```

**Total Campaign Income:** 1,780 gold

---

### Wave Completion Bonuses

Each expedition has 6 waves. Small bonus per wave cleared:

```
Wave 1: +5 gold
Wave 2: +5 gold
Wave 3: +8 gold
Wave 4: +8 gold
Wave 5: +10 gold
Wave 6 (Boss): +15 gold

Per Mission: +51 gold
x15 missions = +765 gold
```

**Total from Wave Bonuses:** 765 gold

---

### Enemy Kills (Loot Drops)

Based on enemy design:
```
Common enemies: 10-15 gold each
Tactical enemies: 20-30 gold each
Elite enemies: 40-60 gold each
Bosses: 60-100 gold each

Average per mission: ~80 gold from kills
x15 missions = 1,200 gold
```

**Total from Enemy Loot:** 1,200 gold

---

### TOTAL GOLD INCOME (Full Campaign)

```
Mission Completion: 1,780 gold
Wave Bonuses: 765 gold
Enemy Loot: 1,200 gold

TOTAL EARNED: 3,745 gold
```

**This is your economic ceiling.**

---

## GOLD EXPENDITURE (SINKS)

### 1. Healing Services (Hub - Doctor)

#### Minor Injury Healing:
```
Triage (Natural Healing - Free):
- Cost: 0 gold
- Effect: Unit sits out 1 mission, injury heals after
- Use Case: When you have spare roster slots

Standard Treatment:
- Cost: 30 gold
- Effect: Instant heal, unit ready immediately
- Use Case: Need unit for next mission

Expected Usage: ~10 minor injuries across campaign
Average Spend: ~200 gold (if paying for instant healing)
```

#### Serious Injury Healing:
```
Field Surgery:
- Cost: 80 gold
- Effect: Reduces Serious → Minor (still needs 1 more treatment)
- Use Case: Emergency downgrade

Full Treatment:
- Cost: 150 gold
- Effect: Instant full heal
- Use Case: Critical unit, urgent need

Expected Usage: ~3-5 serious injuries across campaign
Average Spend: ~300-450 gold
```

#### Grave Injury / Permanent Scars:
```
Advanced Restoration:
- Cost: 300 gold
- Effect: Remove permanent scar (risky procedure)
- Success Rate: 70% (30% chance scar remains)
- Use Case: Endgame only, fix veteran units

Expected Usage: 0-2 across campaign
Average Spend: 0-600 gold (if unlucky)
```

**Total Healing Budget:** 500-1,250 gold (depends on player skill)

---

### 2. Gear Purchases (Hub - Market)

#### Common Gear:
```
Weapons: 80 gold
Armors: 80 gold
Accessories: 60 gold

Use Case: Fill gaps in early game RNG drops
Expected Purchases: 2-3 pieces
Average Spend: ~200 gold
```

#### Rare Gear:
```
Weapons: 300 gold
Armors: 300 gold
Accessories: 250 gold

Use Case: Enable specific builds mid-game
Expected Purchases: 1-2 pieces
Average Spend: ~300-600 gold
```

#### Epic Gear:
```
Weapons: 1,000 gold
Armors: 1,200 gold
Accessories: 900 gold

Use Case: Build-defining pieces if boss RNG fails
Expected Purchases: 0-1 piece (bosses usually drop these)
Average Spend: 0-1,000 gold
```

**Total Gear Budget:** 500-1,800 gold (varies wildly by RNG)

---

### 3. Card Purchases (Hub - Card Vendor)

#### Shop Inventory (Refreshes Each Visit):
```
3 cards available:
- 1 Common card: 50 gold
- 1 Rare card: 150 gold
- 1 Epic card: 400 gold (unlocks Act 3)

Refresh Shop:
- Cost: 25 gold
- Effect: Reroll all 3 cards
- Use Case: Looking for specific card
```

**Expected Card Purchases:**
```
Act 1: 1-2 Common cards = 50-100 gold
Act 2: 1-2 Rare cards = 150-300 gold
Act 3: 0-1 Epic card = 0-400 gold (usually unlocked via level-up)

Total: 200-800 gold
```

---

### 4. Card Upgrades (Hub - Card Shrine)

#### Upgrade Costs (Per Card):
```
Common card upgrade: 50 gold
Rare card upgrade: 100 gold
Epic card upgrade: 200 gold
Ultimate card upgrade: 300 gold
```

#### Upgrade Effects:
```
Typical upgrade paths:

Shield Bash → Shield Bash+
- Cost: 50 gold
- Before: Deal 5 damage, Gain 3 Armor (1 Stamina)
- After: Deal 6 damage, Gain 4 Armor (1 Stamina)

Slash → Slash+
- Cost: 50 gold
- Before: Deal 6 damage, Apply Bleeding 1 (1 Stamina)
- After: Deal 8 damage, Apply Bleeding 2 (1 Stamina)

Phalanx → Phalanx+
- Cost: 200 gold
- Before: Gain 15 Armor, Draw 2, Weakened 4 (4 Stamina)
- After: Gain 18 Armor, Draw 2, Weakened 5 (3 Stamina)
```

**Expected Upgrade Spending:**
```
Early game: Upgrade 2-3 starter cards = 100-150 gold
Mid game: Upgrade 2-3 core cards = 150-300 gold
Late game: Upgrade 1-2 finishers = 200-400 gold

Total: 450-850 gold
```

---

### 5. Utility Services (Hub)

#### Card Removal Service:
```
Cost: 50 gold per card
Effect: Permanently remove card from deck (deck thinning)
Use Case: Remove starter cards, optimize deck

Expected Usage: 3-5 removals
Total: 150-250 gold
```

#### Cleanse Status Service:
```
Cost: 20 gold
Effect: Remove all status effects from all units
Use Case: Pre-mission prep if entering with DoTs

Expected Usage: 2-4 times
Total: 40-80 gold
```

#### Rest & Recovery (Stress Relief - Story System):
```
Cost: Free (but costs time)
Effect: -3 Stress per unit, minor HP restoration
Penalty: Skip 1 contract opportunity

Use Case: Manage companion stress levels
Expected Usage: Situational (story-driven)
```

---

### TOTAL EXPENDITURE BUDGET

```
ESSENTIAL SPENDING:
- Healing (skill-dependent): 500-1,250 gold
- Total: 500-1,250 gold

OPTIONAL SPENDING (Choose Wisely):
- Gear purchases: 500-1,800 gold
- Card purchases: 200-800 gold
- Card upgrades: 450-850 gold
- Card removal: 150-250 gold
- Utility services: 40-80 gold

TOTAL AVAILABLE SINKS: 2,340-5,030 gold
```

**Player earns: 3,745 gold**
**Player can spend: Up to 5,030 gold (if they want everything)**

**DEFICIT: ~1,285 gold** → **Player must make choices!**

---

## ECONOMIC BALANCE VALIDATION

### Early Game (Missions 1-5):
```
Income: 350 (missions) + 255 (waves) + 400 (kills) = 1,005 gold
Expected Spending: 200-400 gold (minor healing, 1-2 Common gear, 1-2 card upgrades)

Result: Player accumulates 600-800 gold buffer
Strategy: Conservative spending, build foundation
```

### Mid Game (Missions 6-10):
```
Income: 610 (missions) + 255 (waves) + 400 (kills) = 1,265 gold
Expected Spending: 400-800 gold (Rare gear, card upgrades, healing)

Result: Player spends most income, buffer holds ~600 gold
Strategy: Build-enabling purchases, prioritize synergies
```

### Late Game (Missions 11-15):
```
Income: 820 (missions) + 255 (waves) + 400 (kills) = 1,475 gold
Expected Spending: 600-1,200 gold (Epic gear if needed, final upgrades, serious injury healing)

Result: Player finishes campaign with 500-1,000 gold surplus
Strategy: Complete build, prepare for finale
```

---

## SHOP MECHANICS

### 1. Card Vendor (Hub)

**Inventory Generation:**
```javascript
function generateCardShop(playerLevel, actNumber) {
  const shop = []
  
  // Slot 1: Common card (always available)
  const commonPool = getAllCommonCards(playerLevel)
  shop.push({
    card: randomFrom(commonPool),
    price: 50,
    rarity: 'Common'
  })
  
  // Slot 2: Rare card (Act 2+)
  if (actNumber >= 2) {
    const rarePool = getAllRareCards(playerLevel)
    shop.push({
      card: randomFrom(rarePool),
      price: 150,
      rarity: 'Rare'
    })
  }
  
  // Slot 3: Epic card (Act 3 only)
  if (actNumber >= 3) {
    const epicPool = getAllEpicCards(playerLevel)
    shop.push({
      card: randomFrom(epicPool),
      price: 400,
      rarity: 'Epic'
    })
  }
  
  return shop
}
```

**Refresh Mechanic:**
```
Cost: 25 gold
Effect: Reroll all shop slots (new cards)
Limit: Unlimited refreshes (but costs add up)
Strategy: Fishing for specific card costs 50-100 gold on average
```

---

### 2. Market (Gear Vendor)

**Inventory Generation:**
```javascript
function generateMarket(actNumber) {
  const market = []
  
  // Always show 2 Common pieces
  market.push(randomCommonWeapon(), randomCommonArmor())
  
  // Act 2+: Add 1 Rare piece
  if (actNumber >= 2) {
    market.push(randomRarePiece())
  }
  
  // Act 3: Add 1 Epic piece
  if (actNumber >= 3) {
    market.push(randomEpicPiece())
  }
  
  return market
}
```

**Pricing:**
```
Common: 60-80 gold (avg 70)
Rare: 250-350 gold (avg 300)
Epic: 900-1,200 gold (avg 1,050)
```

**No Refresh:** Market inventory changes only after completing a mission

---

### 3. Doctor (Healing Services)

**Always Available:**
```
Triage (Free): Natural healing, 1 mission wait
Standard Treatment (30g): Instant minor injury heal
Field Surgery (80g): Serious → Minor
Full Treatment (150g): Serious → Healed
Advanced Restoration (300g): Remove Permanent Scar (70% success)
```

**Unlock Progression:**
```
Level 1-5: Only Triage + Standard Treatment available
Level 6-10: Field Surgery unlocks
Level 11+: Full Treatment + Advanced Restoration unlock
```

---

### 4. Card Shrine (Upgrade Services)

**Always Available (Post-Mission 3):**
```
Select card from deck → Pay gold → Card permanently upgraded

Upgrade costs scale by rarity:
- Common: 50 gold
- Rare: 100 gold
- Epic: 200 gold
- Ultimate: 300 gold
```

**Upgrade Benefits:**
```
Typical upgrades:
- +1-2 damage
- +1-2 Armor
- +1 status effect stack
- -1 Stamina cost (for expensive cards)
- Draw +1 card (added effect)

Upgrades apply to ALL copies in deck
Can upgrade same card multiple times (+ → ++ → +++)
```

---

## UNLOCK PROGRESSION (WHAT UNLOCKS WHEN)

### Level-Based Unlocks:

**Level 1 (Start):**
- Triage healing (free)
- Standard Treatment (30g)
- Market (Common gear only)

**Level 3:**
- Card Shrine unlocks (upgrade cards)
- Card Vendor unlocks (buy cards)

**Level 5:**
- Card Removal service (50g)

**Level 6:**
- Market expands (Rare gear available)
- Field Surgery (80g)

**Level 10:**
- Full Treatment (150g)

**Level 11:**
- Market expands (Epic gear available)
- Advanced Restoration (300g)

---

### Act-Based Unlocks:

**Act 1 (Missions 1-5):**
- Card Vendor: Common cards only (50g)
- Market: Common gear only (60-80g)

**Act 2 (Missions 6-10):**
- Card Vendor: Common + Rare cards (50g, 150g)
- Market: Common + Rare gear (60-350g)

**Act 3 (Missions 11-15):**
- Card Vendor: Common + Rare + Epic cards (50g, 150g, 400g)
- Market: Common + Rare + Epic gear (60-1,200g)

---

## GOLD REWARDS BY MISSION (COMPLETE TABLE)

| Mission | Completion | Waves | Kills | Total |
|---------|-----------|-------|-------|-------|
| 1 (Tutorial) | 40 | 30 | 30 | 100 |
| 2 | 60 | 51 | 60 | 171 |
| 3 | 70 | 51 | 70 | 191 |
| 4 | 80 | 51 | 80 | 211 |
| 5 (Boss) | 100 | 51 | 120 | 271 |
| **Act 1 Total** | **350** | **234** | **360** | **944** |
| 6 | 100 | 51 | 90 | 241 |
| 7 | 110 | 51 | 90 | 251 |
| 8 | 120 | 51 | 90 | 261 |
| 9 | 130 | 51 | 90 | 271 |
| 10 (Boss) | 150 | 51 | 150 | 351 |
| **Act 2 Total** | **610** | **255** | **510** | **1,375** |
| 11 | 140 | 51 | 100 | 291 |
| 12 | 150 | 51 | 100 | 301 |
| 13 | 160 | 51 | 100 | 311 |
| 14 | 170 | 51 | 100 | 321 |
| 15 (Final) | 200 | 51 | 130 | 381 |
| **Act 3 Total** | **820** | **255** | **530** | **1,605** |
| **CAMPAIGN TOTAL** | **1,780** | **744** | **1,400** | **3,924** |

**Updated Total Income: 3,924 gold**

---

## PRICING PHILOSOPHY

### Why These Prices?

**Healing Costs (30-300g):**
- Early injuries cheap (30g) → encourages not letting units sit out
- Serious injuries expensive (150g) → penalty for poor play
- Permanent scars very expensive (300g) → rare, endgame only

**Gear Costs (60-1,200g):**
- Commons cheap (60-80g) → accessible even if RNG fails
- Rares moderate (250-350g) → significant investment
- Epics expensive (900-1,200g) → usually obtained via boss drops, shop is backup

**Card Costs (50-400g):**
- Commons cheap (50g) → deck filler accessible
- Rares moderate (150g) → build-enabling
- Epics expensive (400g) → usually unlocked via level-up, shop is backup

**Upgrade Costs (50-300g):**
- Tied to rarity (50/100/200/300)
- Upgrading full deck = 500-1,000g investment
- Forces prioritization (upgrade 5-6 core cards, not all 20)

---

## PLAYER SPENDING ARCHETYPES

### "Safe Player" (Conservative):
```
Priorities:
1. Healing (500g) - Never let injuries escalate
2. Card upgrades (300g) - Upgrade 3-4 core cards
3. 1 Rare gear purchase (300g) - Fill critical gap

Total: ~1,100 gold
Surplus: ~2,800 gold (unspent, could've done more)
```

### "Optimized Player" (Balanced):
```
Priorities:
1. Selective healing (300g) - Use free Triage when possible
2. Card upgrades (600g) - Upgrade 6-7 key cards
3. 2 Rare gear purchases (600g) - Complete build
4. Card removal (150g) - Thin deck

Total: ~1,650 gold
Surplus: ~2,300 gold (efficient spending)
```

### "Aggressive Player" (Risk-Taker):
```
Priorities:
1. Minimal healing (200g) - Only emergencies, accepts injuries
2. Heavy upgrades (850g) - Upgrade 8-10 cards
3. Epic gear purchase (1,000g) - Chase build-defining piece
4. Card purchases (300g) - Buy specific cards

Total: ~2,350 gold
Surplus: ~1,600 gold (ambitious build completion)
```

### "Unlucky Player" (RNG Victim):
```
Forced Spending:
1. Heavy healing (1,000g) - Multiple serious injuries
2. Gear purchases (1,500g) - Bad boss RNG, must buy gear
3. Minimal upgrades (200g) - Can't afford more

Total: ~2,700 gold
Surplus: ~1,200 gold (tight budget, limited build options)
```

---

## ECONOMIC DIFFICULTY MODIFIERS (Optional V2)

### Easy Mode:
- +50% gold rewards
- Healing costs -50%
- More forgiving economy

### Normal Mode:
- Default values (as designed above)

### Hard Mode:
- -25% gold rewards
- Healing costs +50%
- Forces perfect play, no waste

---

## INTEGRATION WITH OTHER SYSTEMS

### Story/Companion System:
```javascript
// Debt system affects economy
if (campaign.debt.gold > 0) {
  // Gold rewards reduced by debt amount
  missionReward -= min(missionReward * 0.3, campaign.debt.gold)
  campaign.debt.gold -= deduction
}

// Blood Debt creates forced spending
if (campaign.debt.blood > 0) {
  // Must pay "blood price" (HP sacrifice) or gold premium
  doctorCost *= 1.5 // 50% markup if in debt
}
```

### Contract Board System:
```javascript
// Economy contracts offer gold relief
const economyContracts = [
  {
    type: 'Supply Convoy',
    reward: { gold: 200 },
    risk: 'Medium combat'
  },
  {
    type: 'High-Risk Bounty',
    reward: { gold: 350 },
    risk: 'High injury risk'
  },
  {
    type: 'Debt Relief',
    reward: { debtReduction: 100 },
    risk: 'Rival presence'
  }
]
```

---

## TESTING CHECKLIST

### Economic Balance Validation:

- [ ] Can player afford essential healing? (Yes, 500-1,250g available)
- [ ] Can player complete a build? (Yes, ~1,500g for gear + upgrades)
- [ ] Is player forced to grind? (No, fixed mission count)
- [ ] Does RNG screw over players? (No, shop provides backup)
- [ ] Do choices matter? (Yes, can't afford everything)
- [ ] Can skilled players hoard gold? (Yes, ~2,000g surplus if perfect)
- [ ] Can unskilled players recover? (Yes, but tight budget ~1,200g surplus)

---

**STATUS: ✅ LOCKED - READY FOR IMPLEMENTATION**

**Next Step:** Create UI/UX Mockups (screen layouts) OR Start Coding
**After That:** Build economy simulator to validate balance
**Then:** Playtest full economic loop

---

**Complete economy system designed!**
**Total Income:** 3,924 gold across 15 missions
**Total Sinks:** 2,340-5,030 gold (player chooses wisely)
**Balance:** Player must prioritize, no grinding, choices matter
