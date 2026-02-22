# Ash & Oil — Development Roadmap

**Current Version:** v0.5 — Phase 5: Gear System & Card Art + Sprint 2 UX Overhaul
**Last Updated:** February 22, 2026
**Status:** Gear system live, card redesign complete (faction glyphs), full parchment & wax UI restyle, north/south combat layout

---

## ✅ COMPLETED PHASES

### Phase 1: Core Project Setup ✅
- [x] Godot 4.6 project initialization (GL Compatibility renderer)
- [x] Jolt Physics integration
- [x] 4 autoload singletons (GameState, SaveManager, MissionManager, CardManager)
- [x] Project structure (scripts/, data/, tests/, scenes/)

### Phase 2: Combat System ✅
- [x] Turn-based combat engine
- [x] Card effects system (attack, defense, support, reaction, area, evasion, effect)
- [x] Enemy AI (basic damage, poison, armor mechanics)
- [x] Player stats (HP 30, armor 0, stamina 3/turn)
- [x] Lieutenant system (HP 25, armor 2, loyalty-based squad management)
- [x] Victory/Defeat/Retreat outcomes with multipliers
- [x] Combat UI with card hand, log, status displays

### Phase 3: Hub System ✅
- [x] Main Menu (New Game / Continue / Dev Mode)
- [x] MainHub (central navigation hub)
- [x] Deck Builder (add/remove cards, min 10 / max 30)
- [x] Shop UI (6 random cards, gold-based purchasing)
- [x] Meter system (RENOWN, HEAT, PIETY, FAVOR, DEBT, DREAD)
- [x] Squad management (recruit up to 2 lieutenants, loyalty tracking)
- [x] Save/Load system (JSON persistence)

### Phase 4: Mission Integration & Polish ✅
- [x] Mission data system (M01-M20 main, S01-S15 side missions)
- [x] Mission completion rewards (gold, meter changes, loyalty shifts, hook creation)
- [x] Mission unlock chains (sequential M01→M02→..., conditional side unlocks)
- [x] Ending path system (Cult, State, Solo based on meter values)
- [x] Enemy templates (45+ named enemies with stats)
- [x] Card data (87+ cards across 3 factions, 7 types)
- [x] Lieutenant data (8 unique characters with traits, HP, cards)
- [x] MainHub UI refactor (improved layout, pills, status cards)
- [x] CombatUI enhancements (display improvements)
- [x] Headless test runner (RunTests.gd for CI)

### Phase 5: Gear System & Card Art ✅
- [x] Gear system design (24 pieces, 3 slots: weapon/armor/accessory, 3 rarities)
- [x] `data/gear.json` — all 24 gear pieces with stats, effects, faction synergies
- [x] `GameState.gd` — `equipped_gear` dict, `gear_inventory` array, equip/add functions
- [x] `CardManager.gd` — `gear_data` dict, `get_gear()` loader
- [x] MainHub gear loadout section — cycle ◀/▶ through owned gear per slot
- [x] Shop gear section — all 24 pieces listed by slot+rarity with BUY/OWNED buttons
- [x] DevMenu gear grants — Grant Common/Rare/Epic/All sets for testing
- [x] Free starting gear on New Game (Iron Gladius, Leather Vest, Iron Ring)
- [x] **Full parchment & wax UI restyle** — consistent palette across all screens
  - [x] Main.gd — stone bars, aged gold borders, 3 styled entry buttons
  - [x] MainHub.gd — gradient bg, styled mission cards, gear loadout
  - [x] CombatUI.gd — parchment combat panels, gold END TURN/RETREAT buttons
  - [x] ShopUI.gd — FORUM MARKET header, stone top bar, gold borders
- [x] **Card hover preview system** — 180×250 portrait panel (name, art, stats, effect)
  - [x] Faction-tinted art placeholder (AEGIS=blue, SPECTER=purple, ECLIPSE=amber)
  - [x] Small compact cards in hand (120×180), hover shows full portrait
- [x] **CardDisplay scene** — reusable card component with ornate bronze frame
  - [x] `assets/cards/frame_front.png` — ornate Roman-style card frame
  - [x] `assets/cards/frame_back.png` — eagle + "TACTICI LEGIONIS" back design
  - [x] `scenes/CardDisplay.tscn` — layered frame + portrait + stats panel
  - [x] `scripts/ui/CardDisplay.gd` — `set_card(id)`, `set_card_size()`, placeholder portraits
  - [x] Integrated into CombatUI hand display (add_child before set_card pattern)

### Phase 5b: Sprint 2 UX Overhaul ✅
- [x] **Landing page centering** — Fixed Main.gd VBox anchor (grow_direction_both, removed position hack)
- [x] **Combat north/south table layout** — Restructured CombatUI._build_ui():
  - [x] Enemy zone locked to north (140px fixed)
  - [x] Arena divider bar with turn counter ("══  ARENA  •  Turn X  ══")
  - [x] Empty battlefield center (SIZE_EXPAND_FILL) with arena floor zones
  - [x] Gold center dividing line + two-tone background (cooler enemy side, warmer player side)
  - [x] Status effect badge rows (☠ poison, ⚡ stun, 🛡 armor, 💚 regen, etc.)
  - [x] Player zone compact (72px, HP + stamina/mana pills)
  - [x] Player hand anchored to south (200px minimum)
  - [x] Combat log anchored bottom-left, action buttons anchored bottom-right
- [x] **Card face redesign** — Complete CardDisplay visual refresh:
  - [x] Faction glyph watermarks (Ω=AEGIS, ☽=SPECTER, ✦=ECLIPSE, ⚔=NEUTRAL)
  - [x] Faction-colored zone (top 58%, deep faction colors)
  - [x] Frame PNG overlay on top (no longer buried beneath stats panel)
  - [x] Name ribbon band (CLR_STONE background, CLR_ACCENT text)
  - [x] Cost badge (top-left corner, bold)
  - [x] Clean stats + effect area (bottom 40%)
  - [x] Drop shadow (5/8px offset, black 50%)
  - [x] Built entirely in _ready() — CardDisplay.tscn is now 5 lines (no parse errors)
- [x] **Card animation improvements** — Spring easing on fan tween (0.22s TRANS_SPRING, bouncy settle)

### Testing & CI ✅
- [x] TestBase framework (15+ assertion types)
- [x] Unit test suites (test_gamestate, test_cardmanager, test_missionmanager, test_savemanager, test_combat_logic, test_game_logic)
- [x] Integration tests (test_mission_flow, test_save_load)
- [x] 150+ total test assertions
- [x] GitHub Actions CI pipeline
  - [x] JSON data validation
  - [x] GDScript linting (gdtoolkit)
  - [x] Test suite structure validation
  - [x] Data cross-reference integrity checks
- [x] Dev Mode (quick nav, resource setters, mission jumpers, test runner)

---

## 📋 NEXT PHASES (Upcoming)

### Phase 6: Content & Balance Tuning
**Focus:** Balance missions, card costs, enemy encounters

- [ ] Mission difficulty scaling (Act 1 → Act 3)
- [ ] Enemy encounter rebalancing (damage, armor, HP per mission)
- [ ] Card cost balancing (verify power_index vs. cost correlation)
- [ ] Lieutenant ability cards (signature card effects per lieutenant)
- [ ] Starter deck optimization (current: 10–20 cards)
- [ ] Shop pricing adjustments (test economy flow)
- [ ] Gear stat application in combat (read `equipped_gear` on combat start)
- [ ] Gear drops on mission complete (rarity rates: 90% common, 9% rare, 1% epic)
- [ ] Character portrait art (save to `res://assets/characters/[hero_id].png`)
- [ ] Test suite stamina fix (tests expect stamina=3, actual is stamina=5)

### Phase 7: NPC Relationship System
**Focus:** Relationship tracking, loyalty-based story gates

- [ ] NPC data structure (Lanista, Varro, Rhesus, Iona, Moth)
- [ ] Relationship flags (favor, hostility, recruited)
- [ ] Loyalty thresholds (unlock side missions, change ending)
- [ ] NPC dialogue system (simple text-based branching)
- [ ] Faction alignment (Cult, State, Syndicate)
- [ ] Faction-locked missions (only accessible if aligned)

### Phase 8: Advanced Combat Features
**Focus:** New card mechanics, special effects, environmental factors

- [ ] Poison stacking mechanics refinement
- [ ] Reflect/retaliation system (Curse of Thorns interactions)
- [ ] Mana pool system (currently 0, expand for mana-cost cards)
- [ ] Team ability system (lieutenant + champion combo moves)
- [ ] Environmental hazards (mission-specific arena effects)
- [ ] Boss encounters (unique enemy AI with special moves)

### Phase 9: Story & Narrative
**Focus:** Story hooks, branching narrative, multiple endings

- [ ] Hook system (create story flags from missions)
- [ ] Scene system (text-based story beats between missions)
- [ ] Consequence tracking (decisions affecting future missions)
- [ ] Ending scenes (3+ unique endings based on path: Cult, State, Solo)
- [ ] Character arcs (5+ lieutenant-specific story branches)
- [ ] Journal system (track completed missions, story progression)

### Phase 10: Progression & Upgrades
**Focus:** Between-mission advancement, character upgrades

- [ ] Skill trees (upgradeable lieutenant abilities)
- [ ] Card unlocks (discover rarer cards through missions)
- [ ] Equipment system (armor, weapons, accessories)
- [ ] Gold sinks (lieutenant training, equipment upgrades)
- [ ] Prestige/New Game+ mode (carry over unlocks)

### Phase 11: Polish & Optimization
**Focus:** Visual polish, audio, performance

- [ ] Sound design (SFX for cards, combat, UI)
- [ ] Music system (dynamic tracks per location/mission)
- [ ] Animation tweens (card plays, damage numbers, transitions)
- [ ] Particle effects (special abilities, explosions)
- [ ] Mobile optimization (touch controls, responsive UI)
- [ ] Performance profiling (target 60 FPS, optimize draw calls)

### Phase 12: Accessibility & Localization
**Focus:** Accessibility features, multi-language support

- [ ] Font scaling options
- [ ] Colorblind modes (card faction indicators)
- [ ] Screen reader support (UI labels)
- [ ] Subtitle system (voice narration prep)
- [ ] Language pack system (EN, FR, ES, DE base)

### Phase 13: Launch Prep & Distribution
**Focus:** Release, packaging, documentation

- [ ] Final balance pass (playtest, adjust difficulty curves)
- [ ] Trailer/marketing assets
- [ ] Release notes & patch notes system
- [ ] Steam/itch.io submission prep
- [ ] Community documentation (wiki, FAQ)

---

## 🎯 Current Sprint (Sprint 2) — COMPLETE ✅

### Completed Objectives
1. **Gear system live** — ✅ COMPLETE (24 pieces, shop, DevMenu grants, equip UI)
2. **Card art system** — ✅ COMPLETE (ornate frame asset, CardDisplay redesign, hover preview)
3. **Full UI restyle** — ✅ COMPLETE (parchment & wax palette across all screens)
4. **Combat layout overhaul** — ✅ COMPLETE (north/south table, battlefield zone, status effects)

### Completed Tasks
- [x] Gear data + GameState integration
- [x] Shop gear section + DevMenu grants
- [x] Parchment & wax restyle (Main, MainHub, CombatUI, ShopUI)
- [x] CardDisplay scene with ornate frame and placeholder portraits
- [x] Card hover preview panel in CombatUI
- [x] Landing page header centering (Main.gd)
- [x] Combat north/south table layout (enemy north, player south, log/buttons anchored)
- [x] Card face redesign (faction glyphs, frame overlay, clean stats area)
- [x] Battlefield arena zone (floor + status effect badges)
- [x] Card animation enhancement (spring easing on fan tween)

### Next Phase (Phase 6: Content & Balance)
- [ ] Apply equipped gear bonuses to combat (HP, armor, damage)
- [ ] Mission gear drop rewards (rarity rates: 90% common, 9% rare, 1% epic)
- [ ] Dynamic mission enemies (read from missions.json instead of hardcoded)
- [ ] Card effect resolver (poison, stun, bleed, counter, heal)
- [ ] Character portrait art for heroes
- [ ] Fix test suite stamina expectations (3→5)

---

## 🔗 Key Dependencies

**Data files:** `data/cards.json`, `data/missions.json`, `data/lieutenants.json`, `data/enemy_templates.json`
- Must validate before any content changes
- CI automatically checks all cross-references

**Autoload singletons:** All 4 must be loaded before any scene runs
- GameState: Central state
- SaveManager: JSON persistence
- MissionManager: Mission lifecycle
- CardManager: All game data (cards, enemies, lieutenants)

**Test framework:** TestRunner.gd auto-discovers all test_*.gd files
- Must have 50+ test methods total
- All must extend TestBase
- CI enforces this before merge

---

## 📊 Metrics

| Metric | Current | Target |
|--------|---------|--------|
| Total Cards | 87 | 200+ |
| Missions (Main) | 20 | 30 |
| Missions (Side) | 15 | 50+ |
| Lieutenants | 8 | 12 |
| Unique Enemies | 45+ | 100+ |
| Test Coverage | 150+ assertions | 250+ |
| Acts | 4 (implied) | 5 |
| Endings | 3 planned | 5+ |

---

## 🚀 Release Milestones

- **v0.4** — Core gameplay complete, test infrastructure
- **v0.5** (Current) — Gear system, card art frame, full UI restyle
- **v0.6** — Phase 6 balance pass, gear in combat, portrait art, content tuning
- **v0.7** — Phase 7 NPC system, relationship tracking
- **v0.8** — Phase 8 advanced combat, special effects
- **v0.9** — Phase 9 story content, narrative branching
- **v1.0** — Phase 10 progression system, upgrades
- **v1.1** — Phase 11 polish, optimization, launch ready
- **v1.2+** — Post-launch content, DLC, community feedback iterations

---

## ⚠️ Known Issues & Technical Debt

- **Gear stats not applied to combat** — `equipped_gear` is set in MainHub but CombatUI._init_state() doesn't read bonuses yet (Phase 6 task)
- **No character portrait art** — CardDisplay uses faction glyphs as placeholder; ready to swap in real art when available
- **Mission enemies hardcoded** — CombatUI._init_state() uses hardcoded enemy list, missions.json "enemies" field unused (Phase 6 task)
- **Card effects not resolved** — Effect strings ("poison_1", "stun_2") display but don't execute (Phase 6 task)
- **Test suite stamina mismatch** — `test_combat_logic.gd` expects stamina=3, actual is stamina=5 (Phase 6 task)
- **CombatUI exceeds 1000 lines** — gdlint `max-file-lines` warning (non-blocking, refactor later)

---

## 👥 Team & Roles

- **Godot Development:** Claude Code (direct file editing)
- **Code Review/Integration:** GitHub Actions CI, branch protection
- **Testing:** Automated test suite + manual playtesting
- **Content Design:** Data file tuning (missions, cards, enemies, lieutenants)
