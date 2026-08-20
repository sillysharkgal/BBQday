extends Area3D
@export var player: Node3D

# Called when the node enters the scene tree for the first time.
func _on_body_entered(body: Node3D) -> void:
	print("Something entered: ", body.name)

	if not body.is_in_group("player"):
		return

	print("PLAYER ENTERED LAUNCH ZONE")
	body.launch_positive_z()
