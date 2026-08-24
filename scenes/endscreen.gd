extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
