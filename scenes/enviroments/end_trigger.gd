extends Area3D

@export var fly_time: float = 2.0

@export var world_environment: WorldEnvironment
@export var bgmusic2: AudioStreamPlayer

# Drag your CutsceneController node here in the Inspector
@export var cutscene_controller: Node

# The one camera destination
@onready var camera_target: Marker3D = $CameraTarget
@onready var edeeva: Sprite3D = $Edeeva

# Voice clips
@export_group("Voice Lines")
@export var voice_1: AudioStream
@export var voice_2: AudioStream
@export var voice_3: AudioStream
@export_file("*.tscn") var target_scene: String

# Subtitles
@export_group("Subtitles")
@export_multiline var subtitle_1: String = "Ah, there you are."
@export_multiline var subtitle_2: String = "The Player did not think my game was challenging enough?"
@export_multiline var subtitle_3: String = "Well then, the creator is done messing around."

var has_played: bool = false


func _ready() -> void:
	edeeva.visible = false


func _on_body_entered(body: Node3D) -> void:
	if not body.is_in_group("player"):
		return

	if has_played:
		return

	has_played = true
	set_deferred("monitoring", false)

	play_cutscene(body)


func make_dark() -> void:
	var env: Environment = world_environment.environment

	env.background_energy_multiplier = 0.1
	env.ambient_light_energy = 0.15


func play_cutscene(player: CharacterBody3D) -> void:
	# Darken the world
	make_dark()

	# Stop existing background music
	bgmusic2.stop()

	# Make Edeeva appear
	edeeva.visible = true
	var ui: Node = get_tree().get_first_node_in_group("ui")
	ui.disable_controls_guide()
	# Take control away from the player and switch cameras
	cutscene_controller.begin_cutscene(player)

	# Fly from the player's current view to CameraTarget
	await cutscene_controller.pan_to(
		camera_target,
		fly_time
	)

	# Camera has now FINISHED moving.
	# Start the three voiced subtitle lines.

	await cutscene_controller.voice_line(
		subtitle_1,
		voice_1
	)
	await cutscene_controller.wait(1.0)
	
	await cutscene_controller.voice_line(
		subtitle_2,
		voice_2
	)
	
	await cutscene_controller.wait(1.0)
		
	await cutscene_controller.voice_line(
		subtitle_3,
		voice_3
	)

	await cutscene_controller.wait(1.0)

	# Return to player's camera and controls
	get_tree().change_scene_to_file(target_scene)
