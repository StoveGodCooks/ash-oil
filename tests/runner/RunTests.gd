extends SceneTree
## Headless test runner for CI/local scripts.
## Usage: godot --headless --path <project> -s res://tests/runner/RunTests.gd

var _runner: Node
var _card_manager: Node
var _mission_manager: Node

func _initialize() -> void:
	# Defer start so autoloads finish _ready in headless mode.
	call_deferred("_start")

func _start() -> void:
	# Ensure data is loaded before tests execute.
	_card_manager = root.get_node("CardManager")
	_mission_manager = root.get_node("MissionManager")

	if _card_manager:
		_card_manager._load_cards()
		_card_manager._load_lieutenants()
		_card_manager._load_enemy_templates()
	else:
		push_error("CardManager autoload not found under /root")

	if _mission_manager:
		_mission_manager._load_missions()
	else:
		push_error("MissionManager autoload not found under /root")

	await process_frame

	_runner = load("res://tests/runner/TestRunner.gd").new()
	root.add_child(_runner)
	_runner.run_all()
	quit()
