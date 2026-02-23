extends Node
## Central game state manager (Autoload Singleton)
## Tracks all persistent game data: meters, relationships, inventory, progression

const NPC_DATA_PATH := "res://data/npcs.json"
const NPC_DIALOGUE_PATH := "res://data/npc_dialogue.json"
const RELATIONSHIP_MIN := -100
const RELATIONSHIP_MAX := 100
const RELATIONSHIP_ALLY_THRESHOLD := 50
const RELATIONSHIP_ENEMY_THRESHOLD := -50
const FACTION_ALIGNMENT_MIN := -100
const FACTION_ALIGNMENT_MAX := 100
const FACTION_CONTENT_THRESHOLD := 25

# ============ METERS ============
var RENOWN: int = 0
var HEAT: int = 0
var PIETY: int = 0
var FAVOR: int = 0
var DEBT: int = 0
var DREAD: int = 0

# ============ LIEUTENANTS ============
var lieutenant_data: Dictionary = {
	"Marcus":  {"loyalty": 0, "level": 1, "recruited": false, "alive": true},
	"Livia":   {"loyalty": 0, "level": 1, "recruited": false, "alive": true},
	"Titus":   {"loyalty": 0, "level": 1, "recruited": false, "alive": true},
	"Kara":    {"loyalty": 0, "level": 1, "recruited": false, "alive": true},
	"Decimus": {"loyalty": 0, "level": 1, "recruited": false, "alive": true},
	"Julia":   {"loyalty": 0, "level": 1, "recruited": false, "alive": true},
	"Corvus":  {"loyalty": 0, "level": 1, "recruited": false, "alive": true},
	"Thane":   {"loyalty": 0, "level": 1, "recruited": false, "alive": true},
}

# ============ SQUAD ============
var active_lieutenants: Array = []   # Currently fighting (max 2)
var benched_lieutenants: Array = []  # Backup bench
var swapped_out: String = ""
var swap_cooldown: int = 0

# ============ INVENTORY ============
var gold: int = 0
var current_deck: Array = []
var discovered_cards: Array = []
var owned_gear: Array = []
var equipped_gear: Dictionary = {
	"weapon": "",
	"armor": "",
	"accessory": "",
}

# ============ MISSION PROGRESS ============
var current_mission_id: String = ""
var completed_missions: Array = []
var unlocked_missions: Array = ["M01"]
var story_flags: Dictionary = {}
var active_hooks: Array = []

# ============ FACTIONS ============
var faction_status: Dictionary = {
	"Cult":      {"alignment": 0, "hostile": false},
	"State":     {"alignment": 0, "hostile": false},
	"Syndicate": {"alignment": 0, "hostile": false},
}

# ============ NPC RELATIONSHIPS ============
var npc_profiles: Dictionary = {}
# Backward-compat alias expected by older tests/callers.
var npc_registry: Dictionary = {}
var npc_dialogue: Dictionary = {}
var npc_relationships: Dictionary = {
	"Lanista": {"met": false, "betrayed": false, "score": 0, "level": "neutral", "flags": {}, "faction": "State"},
	"Varro":   {"met": false, "revealed": false, "score": 0, "level": "neutral", "flags": {}, "faction": "Neutral"},
	"Rhesus":  {"met": false, "ally": false, "score": 0, "level": "neutral", "flags": {}, "faction": "Neutral"},
	"Iona":    {"met": false, "score": 0, "level": "neutral", "flags": {}, "faction": "Cult"},
	"Moth":    {"alive": true, "rescued": false, "score": 0, "level": "neutral", "flags": {}, "faction": "Syndicate"},
}
var relationship_log: Array = []

# ============ SERVICES ============
var services: Dictionary = {
	"Doctor":     {"available": true,  "price_mod": 1.0},
	"Shaman":     {"available": false, "price_mod": 1.0},
	"Market":     {"available": true,  "price_mod": 1.0},
	"CardVendor": {"available": true,  "price_mod": 1.0},
	"BlackMarket":{"available": false, "price_mod": 1.0},
}

# ============ ROUTES ============
var routes: Dictionary = {
	"Arena_Ridge": {"state": "safe",   "toll": 0},
	"Ridge_Port":  {"state": "safe",   "toll": 0},
	"Port_Shrine": {"state": "locked", "toll": 0},
}

# ============ NARRATIVE STATE ============
var story_phase: String = "SURVIVAL"  # SURVIVAL / HOPE / RESISTANCE
var threat_level: Array[String] = ["Marcellus"]  # Who is actively hunting Cassian?
var refusals_made: int = 0  # Counter: how many times has Cassian said "No"?
var costs_paid: Array[String] = []  # Names of those who've sacrificed for Cassian
var narrative_momentum: String = "On the Run"  # Phase-dependent state description
var completed_story_beats: Array[String] = []  # Story beat IDs that have triggered

# ============ GAME STATE ============
var current_location: String = "Arena City"
var season: int = 1
var act: int = 1
var ending_reached: String = ""

# ============ ACCESSIBILITY ============
var accessibility: Dictionary = {
	"high_contrast": false,
	"colorblind_mode": false,
	"text_scale": 1.0,
	"large_cursor": false,
	"animation_speed": 1.0,
}

# ============ SIGNALS ============
signal meter_changed(meter_name: String, new_value: int)
signal lieutenant_loyalty_changed(lt_name: String, loyalty: int)
signal mission_completed(mission_id: String)
signal game_loaded

func _ready() -> void:
	_load_relationship_data()
	_ensure_npc_relationships()

# ============ METER FUNCTIONS ============
func change_meter(meter_name: String, amount: int) -> void:
	match meter_name:
		"RENOWN": RENOWN = clamp(RENOWN + amount, 0, 20)
		"HEAT":   HEAT   = clamp(HEAT   + amount, 0, 15)
		"PIETY":  PIETY  = clamp(PIETY  + amount, 0, 10)
		"FAVOR":  FAVOR  = clamp(FAVOR  + amount, 0, 10)
		"DEBT":   DEBT   = max(0, DEBT  + amount)
		"DREAD":  DREAD  = clamp(DREAD  + amount, 0, 10)
	meter_changed.emit(meter_name, get_meter(meter_name))

func get_meter(meter_name: String) -> int:
	match meter_name:
		"RENOWN": return RENOWN
		"HEAT":   return HEAT
		"PIETY":  return PIETY
		"FAVOR":  return FAVOR
		"DEBT":   return DEBT
		"DREAD":  return DREAD
	return 0

# ============ LIEUTENANT FUNCTIONS ============
func recruit_lieutenant(lt_name: String) -> void:
	if lt_name in lieutenant_data:
		lieutenant_data[lt_name]["recruited"] = true
		if lt_name not in active_lieutenants and active_lieutenants.size() < 2:
			active_lieutenants.append(lt_name)

func change_loyalty(lt_name: String, amount: int) -> void:
	if lt_name in lieutenant_data:
		lieutenant_data[lt_name]["loyalty"] = clamp(
			lieutenant_data[lt_name]["loyalty"] + amount, -5, 10
		)
		lieutenant_loyalty_changed.emit(lt_name, lieutenant_data[lt_name]["loyalty"])
		if lieutenant_data[lt_name]["loyalty"] < -3:
			active_lieutenants.erase(lt_name)

# ============ INVENTORY FUNCTIONS ============
func add_gold(amount: int) -> void:
	gold += amount

func spend_gold(amount: int) -> bool:
	if gold >= amount:
		gold -= amount
		return true
	return false

func add_card(card_id: String) -> bool:
	if current_deck.size() < 30:
		current_deck.append(card_id)
		if card_id not in discovered_cards:
			discovered_cards.append(card_id)
		return true
	return false

func add_gear(gear_id: String) -> void:
	if gear_id not in owned_gear:
		owned_gear.append(gear_id)

func has_gear(gear_id: String) -> bool:
	return gear_id in owned_gear

func equip_gear(slot: String, gear_id: String) -> void:
	if slot in equipped_gear:
		equipped_gear[slot] = gear_id

func set_accessibility_setting(key: String, value) -> void:
	if key not in accessibility:
		return
	accessibility[key] = value

func get_accessibility_setting(key: String, fallback):
	return accessibility.get(key, fallback)

# ============ NPC/Faction API ============
func set_relationship_flag(npc_id: String, flag_name: String, value: bool) -> void:
	_ensure_npc(npc_id)
	var state: Dictionary = npc_relationships[npc_id]
	var flags: Dictionary = state.get("flags", {})
	flags[flag_name] = value
	state["flags"] = flags
	if flag_name == "met":
		state["met"] = value
	npc_relationships[npc_id] = state
	_update_npc_level(npc_id)
	_log_relationship("%s flag[%s]=%s" % [npc_id, flag_name, str(value)])

func check_relationship_flag(npc_id: String, flag_name: String) -> bool:
	if npc_id not in npc_relationships:
		return false
	var state: Dictionary = npc_relationships[npc_id]
	var flags: Dictionary = state.get("flags", {})
	if flag_name in flags:
		return bool(flags[flag_name])
	return bool(state.get(flag_name, false))

func modify_relationship_score(npc_id: String, delta: int, reason: String = "") -> void:
	_ensure_npc(npc_id)
	var state: Dictionary = npc_relationships[npc_id]
	var old_score: int = int(state.get("score", 0))
	var new_score: int = clamp(old_score + delta, RELATIONSHIP_MIN, RELATIONSHIP_MAX)
	state["score"] = new_score
	npc_relationships[npc_id] = state
	_update_npc_level(npc_id)
	var suffix := ""
	if reason != "":
		suffix = " (%s)" % reason
	_log_relationship("%s score %d -> %d%s" % [npc_id, old_score, new_score, suffix])

func get_relationship_level(npc_id: String) -> String:
	if npc_id not in npc_relationships:
		return "neutral"
	return str((npc_relationships[npc_id] as Dictionary).get("level", "neutral"))

func get_npc_state(npc_id: String) -> Dictionary:
	if npc_id not in npc_relationships:
		return {}
	return (npc_relationships[npc_id] as Dictionary).duplicate(true)

func get_npc_profile(npc_id: String) -> Dictionary:
	return npc_profiles.get(npc_id, {})

func get_npc_dialogue(npc_id: String, context: String = "default") -> String:
	var level := get_relationship_level(npc_id)
	var entry: Dictionary = npc_dialogue.get(npc_id, {})
	var contexts: Dictionary = entry.get("contexts", {})
	var ctx: Dictionary = contexts.get(context, contexts.get("default", {}))
	if ctx.is_empty():
		return _fallback_dialogue(npc_id, level)
	var flags: Dictionary = ctx.get("flags", {})
	for flag_name in flags.keys():
		if check_relationship_flag(npc_id, str(flag_name)):
			return str(flags[flag_name])
	return str(ctx.get(level, ctx.get("neutral", _fallback_dialogue(npc_id, level))))

func get_faction_alignment(faction_id: String) -> int:
	if faction_id not in faction_status:
		return 0
	return int((faction_status[faction_id] as Dictionary).get("alignment", 0))

func modify_faction_alignment(faction_id: String, delta: int, reason: String = "") -> void:
	if faction_id not in faction_status:
		return
	var chosen: Dictionary = faction_status[faction_id]
	var old_alignment: int = int(chosen.get("alignment", 0))
	var new_alignment: int = clamp(old_alignment + delta, FACTION_ALIGNMENT_MIN, FACTION_ALIGNMENT_MAX)
	chosen["alignment"] = new_alignment
	chosen["hostile"] = new_alignment <= RELATIONSHIP_ENEMY_THRESHOLD
	faction_status[faction_id] = chosen
	if delta > 0:
		var spill: int = maxi(1, int(round(float(delta) * 0.6)))
		for other_faction in faction_status.keys():
			if other_faction == faction_id:
				continue
			var other: Dictionary = faction_status[other_faction]
			var lowered: int = clamp(int(other.get("alignment", 0)) - spill, FACTION_ALIGNMENT_MIN, FACTION_ALIGNMENT_MAX)
			other["alignment"] = lowered
			other["hostile"] = lowered <= RELATIONSHIP_ENEMY_THRESHOLD
			if new_alignment > FACTION_CONTENT_THRESHOLD and lowered > FACTION_CONTENT_THRESHOLD:
				other["alignment"] = FACTION_CONTENT_THRESHOLD - 1
				other["hostile"] = false
			faction_status[other_faction] = other
	var suffix := ""
	if reason != "":
		suffix = " (%s)" % reason
	_log_relationship("Faction %s alignment %d -> %d%s" % [faction_id, old_alignment, new_alignment, suffix])
	_enforce_npc_faction_consistency()

func can_access_faction_content(faction_id: String) -> bool:
	return get_faction_alignment(faction_id) > FACTION_CONTENT_THRESHOLD

# ============ MISSION FUNCTIONS ============
func complete_mission(mission_id: String) -> void:
	if mission_id not in completed_missions:
		completed_missions.append(mission_id)
		mission_completed.emit(mission_id)

func unlock_mission(mission_id: String) -> void:
	if mission_id not in unlocked_missions:
		unlocked_missions.append(mission_id)

func is_mission_available(mission_id: String) -> bool:
	return mission_id in unlocked_missions and mission_id not in completed_missions

# ============ SAVE/LOAD ============
func to_dict() -> Dictionary:
	return {
		"RENOWN": RENOWN, "HEAT": HEAT, "PIETY": PIETY,
		"FAVOR": FAVOR, "DEBT": DEBT, "DREAD": DREAD,
		"lieutenant_data": lieutenant_data,
		"active_lieutenants": active_lieutenants,
		"benched_lieutenants": benched_lieutenants,
		"gold": gold,
		"current_deck": current_deck,
		"discovered_cards": discovered_cards,
		"owned_gear": owned_gear,
		"equipped_gear": equipped_gear,
		"completed_missions": completed_missions,
		"unlocked_missions": unlocked_missions,
		"current_mission_id": current_mission_id,
		"story_flags": story_flags,
		"active_hooks": active_hooks,
		"faction_status": faction_status,
		"npc_relationships": npc_relationships,
		"relationship_log": relationship_log,
		"story_phase": story_phase,
		"threat_level": threat_level,
		"refusals_made": refusals_made,
		"costs_paid": costs_paid,
		"narrative_momentum": narrative_momentum,
		"completed_story_beats": completed_story_beats,
		"current_location": current_location,
		"season": season,
		"act": act,
		"ending_reached": ending_reached,
		"accessibility": accessibility,
	}

func from_dict(data: Dictionary) -> void:
	RENOWN = data.get("RENOWN", 0)
	HEAT   = data.get("HEAT",   0)
	PIETY  = data.get("PIETY",  0)
	FAVOR  = data.get("FAVOR",  0)
	DEBT   = data.get("DEBT",   0)
	DREAD  = data.get("DREAD",  0)
	lieutenant_data    = data.get("lieutenant_data",    lieutenant_data)
	active_lieutenants = data.get("active_lieutenants", [])
	benched_lieutenants= data.get("benched_lieutenants",[])
	gold               = data.get("gold",               0)
	current_deck       = data.get("current_deck",       [])
	discovered_cards   = data.get("discovered_cards",   [])
	owned_gear         = data.get("owned_gear",         [])
	equipped_gear      = data.get("equipped_gear",      equipped_gear)
	completed_missions = data.get("completed_missions",  [])
	unlocked_missions  = data.get("unlocked_missions",  ["M01"])
	current_mission_id = data.get("current_mission_id", "")
	story_flags        = data.get("story_flags",         {})
	active_hooks       = data.get("active_hooks",        [])
	faction_status     = data.get("faction_status",      faction_status)
	npc_relationships  = data.get("npc_relationships",   npc_relationships)
	relationship_log   = data.get("relationship_log", [])
	story_phase        = data.get("story_phase",        "SURVIVAL")
	threat_level = _normalize_string_array(data.get("threat_level", ["Marcellus"]), ["Marcellus"])
	refusals_made      = data.get("refusals_made",      0)
	costs_paid         = _normalize_string_array(data.get("costs_paid", []), [])
	narrative_momentum = data.get("narrative_momentum", "On the Run")
	completed_story_beats = _normalize_string_array(data.get("completed_story_beats", []), [])
	current_location   = data.get("current_location",   "Arena City")
	season             = data.get("season", 1)
	act                = data.get("act",    1)
	ending_reached     = data.get("ending_reached", "")
	accessibility = data.get("accessibility", accessibility)
	accessibility["text_scale"] = clampf(float(accessibility.get("text_scale", 1.0)), 0.8, 1.5)
	accessibility["animation_speed"] = clampf(float(accessibility.get("animation_speed", 1.0)), 0.5, 2.0)
	_load_relationship_data()
	_ensure_npc_relationships()
	_enforce_npc_faction_consistency()
	game_loaded.emit()

func _normalize_string_array(value, fallback: Array[String]) -> Array[String]:
	var result: Array[String] = []
	if value is Array:
		for entry in value:
			if typeof(entry) == TYPE_STRING:
				result.append(entry)
	elif typeof(value) == TYPE_STRING and not value.is_empty():
		result.append(value)
	if result.is_empty():
		result = fallback.duplicate()
	return result

func reset() -> void:
	RENOWN = 0; HEAT = 0; PIETY = 0; FAVOR = 0; DEBT = 0; DREAD = 0
	for lt in lieutenant_data:
		lieutenant_data[lt] = {"loyalty": 0, "level": 1, "recruited": false, "alive": true}
	active_lieutenants = []; benched_lieutenants = []
	gold = 0; current_deck = []; discovered_cards = []
	owned_gear = []
	equipped_gear = {"weapon": "", "armor": "", "accessory": ""}
	completed_missions = []; unlocked_missions = ["M01"]
	current_mission_id = ""; story_flags = {}; active_hooks = []
	story_phase = "SURVIVAL"; threat_level = ["Marcellus"]; refusals_made = 0
	costs_paid = []; narrative_momentum = "On the Run"; completed_story_beats = []
	current_location = "Arena City"; season = 1; act = 1; ending_reached = ""
	faction_status = {
		"Cult": {"alignment": 0, "hostile": false},
		"State": {"alignment": 0, "hostile": false},
		"Syndicate": {"alignment": 0, "hostile": false},
	}
	npc_relationships = {
		"Lanista": {"met": false, "betrayed": false, "score": 0, "level": "neutral", "flags": {}, "faction": "State"},
		"Varro":   {"met": false, "revealed": false, "score": 0, "level": "neutral", "flags": {}, "faction": "Neutral"},
		"Rhesus":  {"met": false, "ally": false, "score": 0, "level": "neutral", "flags": {}, "faction": "Neutral"},
		"Iona":    {"met": false, "score": 0, "level": "neutral", "flags": {}, "faction": "Cult"},
		"Moth":    {"alive": true, "rescued": false, "score": 0, "level": "neutral", "flags": {}, "faction": "Syndicate"},
	}
	relationship_log = []
	accessibility = {
		"high_contrast": false,
		"colorblind_mode": false,
		"text_scale": 1.0,
		"large_cursor": false,
		"animation_speed": 1.0,
	}
	_load_relationship_data()
	_ensure_npc_relationships()

func _load_relationship_data() -> void:
	var loaded_profiles := _load_json_dict(NPC_DATA_PATH)
	if loaded_profiles is Dictionary and not loaded_profiles.is_empty():
		npc_profiles = loaded_profiles
		npc_registry = npc_profiles
	else:
		npc_registry = npc_profiles
	var loaded_dialogue := _load_json_dict(NPC_DIALOGUE_PATH)
	if loaded_dialogue is Dictionary:
		npc_dialogue = loaded_dialogue

func _load_json_dict(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {}
	var parsed = JSON.parse_string(file.get_as_text())
	if parsed is Dictionary:
		return parsed
	return {}

func _ensure_npc(npc_id: String) -> void:
	if npc_id in npc_relationships:
		return
	var profile: Dictionary = npc_profiles.get(npc_id, {})
	npc_relationships[npc_id] = {
		"met": false,
		"score": int(profile.get("initial_score", 0)),
		"level": str(profile.get("initial_status", "neutral")),
		"flags": {},
		"faction": str(profile.get("faction", "Neutral")),
	}

func _ensure_npc_relationships() -> void:
	for npc_id in npc_profiles.keys():
		_ensure_npc(str(npc_id))
		var state: Dictionary = npc_relationships[npc_id]
		if "flags" not in state:
			state["flags"] = {}
		if "score" not in state:
			state["score"] = int(npc_profiles[npc_id].get("initial_score", 0))
		if "faction" not in state:
			state["faction"] = str(npc_profiles[npc_id].get("faction", "Neutral"))
		npc_relationships[npc_id] = state
		_update_npc_level(str(npc_id))

func _update_npc_level(npc_id: String) -> void:
	if npc_id not in npc_relationships:
		return
	var state: Dictionary = npc_relationships[npc_id]
	var flags: Dictionary = state.get("flags", {})
	if bool(flags.get("betrayed", false)) or bool(state.get("betrayed", false)):
		state["level"] = "enemy"
	else:
		var score := int(state.get("score", 0))
		if score >= RELATIONSHIP_ALLY_THRESHOLD:
			state["level"] = "ally"
		elif score <= RELATIONSHIP_ENEMY_THRESHOLD:
			state["level"] = "enemy"
		else:
			state["level"] = "neutral"
	npc_relationships[npc_id] = state

func _enforce_npc_faction_consistency() -> void:
	for npc_id in npc_relationships.keys():
		var state: Dictionary = npc_relationships[npc_id]
		var faction := str(state.get("faction", "Neutral"))
		if faction == "" or faction == "Neutral" or faction not in faction_status:
			continue
		var alignment := get_faction_alignment(faction)
		var score := int(state.get("score", 0))
		if alignment <= RELATIONSHIP_ENEMY_THRESHOLD and score >= RELATIONSHIP_ALLY_THRESHOLD:
			state["score"] = RELATIONSHIP_ALLY_THRESHOLD - 1
		if alignment >= RELATIONSHIP_ALLY_THRESHOLD and score <= RELATIONSHIP_ENEMY_THRESHOLD:
			state["score"] = RELATIONSHIP_ENEMY_THRESHOLD + 1
		npc_relationships[npc_id] = state
		_update_npc_level(str(npc_id))

func _fallback_dialogue(npc_id: String, level: String) -> String:
	var profile: Dictionary = npc_profiles.get(npc_id, {})
	var name := str(profile.get("name", npc_id))
	if level == "ally":
		return "%s trusts you." % name
	if level == "enemy":
		return "%s refuses to cooperate." % name
	return "%s remains cautious." % name

func _log_relationship(line: String) -> void:
	relationship_log.append(line)
	if relationship_log.size() > 120:
		relationship_log.pop_front()
	print("[REL] %s" % line)
