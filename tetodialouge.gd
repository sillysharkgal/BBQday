extends Area3D

@export var npc_name: String = "Teto"
@export var npc_color: Color = Color.PALE_VIOLET_RED
@export_file("*.png") var npc_portrait: String = "res://addons/dialog_system/placeholder.png"
@export_file("*.png") var normal_image: String
@export_file("*.png") var happy_image: String
@export_file("*.png") var scared_image: String
@export_file("*.png") var mad_image: String
@export_file("*.wav", "*.ogg", "*.mp3") var	voice1: String
@export_file("*.wav", "*.ogg", "*.mp3") var voice2: String
@export_file("*.wav", "*.ogg", "*.mp3") var voice3: String
@export_file("*.wav", "*.ogg", "*.mp3") var voice4: String
@export_file("*.wav", "*.ogg", "*.mp3") var voice5: String
@export_file("*.wav", "*.ogg", "*.mp3") var voice6: String
@export_file("*.wav", "*.ogg", "*.mp3") var voice7: String
@export_file("*.wav", "*.ogg", "*.mp3") var voice8: String
@export_file("*.wav", "*.ogg", "*.mp3") var voice9: String
@export_file("*.wav", "*.ogg", "*.mp3") var voice10: String
@export_file("*.wav", "*.ogg", "*.mp3") var voice11: String
@export_file("*.wav", "*.ogg", "*.mp3") var voice12: String
@export var voice_volume_db: float = 10.0
@export var jail: Node3D
var dialog: Dialog_system
var character: String
var is_talking: bool = false
var talked_before: bool = false

func _ready() -> void:
	var dio := Dialog.new()
	dialog = dio.start(self)

	dialog.typewriter = true
	dialog.typewriter_speed = 25
	
	dialog.Character(npc_name, Color.WHITE, normal_image)


func get_interact_prompt() -> String:
	return "Press E to talk"


func interact(player: Node) -> void:
	if is_talking:
		return

	talk()

func talk() -> void:
	is_talking = true
	dialog.clear_blip()
	if jail.state == jail.JailState.RELEASED:
		released_dialouge()
	elif (!talked_before):
		dialog.Character(npc_name, Color.WHITE, normal_image)
		dialog.voice(voice1, voice_volume_db, 1.0)
		dialog.say("So, you thought it would be funny to doom someone falling forever in a bottomless pit.", npc_name)
		dialog.Character(npc_name, Color.WHITE, mad_image)
		dialog.voice(voice2, voice_volume_db, 1.0)
		dialog.say("Guess what, smartass, actions have consequences", npc_name)
		dialog.Character(npc_name, Color.WHITE, mad_image)
		dialog.voice(voice3, voice_volume_db, 1.0)
		dialog.say("You deserve to be in jail twice as long as your sentence!", npc_name)
		talked_before = true
	else:
		print("SECOND DIALOGUE STARTED")
		dialog.Character(npc_name, Color.WHITE, normal_image)
		dialog.voice(voice4, voice_volume_db, 1.0)
		dialog.say("What's the matter? 50 minutes is too long?", npc_name)
		dialog.voice(voice5, voice_volume_db, 1.0)
		dialog.say("Like it says on the wall, \"can't do the time.... don't do the crime!\"", npc_name)
		#dialog.Character(npc_name, Color.WHITE, normal_image)
		dialog.voice(voice6, voice_volume_db, 1.0)
		dialog.say("And another thing....", npc_name)
		dialog.Character(npc_name, Color.WHITE, mad_image)
		dialog.voice(voice7, voice_volume_db, 1.0)
		dialog.say("hey.......wait...", npc_name)
		dialog.Character(npc_name, Color.WHITE, normal_image)
		dialog.voice(voice8, voice_volume_db, 1.0)
		dialog.say("You're Edeeva's friend?", npc_name)
		dialog.Character(npc_name, Color.WHITE, scared_image)
		dialog.voice(voice9, voice_volume_db, 1.0)
		dialog.say("Oh dang.... Oh Shit.... I didn't know", npc_name)
		dialog.Character(npc_name, Color.WHITE, happy_image)
		dialog.voice(voice10, voice_volume_db, 1.0)
		dialog.action("free_the_player")
		dialog.say("Ok, you've been released!", npc_name)
		dialog.Character(npc_name, Color.WHITE, normal_image)
		dialog.voice(voice11, voice_volume_db, 1.0)
		dialog.say("I am sorry to inconvenience you! Please don't let Edeeva delete me", npc_name)
		dialog.Character(npc_name, Color.WHITE, happy_image)
		dialog.voice(voice12, voice_volume_db, 1.0)
		dialog.say("Sentence fulfilled, you're free to go!", npc_name)
	dialog.action("_dialogue_finished")

func free_the_player() -> void:
	jail.release_player()

func released_dialouge() -> void:
	dialog.Character(npc_name, Color.WHITE, happy_image)
	dialog.voice(voice12, voice_volume_db, 1.0)
	dialog.say("Sentence fulfilled, you're free to go!", npc_name)
	

func _dialogue_finished() -> void:
	is_talking = false
