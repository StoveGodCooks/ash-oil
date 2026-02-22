extends Node
## Central game state manager (Autoload Singleton)
## Tracks all persistent game data: meters, relationships, inventory, progression

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
var npc_relationships: Dictionary = {
	"Lanista": {"met": false, "betrayed": false},
	"Varro":   {"met": false, "revealed": false},
	"Rhesus":  {"met": false, "ally": false},
	"Iona":    {"met": false},
	"Moth":    {"alive": true, "rescued": false},
}

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

# ============ SIGNALS ============
signal meter_changed(meter_name: String, new_value: int)
signal lieutenant_loyalty_changed(lt_name: String, loyalty: int)
signal mission_completed(mission_id: String)
signal game_loaded

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
	story_phase        = data.get("story_phase",        "SURVIVAL")
	var loaded_threat = data.get("threat_level", ["Marcellus"])
	if loaded_threat is Array:
		threat_level = Array[String](loaded_threat)
	elif typeof(loaded_threat) == TYPE_STRING and not loaded_threat.is_empty():
		threat_level = Array[String]([loaded_threat])
	else:
		threat_level = Array[String](["Marcellus"])
	refusals_made      = data.get("refusals_made",      0)
	costs_paid         = data.get("costs_paid",         [])
	narrative_momentum = data.get("narrative_momentum", "On the Run")
	completed_story_beats = data.get("completed_story_beats", [])
	current_location   = data.get("current_location",   "Arena City")
	season             = data.get("season", 1)
	act                = data.get("act",    1)
	ending_reached     = data.get("ending_reached", "")
	game_loaded.emit()

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
