"""
Ash & Oil — Data Integrity Validator
Runs in Python (no Godot required). Used by GitHub Actions CI and locally.

Usage:
    python tests/validate_data.py
"""

import json
import sys
import os

# ── Paths ──────────────────────────────────────────────────────────────────
ROOT = os.path.join(os.path.dirname(__file__), "..")
CARDS_PATH       = os.path.join(ROOT, "data", "cards.json")
MISSIONS_PATH    = os.path.join(ROOT, "data", "missions.json")
ENEMIES_PATH     = os.path.join(ROOT, "data", "enemy_templates.json")
LIEUTENANTS_PATH = os.path.join(ROOT, "data", "lieutenants.json")

STARTER_DECK = [
    "card_027", "card_027", "card_027", "card_027",
    "card_001", "card_001", "card_001", "card_001",
    "card_028", "card_028", "card_028",
    "card_002", "card_002", "card_002",
    "card_029", "card_029", "card_029",
    "card_033", "card_033",
]

VALID_METERS      = {"RENOWN", "HEAT", "PIETY", "FAVOR", "DEBT", "DREAD"}
VALID_CARD_TYPES  = {"attack", "defense", "support", "reaction", "area", "evasion", "effect"}
VALID_FACTIONS    = {"AEGIS", "SPECTER", "ECLIPSE", "NEUTRAL"}
VALID_ENEMY_TYPES = {"grunt", "elite", "champion", "boss"}
VALID_LIEUTENANTS = {"Marcus", "Livia", "Titus", "Kara", "Decimus", "Julia", "Corvus", "Thane"}

# ── Helpers ────────────────────────────────────────────────────────────────
errors   = []
warnings = []
passed   = 0

def ok(msg):
    global passed
    passed += 1
    print(f"  [PASS] {msg}")

def fail(msg):
    errors.append(msg)
    print(f"  [FAIL] {msg}")

def warn(msg):
    warnings.append(msg)
    print(f"  [WARN] {msg}")

def load_json(path):
    label = os.path.relpath(path, ROOT)
    if not os.path.exists(path):
        fail(f"File not found: {label}")
        return None
    with open(path, "r", encoding="utf-8") as f:
        try:
            data = json.load(f)
            ok(f"{label} — valid JSON ({len(data)} entries)")
            return data
        except json.JSONDecodeError as e:
            fail(f"{label} — JSON parse error: {e}")
            return None

# ── Tests ──────────────────────────────────────────────────────────────────

def test_cards(cards):
    print("\n[cards.json]")
    required = ["id", "name", "cost", "type", "faction", "is_signature", "power_index", "effect"]
    missing_fields = []
    bad_types      = []
    bad_factions   = []

    for cid, card in cards.items():
        for field in required:
            if field not in card:
                missing_fields.append(f"{cid} missing '{field}'")
        if card.get("type") not in VALID_CARD_TYPES:
            bad_types.append(f"{cid}: type='{card.get('type')}'")
        if card.get("faction") not in VALID_FACTIONS:
            bad_factions.append(f"{cid}: faction='{card.get('faction')}'")
        cost = card.get("cost", -1)
        if not isinstance(cost, int) or cost < 0:
            fail(f"{cid}: cost must be int >= 0, got {cost!r}")

    if missing_fields:
        for m in missing_fields: fail(f"Missing field — {m}")
    else:
        ok(f"All {len(cards)} cards have required fields")

    if bad_types:
        for b in bad_types: fail(f"Invalid type — {b}")
    else:
        ok(f"All card types are valid ({', '.join(VALID_CARD_TYPES)})")

    if bad_factions:
        for b in bad_factions: fail(f"Invalid faction — {b}")
    else:
        ok(f"All card factions are valid ({', '.join(VALID_FACTIONS)})")

    # Check signature cards reference valid lieutenants
    for cid, card in cards.items():
        if card.get("is_signature"):
            lt = card.get("signature_lt", "")
            if lt and lt not in VALID_LIEUTENANTS:
                warn(f"{cid} signature_lt '{lt}' not in lieutenant roster")


def test_starter_deck(cards):
    print("\n[Starter Deck]")
    bad = [cid for cid in STARTER_DECK if cid not in cards]
    if bad:
        for b in set(bad): fail(f"Starter deck card not found: {b}")
    else:
        ok(f"All {len(STARTER_DECK)} starter deck entries exist in cards.json")
    if len(STARTER_DECK) < 10:
        fail(f"Starter deck too small: {len(STARTER_DECK)} cards (min 10)")
    elif len(STARTER_DECK) > 30:
        fail(f"Starter deck too large: {len(STARTER_DECK)} cards (max 30)")
    else:
        ok(f"Starter deck size valid: {len(STARTER_DECK)} cards")


def test_enemy_templates(enemies):
    print("\n[enemy_templates.json]")
    required = ["id", "name", "hp", "max_hp", "armor", "damage", "poison", "type"]
    bad_types = []
    missing   = []

    for eid, enemy in enemies.items():
        for field in required:
            if field not in enemy:
                missing.append(f"{eid} missing '{field}'")
        if enemy.get("type") not in VALID_ENEMY_TYPES:
            bad_types.append(f"{eid}: type='{enemy.get('type')}'")
        if enemy.get("hp", 0) != enemy.get("max_hp", -1):
            warn(f"{eid}: hp ({enemy.get('hp')}) != max_hp ({enemy.get('max_hp')}) at template definition")
        for stat in ["hp", "max_hp", "armor", "damage", "poison"]:
            v = enemy.get(stat, -1)
            if not isinstance(v, (int, float)) or v < 0:
                fail(f"{eid}: {stat} must be >= 0, got {v!r}")

    if missing:
        for m in missing: fail(f"Missing field — {m}")
    else:
        ok(f"All {len(enemies)} enemy templates have required fields")

    if bad_types:
        for b in bad_types: fail(f"Invalid enemy type — {b}")
    else:
        ok(f"All enemy types are valid ({', '.join(VALID_ENEMY_TYPES)})")


def test_missions(missions, enemies, cards):
    print("\n[missions.json]")
    required = ["id", "name", "type", "act", "description", "location",
                "enemies", "meter_changes", "victory_rewards", "retreat_rewards"]
    missing_fields    = []
    bad_enemy_refs    = []
    bad_meter_refs    = []
    bad_mission_types = []

    for mid, mission in missions.items():
        for field in required:
            if field not in mission:
                missing_fields.append(f"{mid} missing '{field}'")

        # Validate enemy refs
        for eid in mission.get("enemies", []):
            if enemies and eid not in enemies:
                bad_enemy_refs.append(f"{mid} → enemy '{eid}' not in enemy_templates.json")

        # Validate meter names
        for meter in mission.get("meter_changes", {}):
            if meter not in VALID_METERS:
                bad_meter_refs.append(f"{mid} → meter '{meter}' invalid")

        # Validate relationship names
        for lt in mission.get("relationships", {}):
            if lt not in VALID_LIEUTENANTS:
                warn(f"{mid} → relationship '{lt}' not in lieutenant roster")

        # Validate rewards have gold field
        for reward_key in ["victory_rewards", "retreat_rewards"]:
            r = mission.get(reward_key, {})
            if "gold" not in r:
                warn(f"{mid}.{reward_key} has no 'gold' field")

        mtype = mission.get("type")
        if mtype not in ("main", "side"):
            bad_mission_types.append(f"{mid}: type='{mtype}'")

    if missing_fields:
        for m in missing_fields: fail(f"Missing field — {m}")
    else:
        ok(f"All {len(missions)} missions have required fields")

    if bad_enemy_refs:
        for b in bad_enemy_refs: fail(b)
    else:
        ok("All mission enemy references exist in enemy_templates.json")

    if bad_meter_refs:
        for b in bad_meter_refs: fail(b)
    else:
        ok(f"All meter names in missions are valid")

    if bad_mission_types:
        for b in bad_mission_types: fail(b)
    else:
        ok("All mission types are 'main' or 'side'")

    # Check unlock chain: M01 should exist, M02 should exist, etc.
    main_missions = sorted([mid for mid in missions if mid.startswith("M")])
    if "M01" not in missions:
        fail("M01 not found — required starting mission")
    else:
        ok("M01 exists (required starting mission)")

    if len(main_missions) >= 10:
        ok(f"{len(main_missions)} main missions defined")
    else:
        warn(f"Only {len(main_missions)} main missions — target is 30")


def test_lieutenants(lieutenants, cards):
    print("\n[lieutenants.json]")
    required = ["name", "trait", "trait_desc", "hp", "armor", "speed", "cards", "unlock_mission"]
    missing  = []
    bad_cards = []

    for lt_name, lt in lieutenants.items():
        for field in required:
            if field not in lt:
                missing.append(f"{lt_name} missing '{field}'")
        for cid in lt.get("cards", []):
            if cards and cid not in cards:
                bad_cards.append(f"{lt_name} → card '{cid}' not in cards.json")

    if missing:
        for m in missing: fail(f"Missing field — {m}")
    else:
        ok(f"All {len(lieutenants)} lieutenants have required fields")

    if bad_cards:
        for b in bad_cards: fail(b)
    else:
        ok("All lieutenant card references exist in cards.json")

    expected = list(VALID_LIEUTENANTS)
    for lt_name in expected:
        if lt_name not in lieutenants:
            warn(f"Expected lieutenant '{lt_name}' not found in lieutenants.json")

    ok(f"{len(lieutenants)} lieutenants defined (expected 8)")


# ── Main ───────────────────────────────────────────────────────────────────
if __name__ == "__main__":
    print("=" * 60)
    print("  ASH & OIL - DATA VALIDATION SUITE")
    print("=" * 60)

    cards       = load_json(CARDS_PATH)
    enemies     = load_json(ENEMIES_PATH)
    missions    = load_json(MISSIONS_PATH)
    lieutenants = load_json(LIEUTENANTS_PATH)

    if cards:       test_cards(cards)
    if cards:       test_starter_deck(cards)
    if enemies:     test_enemy_templates(enemies)
    if missions:    test_missions(missions, enemies, cards)
    if lieutenants: test_lieutenants(lieutenants, cards)

    print("\n" + "=" * 60)
    print(f"  RESULTS: {passed} passed | {len(warnings)} warnings | {len(errors)} errors")
    print("=" * 60)

    if warnings:
        print("\nWarnings:")
        for w in warnings:
            print(f"  [WARN] {w}")

    if errors:
        print("\nFailed checks:")
        for e in errors:
            print(f"  [FAIL] {e}")
        sys.exit(1)
    else:
        print("\n[PASS] All checks passed!")
        sys.exit(0)
