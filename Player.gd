extends KinematicBody2D


const SPEED : float = 400.0
const ACCEL : float = 50.0

const JUMP_HEIGHT : float = 500.0
const JUMP_CANCEL : float = 100.0
const GRAVITY : float = 15.0

var input_x : float = 0.0
var previous_input : float = input_x

var velocity : Vector2 = Vector2.ZERO

func _physics_process(_delta : float) -> void:
	velocity.y += GRAVITY

	if not is_zero_approx(input_x): previous_input = input_x

	input_x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.x = move_toward(velocity.x, SPEED * input_x, ACCEL)

	if is_on_floor() && Input.is_action_just_pressed("ui_up"):
		velocity.y = -JUMP_HEIGHT
	if not is_on_floor() && Input.is_action_just_released("ui_up") && velocity.y < -JUMP_CANCEL:
		velocity.y = -JUMP_CANCEL

	velocity = move_and_slide(velocity, Vector2.UP)
