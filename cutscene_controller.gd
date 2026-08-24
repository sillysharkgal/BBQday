extends Node

@onready var camera: Camera3D = $CutsceneCamera
@onready var voice_player: AudioStreamPlayer = $VoicePlayer
@onready var subtitle_label: Label = $SubtitleUI/SubtitleLabel

var player: CharacterBody3D
var player_camera: Camera3D

func _ready() -> void:
	subtitle_label.visible = false
	voice_player.pitch_scale = 0.8

func begin_cutscene(target_player: CharacterBody3D) -> void:
	player = target_player
	player_camera = player.get_node("Head/Camera3D")

	player.set_cutscene_active(true)

	# Start cutscene camera exactly where player's camera is.
	camera.global_transform = player_camera.global_transform
	camera.make_current()

	subtitle_label.visible = false

func pan_to(target: Node3D, duration: float = 2.0) -> void:
	var tween := create_tween()

	tween.tween_property(
		camera,
		"global_transform",
		target.global_transform,
		duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	await tween.finished

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

func voice_line(text: String, audio: AudioStream) -> void:
	subtitle_label.text = text
	subtitle_label.visible = true

	voice_player.stream = audio
	voice_player.play()

	await voice_player.finished

	subtitle_label.visible = false

func end_cutscene() -> void:
	subtitle_label.visible = false
	voice_player.stop()

	player_camera.make_current()
	player.set_cutscene_active(false)
