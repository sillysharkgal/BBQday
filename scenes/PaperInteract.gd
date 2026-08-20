extends StaticBody3D

@export var paper_title: String = "Dear Neighbour"
@export_multiline var paper_text: String = "Please join our BBQ party."
@export var target_gate: Node
@onready var paper_sfx: AudioStreamPlayer3D = $pagesfx

func get_interact_prompt() -> String:
	return "Press E to Read"

func interact(player: Node) -> void:
	var ui: Node = get_tree().get_first_node_in_group("ui")

	if ui == null:
		print("No UI found")
		return
	paper_sfx.play()
	ui.show_paper(paper_title, paper_text)
	if target_gate.has_method("disable_gate"):
		target_gate.disable_gate()
