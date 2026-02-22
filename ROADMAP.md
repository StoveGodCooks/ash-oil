# Ash & Oil — Development Roadmap

**Current Version:** v0.4 — Phase 4: Mission Integration & UI Polish
**Last Updated:** February 21, 2026
**Status:** Core gameplay loop complete, testing infrastructure in place

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

### Phase 5: Content & Balance Tuning
**Focus:** Balance missions, card costs, enemy encounters

- [ ] Mission difficulty scaling (Act 1 → Act 3)
- [ ] Enemy encounter rebalancing (damage, armor, HP per mission)
- [ ] Card cost balancing (verify power_index vs. cost correlation)
- [ ] Lieutenant ability cards (signature card effects per lieutenant)
- [ ] Starter deck optimization (current: 10–20 cards)
- [ ] Shop pricing adjustments (test economy flow)

### Phase 6: NPC Relationship System
**Focus:** Relationship tracking, loyalty-based story gates

- [ ] NPC data structure (Lanista, Varro, Rhesus, Iona, Moth)
- [ ] Relationship flags (favor, hostility, recruited)
- [ ] Loyalty thresholds (unlock side missions, change ending)
- [ ] NPC dialogue system (simple text-based branching)
- [ ] Faction alignment (Cult, State, Syndicate)
- [ ] Faction-locked missions (only accessible if aligned)

### Phase 7: Advanced Combat Features
**Focus:** New card mechanics, special effects, environmental factors

- [ ] Poison stacking mechanics refinement
- [ ] Reflect/retaliation system (Curse of Thorns interactions)
- [ ] Mana pool system (currently 0, expand for mana-cost cards)
- [ ] Team ability system (lieutenant + champion combo moves)
- [ ] Environmental hazards (mission-specific arena effects)
- [ ] Boss encounters (unique enemy AI with special moves)

### Phase 8: Story & Narrative
**Focus:** Story hooks, branching narrative, multiple endings

- [ ] Hook system (create story flags from missions)
- [ ] Scene system (text-based story beats between missions)
- [ ] Consequence tracking (decisions affecting future missions)
- [ ] Ending scenes (3+ unique endings based on path: Cult, State, Solo)
- [ ] Character arcs (5+ lieutenant-specific story branches)
- [ ] Journal system (track completed missions, story progression)

### Phase 9: Progression & Upgrades
**Focus:** Between-mission advancement, character upgrades

- [ ] Skill trees (upgradeable lieutenant abilities)
- [ ] Card unlocks (discover rarer cards through missions)
- [ ] Equipment system (armor, weapons, accessories)
- [ ] Gold sinks (lieutenant training, equipment upgrades)
- [ ] Prestige/New Game+ mode (carry over unlocks)

### Phase 10: Polish & Optimization
**Focus:** Visual polish, audio, performance

- [ ] Sound design (SFX for cards, combat, UI)
- [ ] Music system (dynamic tracks per location/mission)
- [ ] Animation tweens (card plays, damage numbers, transitions)
- [ ] Particle effects (special abilities, explosions)
- [ ] Mobile optimization (touch controls, responsive UI)
- [ ] Performance profiling (target 60 FPS, optimize draw calls)

### Phase 11: Accessibility & Localization
**Focus:** Accessibility features, multi-language support

- [ ] Font scaling options
- [ ] Colorblind modes (card faction indicators)
- [ ] Screen reader support (UI labels)
- [ ] Subtitle system (voice narration prep)
- [ ] Language pack system (EN, FR, ES, DE base)

### Phase 12: Launch Prep & Distribution
**Focus:** Release, packaging, documentation

- [ ] Final balance pass (playtest, adjust difficulty curves)
- [ ] Trailer/marketing assets
- [ ] Release notes & patch notes system
- [ ] Steam/itch.io submission prep
- [ ] Community documentation (wiki, FAQ)

---

## 🎯 Current Sprint (Sprint 1)

### Objectives
1. **Validate current state** — All tests pass, CI green
2. **Branch cleanup** — ✅ COMPLETE (removed master, Codex branches)
3. **Documentation** — ✅ COMPLETE (PROJECT_AUDIT.md, memory files)
4. **Ready for PRs** — Establish workflow for main → staged → release
5. **Prepare Phase 5** — Identify balance issues, create tuning tasks

### Tasks
- [ ] Run full test suite (local + GitHub Actions)
- [ ] Verify all JSON data integrity
- [ ] Get approval on roadmap priorities
- [ ] Create Phase 5 task board
- [ ] Tag v0.4 release

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

- **v0.4** (Current) — Core gameplay complete, test infrastructure
- **v0.5** — Phase 5 balance pass, content tuning
- **v0.6** — Phase 6 NPC system, relationship tracking
- **v0.7** — Phase 7 advanced combat, special effects
- **v0.8** — Phase 8 story content, narrative branching
- **v0.9** — Phase 9 progression system, upgrades
- **v1.0** — Phase 10 polish, optimization, launch ready
- **v1.1+** — Post-launch content, DLC, community feedback iterations

---

## ⚠️ Known Issues & Technical Debt

- None currently documented. Add findings from playtesting and balance passes.

---

## 👥 Team & Roles

- **Godot Development:** Claude Code (direct file editing)
- **Code Review/Integration:** GitHub Actions CI, branch protection
- **Testing:** Automated test suite + manual playtesting
- **Content Design:** Data file tuning (missions, cards, enemies, lieutenants)
