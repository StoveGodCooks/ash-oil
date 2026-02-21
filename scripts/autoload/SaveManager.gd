extends Node
## Save/Load manager (Autoload Singleton)

const SAVE_DIR = "user://saves/"
const SAVE_PREFIX = "slot_"
const SAVE_EXT = ".json"

func _ready() -> void:
	DirAccess.make_dir_recursive_absolute(SAVE_DIR)

func save_game(slot: int = 1) -> bool:
	var data = GameState.to_dict()
	var path = _get_path(slot)
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		push_error("Could not open save file: " + path)
		return false
	file.store_string(JSON.stringify(data, "\t"))
	print("Game saved to slot %d" % slot)
	return true

func load_game(slot: int = 1) -> bool:
	var path = _get_path(slot)
	if not FileAccess.file_exists(path):
		push_error("No save found at: " + path)
		return false
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		return false
	var json = JSON.new()
	if json.parse(file.get_as_text()) != OK:
		push_error("Failed to parse save file")
		return false
	GameState.from_dict(json.data)
	print("Game loaded from slot %d" % slot)
	return true

func save_exists(slot: int = 1) -> bool:
	return FileAccess.file_exists(_get_path(slot))

func delete_save(slot: int = 1) -> void:
	var path = _get_path(slot)
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)

func auto_save() -> void:
	save_game(0)

func _get_path(slot: int) -> String:
	return SAVE_DIR + SAVE_PREFIX + str(slot) + SAVE_EXT
