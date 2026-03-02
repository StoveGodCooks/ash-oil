extends Node
## Mission manager (Autoload Singleton)

# ============ SIGNALS ============
signal mission_completed(mission_id: String)

var missions_data: Dictionary = {}
var gear_rng: RandomNumberGenerator = RandomNumberGenerator.new()
var last_reward: Dictionary = {}

func _ready() -> void:
	randomize()
	gear_rng.randomize()
	_load_missions()

func _load_missions() -> void:
	var path = "res://data/missions.json"
	if not FileAccess.file_exists(path):
		print("missions.json not found - will be created later")
		return
	var file = FileAccess.open(path, FileAccess.READ)
	var json = JSON.new()
	if json.parse(file.get_as_text()) == OK:
		missions_data = json.data
		print("Loaded %d missions" % missions_data.size())

func get_mission(id: String) -> Dictionary:
	if missions_data.is_empty():
		_load_missions()
	return missions_data.get(id, {})

func get_available_missions() -> Array:
	if missions_data.is_empty():
		_load_missions()
	var available = []
	for id in GameState.unlocked_missions:
		if is_mission_available(str(id)):
			available.append(id)
	return available

func start_mission(id: String) -> bool:
	if is_mission_available(id):
		GameState.current_mission_id = id
		return true
	return false

func complete_mission(id: String, outcome: String = "victory") -> void:
	var mission = get_mission(id)
	if mission.is_empty():
		print("Mission not found: " + id)
		return

	GameState.complete_mission(id)

	# Apply meter changes
	var multiplier = 1.0
	if outcome == "retreat": multiplier = 0.5
	elif outcome == "defeat": multiplier = 0.25

	# Thane "Arena Fav": +5 RENOWN bonus on arena mission victories
	var mission_location: String = str(mission.get("location", ""))
	if outcome == "victory" and mission_location == "Arena City":
		var has_thane := false
		for lt_id in GameState.active_lieutenants:
			var lt_d: Dictionary = CardManager.get_lieutenant(str(lt_id))
			if str(lt_d.get("trait", "")) == "Arena Fav":
				has_thane = true
				break
		if has_thane:
			GameState.change_meter("RENOWN", 5)
			print("[Thane] Arena Fav: +5 RENOWN from crowd favor.")

	var meters = mission.get("meter_changes", {})
	for meter in meters:
		GameState.change_meter(meter, int(meters[meter] * multiplier))

	# Apply relationship changes
	var relationships = mission.get("relationships", {})
	for lt in relationships:
		GameState.change_loyalty(lt, relationships[lt])
	_apply_npc_relationship_impacts(id, mission, multiplier)
	_apply_faction_alignment_impacts(id, mission, multiplier)
	_register_investigation_clues(id, mission, outcome)

	# Apply hooks
	for hook in mission.get("hooks_created", []):
		if hook not in GameState.active_hooks:
			GameState.active_hooks.append(hook)

	# Recruit any lieutenants unlocked by this mission
	_recruit_unlocked_lieutenants(id)

	# Distribute rewards
	last_reward = generate_mission_reward(id, outcome, multiplier)

	# Unlock next missions
	_unlock_next(id)
	SaveManager.auto_save()

	# Emit signal for narrative manager and other subscribers
	mission_completed.emit(id)

	# Final ending trigger (campaign completion)
	if id == "M20":
		var ending := check_ending_path()
		NarrativeManager.finalize_ending(ending)

func _unlock_next(id: String) -> void:
	if id.begins_with("M"):
		var num = int(id.substr(1))
		GameState.unlock_mission("M%02d" % (num + 1))
	# Side mission unlocks
	var side_unlocks = {
		"M01": ["S01", "S14"],
		"M04": ["S02"],
		"M05": ["S06", "S13"],
		"M06": ["S03"],
		"M08": ["S07", "S08"],
		"M09": ["S04"],
		"M11": ["S09"],
		"M12": ["S05", "S11", "S12"],
		"M14": ["S10"],
		"M15": ["S15"],
	}
	for mission in side_unlocks.get(id, []):
		GameState.unlock_mission(mission)

func _recruit_unlocked_lieutenants(mission_id: String) -> void:
	# Check if any lieutenant unlocks on this mission
	var lt_data = CardManager.lieutenants_data
	for lt_id in lt_data.keys():
		var lt = lt_data[lt_id]
		var unlock_mission = lt.get("unlock_mission", "")
		# Check if this lieutenant unlocks on this mission and not already recruited
		if unlock_mission == mission_id:
			var lt_state = GameState.lieutenant_data.get(lt_id, {})
			var already_recruited = bool(lt_state.get("recruited", false))
			if not already_recruited:
				GameState.recruit_lieutenant(lt_id)
				print("Recruited: %s" % lt.get("name", lt_id))

func is_mission_available(mission_id: String) -> bool:
	if not GameState.is_mission_available(mission_id):
		return false
	return get_mission_lock_reasons(mission_id).is_empty()

func get_mission_lock_reasons(mission_id: String) -> Array[String]:
	var reasons: Array[String] = []
	var mission := get_mission(mission_id)
	if mission.is_empty():
		reasons.append("Mission data missing")
		return reasons

	var npc_requirements = mission.get("npc_requirements", {})
	for npc_id in npc_requirements.keys():
		var req = npc_requirements[npc_id]
		var npc_reason := _check_npc_requirement(str(npc_id), req)
		if npc_reason != "":
			reasons.append(npc_reason)

	var faction_requirements = mission.get("faction_requirements", {})
	for faction_id in faction_requirements.keys():
		var req = faction_requirements[faction_id]
		var min_alignment := GameState.FACTION_CONTENT_THRESHOLD + 1
		if req is Dictionary:
			min_alignment = int((req as Dictionary).get("min", min_alignment))
		else:
			min_alignment = int(req)
		if GameState.get_faction_alignment(str(faction_id)) < min_alignment:
			reasons.append("Requires %s alignment %d" % [str(faction_id), min_alignment])

	var blocked_factions = mission.get("forbidden_factions", {})
	for faction_id in blocked_factions.keys():
		var threshold := int(blocked_factions[faction_id])
		if GameState.get_faction_alignment(str(faction_id)) >= threshold:
			reasons.append("Blocked by %s alignment %d+" % [str(faction_id), threshold])

	return reasons

func can_access_faction_content(faction_id: String) -> bool:
	return GameState.can_access_faction_content(faction_id)

func _check_npc_requirement(npc_id: String, req) -> String:
	var state := GameState.get_npc_state(npc_id)
	if state.is_empty():
		return "Requires %s" % npc_id
	var score := int(state.get("score", 0))
	var level := str(state.get("level", "neutral"))
	var flags: Dictionary = state.get("flags", {})
	var min_score := -100
	var max_score := 100
	var need_level := ""
	var required_flags: Array = []
	var forbidden_flags: Array = []

	if req is Dictionary:
		var d: Dictionary = req
		min_score = int(d.get("min_score", min_score))
		max_score = int(d.get("max_score", max_score))
		need_level = str(d.get("level", ""))
		required_flags = d.get("required_flags", [])
		forbidden_flags = d.get("forbidden_flags", [])
	elif req is int:
		min_score = int(req)

	if score < min_score:
		return "Requires %s trust (%d+)" % [npc_id, min_score]
	if score > max_score:
		return "Requires lower tension with %s" % npc_id
	if need_level != "" and level != need_level:
		return "Requires %s relationship: %s" % [npc_id, need_level]
	for f in required_flags:
		if not bool(flags.get(str(f), false)):
			return "Requires %s flag: %s" % [npc_id, str(f)]
	for f in forbidden_flags:
		if bool(flags.get(str(f), false)):
			return "%s flag prevents this mission: %s" % [npc_id, str(f)]
	return ""

func _apply_npc_relationship_impacts(mission_id: String, mission: Dictionary, multiplier: float) -> void:
	var npc_impacts = mission.get("npc_impacts", {})
	for npc_id in npc_impacts.keys():
		var impact: Dictionary = npc_impacts[npc_id]
		var score_delta := int(round(float(impact.get("score", 0)) * multiplier))
		if score_delta != 0:
			GameState.modify_relationship_score(str(npc_id), score_delta, "mission:%s" % mission_id)
		for flag_name in impact.get("set_flags", []):
			GameState.set_relationship_flag(str(npc_id), str(flag_name), true)
		for flag_name in impact.get("clear_flags", []):
			GameState.set_relationship_flag(str(npc_id), str(flag_name), false)

	var hook := NarrativeManager.get_mission_hook(mission_id)
	if hook.is_empty():
		return

	var allies = hook.get("who_helps", [])
	for npc_id in allies:
		var npc_name := str(npc_id)
		if GameState.get_npc_profile(npc_name).is_empty():
			continue
		GameState.set_relationship_flag(npc_name, "met", true)
		GameState.modify_relationship_score(npc_name, int(round(5.0 * multiplier)), "hook_help:%s" % mission_id)

	var hunters = hook.get("who_hunts", [])
	for npc_id in hunters:
		var npc_name := str(npc_id)
		if GameState.get_npc_profile(npc_name).is_empty():
			continue
		GameState.set_relationship_flag(npc_name, "met", true)
		GameState.modify_relationship_score(npc_name, int(round(-4.0 * multiplier)), "hook_hunt:%s" % mission_id)

func _apply_faction_alignment_impacts(mission_id: String, mission: Dictionary, multiplier: float) -> void:
	var explicit_changes: Dictionary = mission.get("faction_alignment_changes", {})
	for faction_id in explicit_changes.keys():
		var scaled := int(round(float(explicit_changes[faction_id]) * multiplier))
		if scaled != 0:
			GameState.modify_faction_alignment(str(faction_id), scaled, "mission:%s" % mission_id)

	if not explicit_changes.is_empty():
		return

	# Fallback derivation from narrative meters when mission lacks explicit faction tuning.
	var meters: Dictionary = mission.get("meter_changes", {})
	var inferred := {
		"Cult": int(meters.get("PIETY", 0)) * 12,
		"State": int(meters.get("FAVOR", 0)) * 12,
		"Syndicate": int(meters.get("DREAD", 0)) * 10,
	}
	for faction_id in inferred.keys():
		var delta := int(round(float(inferred[faction_id]) * multiplier))
		if delta != 0:
			GameState.modify_faction_alignment(str(faction_id), delta, "inferred:%s" % mission_id)

func _register_investigation_clues(mission_id: String, mission: Dictionary, outcome: String) -> void:
	## Register investigation clues for rivals when mission completes
	## Clues are only registered on victory (not retreat/defeat)
	if outcome != "victory":
		return

	var npc_impacts = mission.get("npc_impacts", {})
	for npc_name in npc_impacts.keys():
		var npc_data = npc_impacts[npc_name]
		var investigation_clue = npc_data.get("investigation_clue", {})

		if investigation_clue.is_empty():
			continue

		var rival_id = investigation_clue.get("rival_id", "")
		var clue_id = investigation_clue.get("clue_id", "")

		if rival_id.is_empty() or clue_id.is_empty():
			continue

		# Register clue with RivalManager
		RivalManager.register_clue(rival_id, clue_id)
		print("[Investigation] Registered clue '%s' for rival '%s' from mission %s" % [clue_id, rival_id, mission_id])

func _roll_gear_drop() -> String:
	var target_rarity := roll_gear_rarity()

	var candidates: Array = []
	var unowned_any_rarity: Array = []
	for gear_id in CardManager.gear_data.keys():
		if GameState.has_gear(gear_id):
			continue
		unowned_any_rarity.append(gear_id)
		var gear: Dictionary = CardManager.get_gear(gear_id)
		if str(gear.get("rarity", "")).to_lower() == target_rarity:
			candidates.append(gear_id)

	if candidates.is_empty():
		# Keep fallback-gold behavior for true "owned everything" state only.
		if unowned_any_rarity.is_empty():
			return ""
		candidates = unowned_any_rarity
	var pick_idx: int = gear_rng.randi_range(0, candidates.size() - 1)
	return str(candidates[pick_idx])

func roll_gear_rarity() -> String:
	var roll: float = gear_rng.randf()
	if roll < 0.01:
		return "epic"
	if roll < 0.10:
		return "rare"
	return "common"

func generate_mission_reward(mission_id: String, outcome: String, _multiplier: float) -> Dictionary:
	var mission = get_mission(mission_id)
	if mission.is_empty():
		return {"gold": 0, "gear_id": "", "gear_name": "", "gear_rarity": "", "dropped": false}
	var reward := {"gold": 0, "gear_id": "", "gear_name": "", "gear_rarity": "", "dropped": false}
	var rewards = mission.get("victory_rewards", {})
	if outcome == "retreat":
		rewards = mission.get("retreat_rewards", rewards)
	reward["gold"] = int(rewards.get("gold", 0))
	GameState.add_gold(reward["gold"])

	if outcome != "victory":
		return reward

	var drop_chance := _get_drop_chance(mission)
	if gear_rng.randf() > drop_chance:
		return reward

	var dropped_gear_id: String = _roll_gear_drop()
	if dropped_gear_id == "":
		var fallback_gold := _gear_fallback_gold(mission)
		if fallback_gold > 0:
			GameState.add_gold(fallback_gold)
			reward["gold"] += fallback_gold
		return reward

	GameState.add_gear(dropped_gear_id)
	var gear_data: Dictionary = CardManager.get_gear(dropped_gear_id)
	reward["gear_id"] = dropped_gear_id
	reward["gear_name"] = gear_data.get("name", dropped_gear_id)
	reward["gear_rarity"] = gear_data.get("rarity", "unknown")
	reward["dropped"] = true
	print("Gear drop: %s (%s)" % [reward["gear_name"], reward["gear_rarity"]])
	return reward

func _get_drop_chance(mission: Dictionary) -> float:
	var act = int(mission.get("act", 1))
	return get_drop_chance_for_act(act)

func get_drop_chance_for_act(act: int) -> float:
	match act:
		1:
			return 0.60
		2:
			return 0.75
		3:
			return 0.90
		_:
			return 1.0

func _gear_fallback_gold(_mission: Dictionary) -> int:
	return 100

func set_gear_rng_seed(rng_seed: int) -> void:
	gear_rng.seed = rng_seed

func get_last_reward_text() -> String:
	if last_reward.is_empty():
		return ""
	var gold = int(last_reward.get("gold", 0))
	var gear_name = str(last_reward.get("gear_name", ""))
	if gear_name != "":
		return "Reward: +%d gold | Gear: %s" % [gold, gear_name]
	return "Reward: +%d gold" % gold

func check_ending_path() -> String:
	if GameState.piety >= 7:
		return "Cult"
	if GameState.favor >= 6:
		return "State"
	return "Solo"
