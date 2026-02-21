# RESOURCE SYSTEM DECISION NOTE
> **Date:** 2026-02-15
> **Status:** PINNED FOR FUTURE REVIEW
> **Decision:** Using SHARED resource pools for V1, may revisit for V2

---

## 🎯 CURRENT DESIGN (V1 Implementation)

### **Resource Model: SHARED POOLS**

**Stamina:**
- Single pool: 3 Stamina/turn (resets end of turn)
- Shared across Champion + 2 Lieutenants
- All units spend from same pool
- Cap: 6 Stamina/turn (with boosts)

**Mana:**
- Single pool: 0 start, +1/turn, +1/card played, +1 per 5 damage taken
- Persists between turns
- Shared across squad
- Cap: 12 Mana (15 with upgrades)

**Deck/Hand:**
- Shared deck (30 cards total)
- Shared hand (7 cards drawn/turn)
- You assign cards to specific units during play

---

## 🔄 ALTERNATIVE CONSIDERED: PER-UNIT RESOURCES

### **What This Would Look Like:**

**Each unit has independent pools:**
- Champion: 3 Stamina/turn, own Mana pool
- Lieutenant 1: 3 Stamina/turn, own Mana pool
- Lieutenant 2: 3 Stamina/turn, own Mana pool
- **Total: 9 Stamina/turn** (3 units × 3 each)

**Pros:**
- ✅ Units feel more independent
- ✅ Enables "Marcus exhausted, Livia fresh" asymmetry
- ✅ More tactical complexity

**Cons:**
- ❌ Requires redesigning locked resource system
- ❌ More UI complexity (track 3 Stamina pools, 3 Mana pools)
- ❌ Mana generation needs rework (per-unit or shared accumulation?)
- ❌ Lieutenant stat blocks need Stamina/Mana values added
- ❌ Harder to balance (more variables)

---

## 📊 WHY SHARED RESOURCES FOR V1

### **Evidence from Locked Systems:**

1. **Lieutenant stat blocks have NO resource values:**
   - Lieutenants have HP, Armor, Speed
   - NO Stamina or Mana stats defined
   - If per-unit, they would need these values

2. **Combat system uses singular language:**
   - "Gain 3 Stamina" (not "each unit gains")
   - "Total cap: 12 Mana" (player cap, not per-unit)

3. **Resource caps are player-level:**
   - "Cap per turn: 6 Stamina"
   - "Max Mana: 12"
   - No mention of per-unit caps

4. **Simpler implementation:**
   - Matches existing locked design
   - Less UI complexity
   - Easier to balance

---

## 🎮 HOW SHARED RESOURCES CREATE TACTICAL DEPTH

**Even with shared pools, lieutenants matter:**

### **Individual HP Pools:**
- Champion: 30 HP (AEGIS), 20 HP (ECLIPSE), 25 HP (SPECTER)
- Marcus: 25 HP (tank, survives longer)
- Livia: 20 HP (fragile, needs protection)

### **Unique Traits:**
- Marcus "Disciplined": +1 starting hand size (shared benefit)
- Livia "Blessed": +2 Mana start (shared pool bonus)
- Traits affect shared resources but create distinct playstyles

### **Card Synergies:**
- Shield Bash on Marcus (tank with high HP) vs Champion (faction synergy)
- Toxin Dart on Livia (SPECTER synergy) vs Marcus (no synergy)
- Tactical choice: Which unit plays which card?

### **Individual Injuries:**
- Units can sit out missions if Grave injury
- Lose trait bonuses when lieutenant is injured
- Death is permanent per-unit

---

## 🔮 FUTURE CONSIDERATION (V2 or Later)

### **When to Revisit Per-Unit Resources:**

**Triggers for reconsideration:**
1. **Player feedback:** "Lieutenants don't feel independent enough"
2. **Combat feels shallow:** Shared pool limits tactical decisions
3. **Expansion goals:** Want more complex squad management
4. **Balance stable:** V1 proven, can handle added complexity

### **What Would Need to Change:**

**Design Updates:**
- Add Stamina/Mana to lieutenant stat blocks
- Redefine resource generation rules
- Update resource caps (per-unit vs total)
- Redesign Mana accumulation (+1/card played per-unit or shared?)

**Implementation:**
- UI to track 3+ resource pools
- Balance pass on all cards (costs may need adjusting)
- Combat simulator update
- Tutorial explaining per-unit resources

**Estimated Effort:** 2-3 weeks of redesign + rebalancing

---

## ✅ V1 DECISION SUMMARY

**Going with SHARED resources because:**
1. Matches locked combat system design
2. Simpler to implement and balance
3. Still creates meaningful tactical choices
4. Can revisit for V2 if needed

**We are NOT locked into this forever:**
- V1 proves core loop works
- Gather player feedback
- V2 can add per-unit resources if beneficial
- Design space is preserved

---

## 📝 REMINDER FOR FUTURE

**User's Note:**
> "I'm okay with shared mana pool while we build, we can change it later if we want."

**Designer's Note:**
We discussed per-unit resources as an alternative. The current locked design uses shared pools, which is simpler and matches existing systems. If we want more lieutenant independence in V2, per-unit resources would be a good expansion feature.

**Key Question for V2:**
After V1 playtesting, ask: "Do players want lieutenants to feel more independent, or is shared pool + traits + individual HP enough differentiation?"

---

**END OF DECISION NOTE**

---

**Related Documents:**
- `COMBAT_SYSTEM_LOCKED_V1.md` (resource generation rules)
- `lieutenant_and_status_design.md` (lieutenant stat blocks, no Stamina/Mana)
- `GAME_CONCEPT_MASTER_REFERENCE.md` (updated with 1 Champion + 2 Lieutenants structure)
