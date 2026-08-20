extends CharacterBody3D

@export var sensitivity : float = 0.01
@export var speed : float = 5.0
@export var sprintspeed : float = 12.0
@export var jump_velocity : float = 4.5
@export var interaction_distance : float = 3.0

var pitch : float = 0.0
@onready var head: Node3D = $Head
@onready var interaction_ray : RayCast3D = $Head/Camera3D/InteractionRay
var is_being_launched : bool = false
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	add_to_group("player")
	interaction_ray.target_position = Vector3(0, 0, -interaction_distance)

func is_dialogue_open() -> bool:
	for dialogue: Node in get_tree().get_nodes_in_group("dialogue_system"):
		if dialogue.has_method("is_dialogue_active"):
			if dialogue.is_dialogue_active():
				return true
	return false

func launch_positive_z() -> void:
	is_being_launched = true
	velocity.x = 0
	velocity.z = 500
	await get_tree().create_timer(0.5).timeout
	is_being_launched = false

func is_ui_blocking_gameplay() -> bool:
	if is_dialogue_open():
		return true

	var ui: Node = get_tree().get_first_node_in_group("ui")

	if ui == null:
		return false

	if ui.has_method("is_paper_open"):
		return ui.is_paper_open()

	return false

func get_current_interactable() -> Object:
	if is_ui_blocking_gameplay():
		return null

	if not interaction_ray.is_colliding():
		return null

	var object: Object = interaction_ray.get_collider()

	if object.has_method("interact"):
		return object

	return null
	
func try_interact() -> void:
	var object: Object = get_current_interactable()

	if object == null:
		return

	object.interact(self)
	
func update_interaction_prompt() -> void:
	var ui: Node = get_tree().get_first_node_in_group("ui")
	if ui == null:
		return

	var object: Object = get_current_interactable()

	if object == null:
		ui.hide_prompt()
		return

	if object.has_method("get_interact_prompt"):
		ui.show_prompt(object.get_interact_prompt())
	else:
		ui.hide_prompt()

func teleport_to(target: Node3D) -> void:
	global_position = target.global_position
	global_rotation.y = target.global_rotation.y
	velocity = Vector3.ZERO

	head.rotation.x = 0.0

var is_in_cutscene: bool = false


func set_cutscene_active(active: bool) -> void:
	is_in_cutscene = active

	if active:
		velocity.x = 0.0
		velocity.z = 0.0

func _physics_process(delta: float) -> void:
	update_interaction_prompt()
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if is_being_launched:
		move_and_slide() 
		return
	
	if is_in_cutscene:
		velocity.x = 0.0
		velocity.z = 0.0
		move_and_slide()
		return
	
	if is_ui_blocking_gameplay():
		velocity.x = 0
		velocity.z = 0
		move_and_slide()
		return
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	if Input.is_action_just_pressed("interact"):
		if not is_ui_blocking_gameplay():
			try_interact()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
	
func _unhandled_input(event: InputEvent) -> void:
	
	if event.is_action_pressed("toggle_mouse"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		return
	if is_in_cutscene:
		return
	
	if is_ui_blocking_gameplay():
		return
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * sensitivity)
		pitch -= event.relative.y * sensitivity
		pitch = clamp(pitch, deg_to_rad(-80), deg_to_rad(80))
		head.rotation.x = pitch
