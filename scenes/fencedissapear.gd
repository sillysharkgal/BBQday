extends Node3D
@onready var collision_shape: CollisionShape3D = $StaticBody3D/CollisionShape3D

func open_door() -> void:
	visible = false
	collision_shape.disabled = true
