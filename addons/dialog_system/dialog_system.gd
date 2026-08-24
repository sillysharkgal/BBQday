extends CanvasLayer

class_name  Dialog_system
#NPC Dialog imports
@onready var npc: Label = %npc_name
@onready var convo: RichTextLabel = %convo
@onready var photo: TextureRect = %photo
@onready var next_convo: Button = $VBoxContainer/Convo_Box/Control/HBoxContainer/next_convo
@onready var bg_obj: TextureRect = %bg
@onready var sound_tool: AudioStreamPlayer = %sound

# Blip settings used for future say() calls.
var blip_stream: AudioStream = null
var blip_every_chars: int = 2
var blip_volume_db: float = 0.0
var blip_pitch_min: float = 0.95
var blip_pitch_max: float = 1.05

# Blip settings for the currently displayed line.
var _line_blip_stream: AudioStream = null
var _line_blip_every_chars: int = 2
var _line_blip_volume_db: float = 0.0
var _line_blip_pitch_min: float = 0.95
var _line_blip_pitch_max: float = 1.05
var _last_blip_character: int = 0

var _blip_player: AudioStreamPlayer

@onready var menu_object=preload("res://addons/dialog_system/menu.tscn")
@onready var input_object=preload("res://addons/dialog_system/input.tscn")
signal input_received(value)
signal talking(value)
var paused:=false
var current_tween: Tween
var start:=false
var dialog_output:=[]:
	set(value):
		dialog_output=value
		start_convo()
var Characters:={
	"default":{
		"color":Color.WHITE,
		"image":"res://addons/dialog_system/placeholder.png"}
}
var typewriter_speed:=30
var typewriter:=true
#backward compatibility
var text:="":
	set(value):
		text=value
		old_text(value)
#usable varibles 
var npc_name:="":
	set(value):
		npc_name=value
		changed_NPC_name(value)

var image:="":
	set(value):
		image=value
		change_image(value)
		

func _ready() -> void:
	add_to_group("dialogue_system")

	start = true
	npc.text = npc_name

	_blip_player = AudioStreamPlayer.new()
	add_child(_blip_player)

	hide()

func is_dialogue_active() -> bool:
	return visible

func set_blip(
	stream: AudioStream,
	every_chars: int = 2,
	volume_db: float = 0.0,
	pitch_min: float = 0.95,
	pitch_max: float = 1.05
) -> void:
	blip_stream = stream
	blip_every_chars = maxi(every_chars, 1)
	blip_volume_db = volume_db
	blip_pitch_min = pitch_min
	blip_pitch_max = pitch_max


func clear_blip() -> void:
	blip_stream = null

func start_convo():
	if not paused:
		start=false
		proceed()

func add_dialog(type,line):
	if start:
		dialog_output=[{type:line}]
	else:
		dialog_output.append({type:line})

func changed_NPC_name(value):
	if Characters.size()<2:
		Character(value)
	add_dialog("npc_name",{"name":value})
	
func _update_typewriter(value: float) -> void:
	var visible_count: int = int(value)
	convo.visible_characters = visible_count

	# No blip assigned means this is a normal or voiced line.
	if _line_blip_stream == null:
		return

	if visible_count <= 0:
		return

	if visible_count - _last_blip_character < _line_blip_every_chars:
		return

	_last_blip_character = visible_count

	var character_index: int = min(
		visible_count - 1,
		convo.text.length() - 1
	)

	if character_index < 0:
		return

	var current_character: String = convo.text.substr(character_index, 1)

	# Don't beep on whitespace.
	if current_character == " " \
	or current_character == "\n" \
	or current_character == "\t":
		return

	_blip_player.stream = _line_blip_stream
	_blip_player.volume_db = _line_blip_volume_db
	_blip_player.pitch_scale = randf_range(
		_line_blip_pitch_min,
		_line_blip_pitch_max
	)
	_blip_player.play()	
		

func change_image(value):
	add_dialog("image",{"image":value})
#Usable functions

func Character(NPC_NAME:String,color:Color=Color.WHITE,image_avatar:String ="res://addons/dialog_system/placeholder.png")->String:
	Characters[NPC_NAME]={
		"color":color,
		"image":image_avatar
	}
	return NPC_NAME
func bg(url:String):
	add_dialog("bg",{"bg":url})

func voice(url:String,volume_dB:float=0,pitch_scale:float=1):
	add_dialog("voice",{
		"url":url,
		"volume_dB":volume_dB,
		"pitch_scale":pitch_scale,
	})
#old text style (backward compatiblity):
func old_text(value):
	add_dialog("text",{
	"text": value,
	"typewriter": typewriter,
	"speed": typewriter_speed,
	})
	
func say(
	text: String,
	NPC_name: String = npc_name,
	typewriter: bool = typewriter,
	speed: float = typewriter_speed
) -> void:
	var current_npc := ""

	if NPC_name == "":
		current_npc = "default"
	else:
		current_npc = NPC_name

	changed_NPC_name(NPC_name)
	avatar(Characters[current_npc]["image"])

	add_dialog("text", {
		"text": text,
		"typewriter": typewriter,
		"speed": speed,

		# Save the current blip settings into this specific line.
		"blip_stream": blip_stream,
		"blip_every_chars": blip_every_chars,
		"blip_volume_db": blip_volume_db,
		"blip_pitch_min": blip_pitch_min,
		"blip_pitch_max": blip_pitch_max,
	})

func avatar(value):
	if image.length()<1:
		add_dialog("image",{"image":value})
		
var user_input:=""
#Input 
func input(question:String,userInput:String=""):
	add_dialog("input",{
	"question": question,
	})
	await input_received
	next_convo.disabled=false
	
	return user_input
	
func menu(question:String, choices:Dictionary):
	add_dialog("menu",{
	"question": question,
	"choices": choices,
	})	

func action(function_name):
	add_dialog("action", function_name)
		
func process_npc_name(key):
	npc.text=key["npc_name"]["name"]
	set_Char(key["npc_name"]["name"])
	move_on(key)
	
	
func process_image(key):
	photo.texture=load(key["image"]["image"])
	move_on(key)

func process_bg(key):
	bg_obj.texture=load(key["bg"]["bg"])
	move_on(key)

func process_voice(key):
	sound_tool.stream=load(key["voice"]["url"])
	sound_tool.volume_db=key["voice"]["volume_dB"]
	sound_tool.pitch_scale=key["voice"]["pitch_scale"]
	sound_tool.play()
	move_on(key)
#text	
func process_text(key) -> void:
	convo.text = key["text"]["text"]
	convo.visible_characters = -1

	_line_blip_stream = key["text"].get("blip_stream", null)
	_line_blip_every_chars = maxi(
		int(key["text"].get("blip_every_chars", 2)),
		1
	)
	_line_blip_volume_db = float(
		key["text"].get("blip_volume_db", 0.0)
	)
	_line_blip_pitch_min = float(
		key["text"].get("blip_pitch_min", 0.95)
	)
	_line_blip_pitch_max = float(
		key["text"].get("blip_pitch_max", 1.05)
	)
	_last_blip_character = 0

	if current_tween != null and current_tween.is_valid():
		current_tween.kill()

	if key["text"]["typewriter"]:
		var total_characters: int = convo.get_total_character_count()
		var text_speed: float = max(float(key["text"]["speed"]), 1.0)
		var duration: float = float(total_characters) / text_speed

		convo.visible_characters = 0

		current_tween = create_tween()
		current_tween.tween_method(
			_update_typewriter,
			0.0,
			float(total_characters),
			duration
		)
	
func process_input(key):
	var input_inst:Dailog_Input=input_object.instantiate()
	input_inst.user_input_changed.connect(_on_user_input_change)
	add_child(input_inst)
	input_inst.show()
	input_inst.input_Q=key["input"]["question"]

func _on_user_input_change(value):
	user_input=value
	input_received.emit(value)

func process_menu(key):
	var choices={"question":key["menu"]["question"],"choices":key["menu"]["choices"]}
	var menu_inst=menu_object.instantiate()
	menu_inst.choices=choices
	add_child(menu_inst)
	menu_inst.show()
	
func process_action(key):
	get_parent().call(key["action"])
	move_on(key)
	
func proceed():
	if not paused:
		show()
		if dialog_output.size()>0:
			talking.emit(self)
			var key = dialog_output[0]
			var type=key.keys()[0]
			dialog_output.remove_at(0)
			match type:
				"text":
					process_text(key)
				"input":
					process_input(key)
					next_convo.disabled=true
				"menu":
					process_menu(key)
					next_convo.disabled=true
				"image":
					process_image(key)
				"bg":
					process_bg(key)
				"voice":
					process_voice(key)
				"npc_name":
					process_npc_name(key)
				"action":
					process_action(key)

			if dialog_output.size()==1:
				start=true
		else:
			hide()
			start=true
		
func _input(event: InputEvent) -> void:
	if not visible:
		return

	# Menus and text-input questions need normal UI clicking.
	if next_convo.disabled:
		return

	if (
		event is InputEventMouseButton
		and event.button_index == MOUSE_BUTTON_LEFT
		and event.pressed
	):
		_on_next_convo_pressed()
		get_viewport().set_input_as_handled()

func _on_next_convo_pressed() -> void:
	var total_characters: int = convo.get_total_character_count()

	# Text is still typing: reveal the whole current line.
	if (
		convo.visible_characters >= 0
		and convo.visible_characters < total_characters
	):
		if current_tween != null and current_tween.is_valid():
			current_tween.kill()

		convo.visible_characters = -1
		return

	# Text is already complete: continue to the next command.
	proceed()

func force_end() -> void:
	if current_tween != null and current_tween.is_valid():
		current_tween.kill()

	current_tween = null
	dialog_output.clear()

	convo.visible_characters = -1
	next_convo.disabled = false

	clear_blip()

	if _blip_player != null:
		_blip_player.stop()

	sound_tool.stop()

	hide()
	start = true
	paused = false

func move_on(key):
	proceed()
func set_Char(NPC_NAME):
	var current_npc=""
	if NPC_NAME=="":
		current_npc="default"
	else :
		current_npc=NPC_NAME	
	convo.add_theme_color_override("default_color",Characters[current_npc]["color"])
	npc.add_theme_color_override("font_color",Characters[current_npc]["color"])	
