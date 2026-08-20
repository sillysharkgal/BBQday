extends Control

@export_file("*.tscn") var main_scene: String

@export var fall_duration: float = 0.5
@export var delay_between_letters: float = 0.12
@export var start_height: float = -150.0
@onready var start_sfx: AudioStreamPlayer = $animationsfx
@onready var letters: Array[Control] = [
	$E1,
	$D1,
	$E2,
	$E3,
	$V,
	$A,
	$D2,
	$E4,
	$V2
]

const _DIALOG_CLASS = preload(
	"res://addons/dialog_system/dialog.gd"
)

const _DIALOG_SYSTEM_SCENE = preload(
	"res://addons/dialog_system/dialog_System.tscn"
)

const _DIALOG_INPUT_SCENE = preload(
	"res://addons/dialog_system/input.tscn"
)

const _DIALOG_MENU_SCENE = preload(
	"res://addons/dialog_system/menu.tscn"
)
			

func _ready() -> void:
	$Background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	
	start_sfx.play()
	
	await get_tree().create_timer(0.5).timeout
	await play_title_animation()
	await get_tree().create_timer(1.0).timeout

	get_tree().change_scene_to_file(main_scene)


func play_title_animation() -> void:
	# Remember where every letter is supposed to end.
	var target_positions: Array[Vector2] = []

	for letter in letters:
		target_positions.append(letter.position)

		# Start above the screen.
		letter.visible = true
		letter.position.y = start_height

	# Drop them one by one.
	for i in range(letters.size()):
		var letter: Control = letters[i]

		var tween := create_tween()

		tween.tween_property(
			letter,
			"position",
			target_positions[i],
			fall_duration
		).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

		# Don't wait for the entire fall before starting the next letter.
		await get_tree().create_timer(delay_between_letters).timeout

	# Wait until the LAST letter actually finishes falling.
	await get_tree().create_timer(fall_duration).timeout
