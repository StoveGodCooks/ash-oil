extends Node
## TestRunner — Auto-discovers and runs all test suites.
## Finds every test_*.gd in tests/unit/ and tests/integration/,
## runs all methods starting with "test_", calls setup()/teardown() around each.

signal tests_complete(report: String)

const TEST_DIRS = [
	"res://tests/unit/",
	"res://tests/integration/",
]

var total_passed:  int = 0
var total_failed:  int = 0
var total_skipped: int = 0
var total_suites:  int = 0
var report_lines:  Array = []

# ── Public API ─────────────────────────────────────────────────────────────
func run_all() -> String:
	total_passed  = 0
	total_failed  = 0
	total_skipped = 0
	total_suites  = 0
	report_lines  = []

	_header("ASH & OIL — FULL TEST SUITE")

	for dir_path in TEST_DIRS:
		var files = _discover_test_files(dir_path)
		for file_path in files:
			_run_suite(file_path)

	_footer()
	var report = "\n".join(report_lines)
	print(report)
	tests_complete.emit(report)
	return report

# ── Discovery ──────────────────────────────────────────────────────────────
func _discover_test_files(dir_path: String) -> Array:
	var files = []
	var dir = DirAccess.open(dir_path)
	if not dir:
		return files
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.begins_with("test_") and file_name.ends_with(".gd"):
			files.append(dir_path + file_name)
		file_name = dir.get_next()
	dir.list_dir_end()
	files.sort()
	return files

# ── Suite Runner ───────────────────────────────────────────────────────────
func _run_suite(file_path: String) -> void:
	var script = load(file_path)
	if not script:
		report_lines.append("  [ERROR] Could not load: %s" % file_path)
		return

	var suite = script.new()
	add_child(suite)
	total_suites += 1

	var suite_name = file_path.get_file().replace(".gd", "")
	report_lines.append("\n[SUITE] %s" % suite_name)
	report_lines.append("-".repeat(50))

	# Discover test methods
	var methods = []
	for m in suite.get_method_list():
		if m["name"].begins_with("test_"):
			methods.append(m["name"])
	methods.sort()

	if methods.is_empty():
		report_lines.append("  (no test_ methods found)")
		suite.queue_free()
		return

	# Run each test method
	for method in methods:
		suite._passed  = 0
		suite._failed  = 0
		suite._skipped = 0
		suite._results = []
		suite._current_test = method

		# setup
		if suite.has_method("setup"):
			suite.setup()

		# run test
		suite.call(method)

		# teardown
		if suite.has_method("teardown"):
			suite.teardown()

		# collect results
		total_passed  += suite._passed
		total_failed  += suite._failed
		total_skipped += suite._skipped

		var status = "[PASS]" if suite._failed == 0 else "[FAIL]"
		report_lines.append("\n  %s %s (%d assertions)" % [status, method, suite._passed + suite._failed])
		report_lines.append_array(suite._results)

	suite.queue_free()

# ── Report ─────────────────────────────────────────────────────────────────
func _header(title: String) -> void:
	report_lines.append("=".repeat(60))
	report_lines.append("  " + title)
	report_lines.append("  %s" % Time.get_datetime_string_from_system())
	report_lines.append("=".repeat(60))

func _footer() -> void:
	report_lines.append("\n" + "=".repeat(60))
	report_lines.append("  SUITES:  %d" % total_suites)
	report_lines.append("  PASSED:  %d" % total_passed)
	report_lines.append("  FAILED:  %d" % total_failed)
	report_lines.append("  SKIPPED: %d" % total_skipped)
	var verdict = "ALL TESTS PASSED" if total_failed == 0 else "*** %d TESTS FAILED ***" % total_failed
	report_lines.append("  RESULT:  %s" % verdict)
	report_lines.append("=".repeat(60))
