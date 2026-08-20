extends Area3D

@onready var bgmusic: AudioStreamPlayer = $BGMusic
@onready var birdchirp: AudioStreamPlayer = $BGMusic0
var done : bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if not body.is_in_group("player"):
		return
	
	if done:
		return
		
	done = true
	birdchirp.stop()
	bgmusic.play()
	
