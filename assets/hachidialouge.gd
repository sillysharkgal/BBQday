extends RigidBody3D

@export var npc_name: String = "Hachiware"
@export var npc_color: Color = Color.WHITE
@export_file("*.png") var npc_portrait: String = "res://addons/dialog_system/placeholder.png"

@export_file("*.png") var normal_image: String
@export_file("*.png") var happy_image: String
@export_file("*.png") var scared_image: String
var dialog: Dialog_system
var character: String
var is_talking: bool = false
@export var hole_target: Node3D
@export var launch_strength: float = 10.0
@export var launch_up_strength: float = 4.0
@export var hachiwari_blip: AudioStream
@export var jail_spawn: Marker3D
@export var jail: Node3D
var can_interact: bool = true
var launched: bool = false


func _ready() -> void:
	var dio := Dialog.new()
	dialog = dio.start(self)

	dialog.typewriter = true
	dialog.typewriter_speed = 25
	
	dialog.Character(npc_name, Color.WHITE, normal_image)


func get_interact_prompt() -> String:
	if not can_interact:
		return ""
	return "Press E to talk"


func interact(player: Node) -> void:
	if not can_interact:
		return
	if is_talking:
		return

	talk()
	
func launch_into_hole() -> void:
	if launched:
		return

	if hole_target == null:
		print("No hole target assigned.")
		return

	launched = true
	can_interact = false

	freeze = false
	sleeping = false

	var direction: Vector3 = hole_target.global_position - global_position
	direction.y = 0
	direction = direction.normalized()

	var impulse: Vector3 = direction * launch_strength
	impulse += Vector3.UP * launch_up_strength

	apply_central_impulse(impulse)

func talk() -> void:
	is_talking = true

	dialog.set_blip(
		hachiwari_blip,
		2,     # play every 2 characters
		3.0,   # volume
		0.95,  # minimum pitch
		1.08   # maximum pitch
	)

	
	dialog.Character(npc_name, Color.WHITE, normal_image)
	dialog.say("Whoa! It’s so dark down there!", npc_name)
	dialog.Character(npc_name, Color.WHITE, normal_image)
	dialog.say("Huh? It doesn’t have a bottom!?", npc_name)
	dialog.Character(npc_name, Color.WHITE, happy_image)
	dialog.say("That’s kinda scary… but also kinda amazing!", npc_name)
	dialog.Character(npc_name, Color.WHITE, normal_image)
	dialog.say("Hehe… I hope nobody drops their keys in there.", npc_name)
	dialog.Character(npc_name, Color.WHITE, normal_image)
	dialog.say("They’d just keep falling… and falling… forever…", npc_name)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	dialog.menu("Push Him?", {
		"Yes": "_choice_yes",
		"No": "_choice_no",
	})

func _choice_yes() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	launch_into_hole()
	can_interact = false
	dialog.Character(npc_name, Color.WHITE, scared_image)
	dialog.say("Eh!? W-Wait!!", npc_name, true, 200.0)
	await get_tree().create_timer(1.0).timeout
	dialog.force_end()
	_dialogue_finished()
	await get_tree().create_timer(5.0).timeout
	var player: Node = get_tree().get_first_node_in_group("player")
	player.teleport_to(jail_spawn)
	jail.start_sentence()
	
func _choice_no() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	dialog.clear_blip()
	dialog.action("_dialogue_finished")

func _dialogue_finished() -> void:
	is_talking = false
