extends StaticBody3D

@onready var pet_sfx: AudioStreamPlayer3D = $meow
# Called when the node enters the scene tree for the first time.
func get_interact_prompt() -> String:
	return "Press E to Pet Cat"

func interact(player: Node) -> void:
	pet_sfx.play()
