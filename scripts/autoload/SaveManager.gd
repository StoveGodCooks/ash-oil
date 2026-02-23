extends Node
## Save/Load manager (Autoload Singleton)

const SAVE_DIR = "user://saves/"
const FALLBACK_SAVE_DIR = "res://.tmp_saves/"
const SAVE_PREFIX = "slot_"
const SAVE_EXT = ".json"
var active_save_dir: String = SAVE_DIR

func _ready() -> void:
	_ensure_save_dir()

func save_game(slot: int = 1) -> bool:
	if not _ensure_save_dir():
		push_error("Could not prepare save directory: " + SAVE_DIR)
		return false
	var data = GameState.to_dict()
	var path = _get_path(slot)
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file == null and active_save_dir != FALLBACK_SAVE_DIR:
		active_save_dir = FALLBACK_SAVE_DIR
		DirAccess.make_dir_recursive_absolute(active_save_dir)
		path = _get_path(slot)
		file = FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		push_error("Could not open save file: " + path)
		return false
	file.store_string(JSON.stringify(data, "\t"))
	print("Game saved to slot %d" % slot)
	return true

func load_game(slot: int = 1) -> bool:
	if not _ensure_save_dir():
		push_error("Could not prepare save directory: " + SAVE_DIR)
		return false
	var path = _get_path(slot)
	if not FileAccess.file_exists(path):
		var alternate_dir := FALLBACK_SAVE_DIR if active_save_dir == SAVE_DIR else SAVE_DIR
		var alternate_path := alternate_dir + SAVE_PREFIX + str(slot) + SAVE_EXT
		if FileAccess.file_exists(alternate_path):
			active_save_dir = alternate_dir
			path = alternate_path
		else:
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
	_ensure_save_dir()
	if FileAccess.file_exists(_get_path(slot)):
		return true
	var alternate_dir := FALLBACK_SAVE_DIR if active_save_dir == SAVE_DIR else SAVE_DIR
	return FileAccess.file_exists(alternate_dir + SAVE_PREFIX + str(slot) + SAVE_EXT)

func delete_save(slot: int = 1) -> void:
	var path_user := SAVE_DIR + SAVE_PREFIX + str(slot) + SAVE_EXT
	if FileAccess.file_exists(path_user):
		DirAccess.remove_absolute(path_user)
	var path_fallback := FALLBACK_SAVE_DIR + SAVE_PREFIX + str(slot) + SAVE_EXT
	if FileAccess.file_exists(path_fallback):
		DirAccess.remove_absolute(path_fallback)

func auto_save() -> void:
	save_game(0)

func _get_path(slot: int) -> String:
	return active_save_dir + SAVE_PREFIX + str(slot) + SAVE_EXT

func _ensure_save_dir() -> bool:
	active_save_dir = SAVE_DIR
	DirAccess.make_dir_recursive_absolute(active_save_dir)
	if DirAccess.dir_exists_absolute(active_save_dir):
		return true
	active_save_dir = FALLBACK_SAVE_DIR
	DirAccess.make_dir_recursive_absolute(active_save_dir)
	return DirAccess.dir_exists_absolute(active_save_dir)
