extends Node
## TestBase — Base class for all Ash & Oil test suites.
## Extend this class. Methods starting with "test_" are auto-run by TestRunner.
## setup() is called before each test. teardown() is called after each test.

var _passed:  int = 0
var _failed:  int = 0
var _skipped: int = 0
var _results: Array = []
var _current_test: String = ""

# ── Lifecycle (override in test suites) ────────────────────────────────────
func setup() -> void:
	## Called before every test_ method. Reset state here.
	GameState.reset()

func teardown() -> void:
	## Called after every test_ method. Cleanup here.
	pass

# ── Assertions ─────────────────────────────────────────────────────────────
func assert_eq(label: String, got, expected) -> void:
	if got == expected:
		_pass(label)
	else:
		_fail(label, "expected [%s], got [%s]" % [str(expected), str(got)])

func assert_ne(label: String, got, not_expected) -> void:
	if got != not_expected:
		_pass(label)
	else:
		_fail(label, "expected value to NOT equal [%s]" % str(not_expected))

func assert_true(label: String, value: bool) -> void:
	if value:
		_pass(label)
	else:
		_fail(label, "expected true, got false")

func assert_false(label: String, value: bool) -> void:
	if not value:
		_pass(label)
	else:
		_fail(label, "expected false, got true")

func assert_gt(label: String, value, min_val) -> void:
	if value > min_val:
		_pass(label)
	else:
		_fail(label, "[%s] is not > [%s]" % [str(value), str(min_val)])

func assert_gte(label: String, value, min_val) -> void:
	if value >= min_val:
		_pass(label)
	else:
		_fail(label, "[%s] is not >= [%s]" % [str(value), str(min_val)])

func assert_lt(label: String, value, max_val) -> void:
	if value < max_val:
		_pass(label)
	else:
		_fail(label, "[%s] is not < [%s]" % [str(value), str(max_val)])

func assert_lte(label: String, value, max_val) -> void:
	if value <= max_val:
		_pass(label)
	else:
		_fail(label, "[%s] is not <= [%s]" % [str(value), str(max_val)])

func assert_in(label: String, item, collection) -> void:
	if item in collection:
		_pass(label)
	else:
		_fail(label, "[%s] not found in collection" % str(item))

func assert_not_in(label: String, item, collection) -> void:
	if item not in collection:
		_pass(label)
	else:
		_fail(label, "[%s] found in collection (expected absent)" % str(item))

func assert_empty(label: String, collection) -> void:
	if collection.is_empty():
		_pass(label)
	else:
		_fail(label, "expected empty, size was %d" % collection.size())

func assert_not_empty(label: String, collection) -> void:
	if not collection.is_empty():
		_pass(label)
	else:
		_fail(label, "expected non-empty collection, was empty")

func assert_size(label: String, collection, expected_size: int) -> void:
	var actual = collection.size()
	if actual == expected_size:
		_pass(label)
	else:
		_fail(label, "expected size %d, got %d" % [expected_size, actual])

func assert_approx(label: String, got: float, expected: float, tolerance: float = 0.001) -> void:
	if abs(got - expected) <= tolerance:
		_pass(label)
	else:
		_fail(label, "expected ~%.4f, got %.4f (tolerance %.4f)" % [expected, got, tolerance])

func assert_has_key(label: String, dict: Dictionary, key: String) -> void:
	if dict.has(key):
		_pass(label)
	else:
		_fail(label, "dict missing key '%s'" % key)

func assert_between(label: String, value, low, high) -> void:
	if value >= low and value <= high:
		_pass(label)
	else:
		_fail(label, "[%s] not in range [%s, %s]" % [str(value), str(low), str(high)])

func assert_type(label: String, value, type_name: String) -> void:
	var actual = typeof(value)
	var type_map = {
		"int": TYPE_INT, "float": TYPE_FLOAT, "bool": TYPE_BOOL,
		"string": TYPE_STRING, "array": TYPE_ARRAY, "dict": TYPE_DICTIONARY
	}
	if type_map.has(type_name) and actual == type_map[type_name]:
		_pass(label)
	else:
		_fail(label, "expected type '%s', got type id %d" % [type_name, actual])

func skip(label: String, reason: String = "") -> void:
	_skipped += 1
	_results.append("  [SKIP] %s%s" % [label, (" — " + reason) if reason != "" else ""])

# ── Internal ───────────────────────────────────────────────────────────────
func _pass(label: String) -> void:
	_passed += 1
	_results.append("  [PASS] %s" % label)

func _fail(label: String, reason: String) -> void:
	_failed += 1
	_results.append("  [FAIL] %s — %s" % [label, reason])

func get_results()  -> Array: return _results
func get_passed()   -> int:   return _passed
func get_failed()   -> int:   return _failed
func get_skipped()  -> int:   return _skipped

func suite_name() -> String:
	return get_script().resource_path.get_file().replace(".gd", "")
