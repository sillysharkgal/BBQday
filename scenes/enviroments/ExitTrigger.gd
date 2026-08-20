extends Area3D

@export var puzzle_controller: Node


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node3D) -> void:
	if not body.is_in_group("player"):
		return

	if puzzle_controller != null and puzzle_controller.has_method("on_player_passed_gate"):
		puzzle_controller.on_player_passed_gate()
	else:
		print("Controller not found")
	
	# Optional: disable this trigger after it activates once
	set_deferred("monitoring", false)
