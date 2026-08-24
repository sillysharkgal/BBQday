extends Area3D
@onready var finish_sfx: AudioStreamPlayer3D = $FinishSFX
@export var bgmusic: AudioStreamPlayer
@export var bgmusic2: AudioStreamPlayer
func _on_body_entered(body: Node3D) -> void:
	if not body.is_in_group("player"):
		return
	

	set_deferred("monitoring", false)
	var ui: Node = get_tree().get_first_node_in_group("ui")
	ui.you_lose()
	finish_sfx.play()
	bgmusic.stop()
	bgmusic2.play()
	
