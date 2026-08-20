extends Area3D


@export_file("*.tscn") var target_scene: String

func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node3D) -> void:
	if not body.is_in_group("player"):
		return
		
	if target_scene == "":
		print("No target scene assigned.")
		return

	get_tree().change_scene_to_file(target_scene)
		
