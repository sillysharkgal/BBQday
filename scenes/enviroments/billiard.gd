extends Area3D

var dialog: Dialog_system
var is_talking: bool = false


func _ready() -> void:
	var dio := Dialog.new()
	dialog = dio.start(self)

	dialog.typewriter = true
	dialog.typewriter_speed = 25
	dialog.photo.visible = false
	dialog.npc.visible = false


func get_interact_prompt() -> String:
	return "Press E to talk"


func interact(_player: Node) -> void:
	if is_talking:
		return

	is_talking = true

	dialog.clear_blip()

	dialog.say(
		"They seem to be too locked in into their game to notice you.",
		""
	)

	dialog.action("_dialogue_finished")


func _dialogue_finished() -> void:
	is_talking = false
