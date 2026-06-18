extends CharacterBody3D

@export var speed = 10
@export var crouch_speed = 5
@export var fall_acceleration = 75
@export var jump_impulse = 20
@export var pivot: Node3D
@export var navigation_agent: NavigationAgent3D
@export var target: Node3D

var target_velocity = Vector3.ZERO
var testing: bool = false


func _ready() -> void:
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 1.0
	navigation_agent.target_desired_distance = 1.0

	# Make sure to not await during _ready.
	actor_setup.call_deferred()


func _process(_delta: float) -> void:
	navigation_agent.target_position = target.global_position


func _physics_process(_delta):
	if not target:
		return
	if navigation_agent.is_navigation_finished():
		return

	navigation_agent.target_position = target.global_position
	var current_agent_position: Vector3 = global_position
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()

	var direction: Vector3 = current_agent_position.direction_to(next_path_position)

	if direction != Vector3.ZERO:
		direction = direction.normalized()
		pivot.basis = Basis.looking_at(direction)

	var _speed: float = speed
	target_velocity.x = direction.x * _speed
	target_velocity.z = direction.z * _speed

	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration * _delta)

	velocity = target_velocity
	move_and_slide()

	#target_velocity = Vector3.ZERO


func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	set_movement_target(get_tree().get_first_node_in_group("player"))


func set_movement_target(movement_target: Node3D):
	target = movement_target


func walk(direction: Vector3):
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		pivot.basis = Basis.looking_at(direction)

	var _speed: float = speed
	target_velocity.x = direction.x * _speed
	target_velocity.z = direction.z * _speed


func move(_delta: float):
	var direction = Vector3.ZERO
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1

	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_impulse

	if direction != Vector3.ZERO:
		direction = direction.normalized()
		pivot.basis = Basis.looking_at(direction)

	var _speed: float = speed
	scale.y = 1
	if is_on_floor() and Input.is_action_pressed("crouch"):
		_speed = crouch_speed
		scale.y = 0.4
	target_velocity.x = direction.x * _speed
	target_velocity.z = direction.z * _speed
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration * _delta)
