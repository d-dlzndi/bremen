extends CharacterBody3D

@export var speed = 14
@export var crouch_speed = 5
@export var fall_acceleration = 75
@export var jump_impulse = 20
@export var pivot: Node3D

var target_velocity = Vector3.ZERO


func _physics_process(_delta: float) -> void:
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

	velocity = target_velocity
	move_and_slide()
