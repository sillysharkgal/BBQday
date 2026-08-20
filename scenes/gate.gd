extends Node3D
@onready var collision_shape: CollisionShape3D = $StaticBody3D/CollisionShape3D

# Called when the node enters the scene tree for the first time.
func disable_gate() -> void:
	visible = false
	collision_shape.disabled = true
