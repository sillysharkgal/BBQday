extends CanvasLayer

@onready var paper_view: Control = $HUDRoot/PaperView
@onready var title_label: Label = $HUDRoot/PaperView/MarginContainer/VBoxContainer/TitleLabel
@onready var body_label: Label = $HUDRoot/PaperView/MarginContainer/VBoxContainer/BodyLabel
@onready var interaction_prompt: Control = $HUDRoot/InteractionPrompt
@onready var prompt_label: Label = $HUDRoot/InteractionPrompt/Label
@onready var controls_label: Panel = $HUDRoot/Controls
@onready var grass_label: Label = $HUDRoot/Grass
@onready var lose_label: Label = $HUDRoot/Lose
@onready var button_indicators: Array[Control] = [
	$HUDRoot/MarginContainer/VBoxContainer/Pink,
	$HUDRoot/MarginContainer/VBoxContainer/Blue,
	$HUDRoot/MarginContainer/VBoxContainer/Orange,
	$HUDRoot/MarginContainer/VBoxContainer/Red
]
@onready var dialabel1: Label = $HUDRoot/TurnOFF/Label1
@onready var dialabel2: Label = $HUDRoot/TurnOFF/Label2
@onready var dialabel3: Label = $HUDRoot/TurnOFF/Label3
@onready var dialabel4: Label = $HUDRoot/TurnOFF/Label4
@onready var dialabel5: Label = $HUDRoot/TurnOFF/Label5
@onready var dialabel6: Label = $HUDRoot/DialogueOFF
@onready var ohboi: AudioStreamPlayer = $ohboi
@onready var screaming: AudioStreamPlayer = $screams

var paper_open: bool = false


func _ready() -> void:
	add_to_group("ui")
	paper_view.visible = false
	interaction_prompt.visible = false
	paper_open = false
	grass_label.visible = false
	lose_label.visible = false
	dialabel1.visible = false
	dialabel2.visible = false
	dialabel3.visible = false
	dialabel4.visible = false
	dialabel5.visible = false
	dialabel6.visible = false
	for indicator in button_indicators:
		indicator.visible = false


func show_prompt(text: String) -> void:
	prompt_label.text = text
	interaction_prompt.visible = true


func hide_prompt() -> void:
	interaction_prompt.visible = false

func set_button_indicator(button_id: int, active: bool) -> void:
	if button_id < 0 or button_id >= button_indicators.size():
		return

	button_indicators[button_id].visible = active


func clear_button_indicators() -> void:
	for indicator in button_indicators:
		indicator.visible = false

func show_paper(title: String, body: String) -> void:
	title_label.text = title
	body_label.text = body
	paper_view.visible = true
	paper_open = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func hide_paper() -> void:
	paper_view.visible = false
	paper_open = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func is_paper_open() -> bool:
	return paper_open

var lose_message_token: int = 0

func you_lose() -> void:
	lose_message_token += 1
	var current_token: int = lose_message_token

	lose_label.visible = true
	await get_tree().create_timer(8.0).timeout

	if current_token == lose_message_token:
		lose_label.visible = false
	

var grass_message_token: int = 0

func disable_controls_guide() ->void:
	controls_label.visible = false
	

func touch_grass() -> void:
	grass_message_token += 1
	var current_token: int = grass_message_token

	grass_label.visible = true
	await get_tree().create_timer(1.0).timeout

	if current_token == grass_message_token:
		grass_label.visible = false

var current_mokey_phase: int = 0

func activate_mokey() -> void:
	ohboi.play()
	await ohboi.finished
	screaming.play()
	dialabel1.visible = true
	current_mokey_phase = 1

func activate_mokey2() -> void:
	current_mokey_phase = 2
	await get_tree().create_timer(1.5).timeout
	current_mokey_phase = 3
	dialabel2.visible = true
	
func activate_mokey3() -> void:
	current_mokey_phase = 4
	await get_tree().create_timer(1.0).timeout
	current_mokey_phase = 5
	dialabel3.visible = true

func activate_mokey4() -> void:
	current_mokey_phase = 6
	await  get_tree().create_timer(0.5).timeout
	current_mokey_phase = 7
	dialabel4.visible = true
	
func activate_mokey5() -> void:
	current_mokey_phase = 8
	await get_tree().create_timer(0.5).timeout
	current_mokey_phase = 9
	dialabel5.visible = true

var jbuttons : int = 0

func activate_mokey6() -> void:
	current_mokey_phase = 10
	dialabel1.visible = false
	dialabel2.visible = false
	dialabel3.visible = false
	dialabel4.visible = false
	dialabel5.visible = false
	dialabel6.visible = true
	screaming.stop()
	await get_tree().create_timer(5.0).timeout
	dialabel6.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if paper_open and (
		event.is_action_pressed("interact") or event.is_action_pressed("ui_cancel")
	):
		hide_paper()
		get_viewport().set_input_as_handled()
		
	if current_mokey_phase == 1 and event.is_action_pressed("r_button"):
		activate_mokey2()
		get_viewport().set_input_as_handled()
	
	if current_mokey_phase == 3 and event.is_action_pressed("b_button"):
		activate_mokey3()
		get_viewport().set_input_as_handled()
		
	if current_mokey_phase == 5 and event.is_action_pressed("v_button"):
		activate_mokey4()
		get_viewport().set_input_as_handled()
		
	if current_mokey_phase == 7 and event.is_action_pressed("v_button"):
		activate_mokey5()
		get_viewport().set_input_as_handled()
		
	if current_mokey_phase == 9 and event.is_action_pressed("v_button"):
		jbuttons += 1
		if (jbuttons >= 6):
			activate_mokey6()
		get_viewport().set_input_as_handled()
