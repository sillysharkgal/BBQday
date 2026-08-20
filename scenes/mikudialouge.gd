extends Area3D

@export var npc_name: String = "Miku"
@export var npc_color: Color = Color.CYAN
@export_file("*.png") var npc_portrait: String
@export_file("*.wav", "*.ogg", "*.mp3") var	voice1: String
@export_file("*.wav", "*.ogg", "*.mp3") var voice2: String
@export_file("*.wav", "*.ogg", "*.mp3") var voice3: String
@export var voice_volume_db: float = 10.0
var dialog: Dialog_system
var character: String
var is_talking: bool = false

func _ready() -> void:
	var dio := Dialog.new()
	dialog = dio.start(self)

	dialog.typewriter = true
	dialog.typewriter_speed = 25
	
	dialog.Character(npc_name, npc_color, npc_portrait)


func get_interact_prompt() -> String:
	return "Press E to talk"


func interact(player: Node) -> void:
	if is_talking:
		return

	talk()

func talk() -> void:
	is_talking = true
	dialog.clear_blip()
	dialog.photo.visible = false

	dialog.voice(voice1, voice_volume_db, 1.0)
	dialog.say("You Made it to the BBQ party!", npc_name)
	dialog.voice(voice2, voice_volume_db, 1.0)
	dialog.say("You should go rest and relax here first", npc_name)
	dialog.voice(voice3, voice_volume_db, 1.0)
	dialog.say("I think Edeeva is waiting for you behind the house next to me...", npc_name)
	dialog.action("_dialogue_finished")


	

func _dialogue_finished() -> void:
	is_talking = false
