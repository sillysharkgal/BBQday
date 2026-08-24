extends Area3D

@onready var touch_sfx: AudioStreamPlayer3D = $TouchSFX
# Called when the node enters the scene tree for the first time.
func get_interact_prompt() -> String:
	return "Press E to Touch Grass"

func interact(player: Node) -> void:
	var ui: Node = get_tree().get_first_node_in_group("ui")
	if ui == null:
		print("No UI found")
		return
	touch_sfx.play()
	
	if ui.has_method("touch_grass"):
		ui.touch_grass()
	
