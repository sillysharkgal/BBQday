extends Area3D

@export var npc_name: String = "Miku"
@export var npc_color: Color = Color.CYAN
@export_file("*.png") var npc_portrait: String
@export_file("*.wav", "*.ogg", "*.mp3") var	voice1: String
@export_file("*.wav", "*.ogg", "*.mp3") var voice2: String
@export_file("*.wav", "*.ogg", "*.mp3") var voice3: String
@onready var sprite: Sprite3D = $Sprite3D
@onready var colshape: CollisionShape3D = $CollisionShape3D

@export var voice_volume_db: float = 10.0
var dialog: Dialog_system
var character: String
var is_talking: bool = false
var interacted: bool = false

func _ready() -> void:
	var dio := Dialog.new()
	dialog = dio.start(self)

	dialog.typewriter = true
	dialog.typewriter_speed = 25
	
	dialog.Character(npc_name, npc_color, npc_portrait)


func get_interact_prompt() -> String:
	if interacted: return ""
	return "Press E to talk"


func interact(player: Node) -> void:
	if interacted: return
	interacted = true
	var ui: Node = get_tree().get_first_node_in_group("ui")
	ui.activate_mokey()
	sprite.visible = false
	colshape.visible = false	
