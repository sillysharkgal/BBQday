extends StaticBody3D

@export var npc_name: String = "Cookbot-9000"
@export var npc_color: Color = Color.GRAY
@export_file("*.png") var npc_portrait: String
@export_file("*.wav", "*.ogg", "*.mp3") var	voice: String
@export var voice_volume_db: float = 5.0
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
	dialog.voice(voice, voice_volume_db, 1.0)
	dialog.say("Welcome to the BBQ party!", npc_name)
	dialog.action("_dialogue_finished")


	

func _dialogue_finished() -> void:
	is_talking = false
