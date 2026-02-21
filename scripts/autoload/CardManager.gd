extends Node
## Card and Lieutenant data manager (Autoload Singleton)

var cards_data: Dictionary = {}
var lieutenants_data: Dictionary = {}

func _ready() -> void:
	_load_cards()
	_load_lieutenants()
	print("CardManager ready: %d cards, %d lieutenants" % [cards_data.size(), lieutenants_data.size()])

func _load_cards() -> void:
	var path = "res://data/cards.json"
	if not FileAccess.file_exists(path):
		push_error("cards.json not found")
		return
	var file = FileAccess.open(path, FileAccess.READ)
	var json = JSON.new()
	if json.parse(file.get_as_text()) == OK:
		cards_data = json.data

func _load_lieutenants() -> void:
	var path = "res://data/lieutenants.json"
	if not FileAccess.file_exists(path):
		push_error("lieutenants.json not found")
		return
	var file = FileAccess.open(path, FileAccess.READ)
	var json = JSON.new()
	if json.parse(file.get_as_text()) == OK:
		lieutenants_data = json.data

func get_card(id: String) -> Dictionary:
	return cards_data.get(id, {})

func get_lieutenant(lt_name: String) -> Dictionary:
	return lieutenants_data.get(lt_name, {})

func get_starter_deck() -> Array:
	## A balanced 20-card starter deck for new games
	return [
		"card_027", "card_027", "card_027", "card_027",  # 4x Quick Jab (free, 1 dmg)
		"card_001", "card_001", "card_001", "card_001",  # 4x Veteran's Strike (cost 1, 3 dmg)
		"card_028", "card_028", "card_028",              # 3x Steady Stance (free, 1 armor)
		"card_002", "card_002", "card_002",              # 3x Shield Bash (cost 1, 2 armor)
		"card_029", "card_029", "card_029",              # 3x Mending Potion (cost 1, heal 2)
		"card_033", "card_033",                          # 2x First Aid (cost 1, heal 3)
	]
