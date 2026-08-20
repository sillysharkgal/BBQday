extends Node

@export var required_buttons: int = 4
@export var gate: Node

var activated_buttons: Dictionary = {}
var solved: bool = false
var player_passed_gate: bool = false

func activate_button(button_id: int) -> void:
	if solved:
		return

	if activated_buttons.has(button_id):
		return

	activated_buttons[button_id] = true
	print("Button activated: ", button_id)

	var ui: Node = get_tree().get_first_node_in_group("ui")
	if ui != null and ui.has_method("set_button_indicator"):
		ui.set_button_indicator(button_id, true)

	if activated_buttons.size() >= required_buttons:
		solve_puzzle()

func on_player_passed_gate() -> void:
	if not solved:
		return

	if player_passed_gate:
		return

	player_passed_gate = true

	var ui: Node = get_tree().get_first_node_in_group("ui")
	await get_tree().create_timer(2.0).timeout
	if ui != null and ui.has_method("clear_button_indicators"):
		ui.clear_button_indicators()

func solve_puzzle() -> void:
	solved = true
	print("Puzzle solved!")

	if gate != null and gate.has_method("open_gate"):
		gate.open_gate()
