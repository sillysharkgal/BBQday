extends Node3D	

enum JailState {
	CLOSED,
	SERVING,
	RELEASED
}


@export var sentence_length: float = 3000.0 # 50 minutes
@export var door: Node3D
@export var fencedoor: Node3D
@export var sentence_label: Label3D

@onready var release_timer: Timer = $ReleaseTimer

var state: JailState = JailState.CLOSED


func _ready() -> void:
	release_timer.one_shot = true
	release_timer.timeout.connect(release_player)

	set_state(JailState.CLOSED)


func set_state(new_state: JailState) -> void:
	state = new_state

	match state:
		JailState.CLOSED:
			sentence_label.visible = false

		JailState.SERVING:
			sentence_label.visible = true

		JailState.RELEASED:
			sentence_label.visible = false

# Called when the node enters the scene tree for the first time.

func start_sentence() -> void:
	set_state(JailState.SERVING)


	release_timer.start(sentence_length)

func release_player() -> void:
	if state == JailState.RELEASED:
		return

	set_state(JailState.RELEASED)

	release_timer.stop()

	if door.has_method("open_door"):
		door.open_door()
	if fencedoor.has_method("open_door"):
		fencedoor.open_door()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if state != JailState.SERVING:
		return

	var remaining: int = ceil(release_timer.time_left)

	var minutes: int = remaining / 60
	var seconds: int = remaining % 60

	sentence_label.text = "%d:%02d" % [
		minutes,
		seconds
	]
