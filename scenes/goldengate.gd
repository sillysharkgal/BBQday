extends Node3D
@onready var collision_shape: CollisionShape3D = $StaticBody3D/CollisionShape3D
@onready var gate_open_sfx: AudioStreamPlayer3D = $GateOpenSFX
# Called when the node enters the scene tree for the first time.
func open_gate() -> void:
	visible = false
	collision_shape.disabled = true
	gate_open_sfx.play()
