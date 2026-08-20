extends StaticBody3D

@export var button_id: int = 0
@export var puzzle_controller: Node
@onready var button_press_sfx: AudioStreamPlayer3D = $PressSFX
@export var prompt_text: String = "Press E to press button"
var activated: bool = false

func get_interact_prompt() -> String:
	if activated:
		return "Button already pressed"

	return prompt_text

func interact(player: Node) -> void:
	if activated:
		return
	
	activated = true
	button_press_sfx.play()
	print("Pressed button ", button_id)

	if puzzle_controller != null and puzzle_controller.has_method("activate_button"):
		puzzle_controller.activate_button(button_id)
