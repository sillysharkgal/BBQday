extends Area3D
@export var npc_name: String = "Bibi"
@export var npc_color: Color = Color.WHITE
@export_file("*.png") var npc_portrait: String
@export var blipsfx: AudioStream
var dialog: Dialog_system
var is_talking: bool = false


func _ready() -> void:
	var dio := Dialog.new()
	dialog = dio.start(self)

	dialog.typewriter = true
	dialog.typewriter_speed = 28



func get_interact_prompt() -> String:
	return "Press E to talk"


func interact(_player: Node) -> void:
	if is_talking:
		return
	dialog.set_blip(
		blipsfx,
		2,     # play every 2 characters
		3.0,   # volume
		0.95,  # minimum pitch
		1.00   # maximum pitch
	)

	is_talking = true

	dialog.Character(npc_name, Color.WHITE, npc_portrait)
	dialog.photo.visible = false
	dialog.say("you walked all the way here??", npc_name)
	dialog.say("you shouldve just asked me to pick you up!", npc_name)
	dialog.action("_dialogue_finished")


func _dialogue_finished() -> void:
	is_talking = false
