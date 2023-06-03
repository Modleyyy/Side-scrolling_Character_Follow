extends KinematicBody2D

const SPEED : float = 400.0

const JUMP_HEIGHT : float = 500.0
const GRAVITY : float = 15.0

const PLAYER : GDScript = preload("res://Player.gd")
export(NodePath) var player_path : NodePath = NodePath("../Player")
onready var player : PLAYER = get_node(player_path)

onready var rightRays : Dictionary = {
	"wall"   : $RayFrontWallRight   ,
	"ground" : $RayFrontGroundRight ,
	}
onready var leftRays  : Dictionary = {
	"wall"   : $RayFrontWallLeft   ,
	"ground" : $RayFrontGroundLeft ,
	}

var velocity : Vector2 = Vector2.ZERO
var target : Node2D

func _physics_process(delta : float) -> void:
	velocity.y += GRAVITY
	if true:
		if   is_equal_approx(player.previous_input, +1):
			target = player.get_node("FollowPosLeft")

			if is_on_floor() && (global_position.y > target.global_position.y):
				if rightRays.wall.is_colliding() || not rightRays.ground.is_colliding():
					velocity.y -= JUMP_HEIGHT

		elif is_equal_approx(player.previous_input, -1):
			target = player.get_node("FollowPosRight")

			if is_on_floor() && (global_position.y > target.global_position.y):
				if leftRays.wall.is_colliding() || not leftRays.ground.is_colliding():
					velocity.y -= JUMP_HEIGHT

	if is_instance_valid(target):
		float_steer()

	velocity = move_and_slide(velocity, Vector2.UP)

func float_steer() -> void:
	var desired_vel : float = ( Vector2(target.global_position.x, target.global_position.x) - Vector2(global_position.x, global_position.x) ).normalized().x * SPEED
	velocity.x += (desired_vel - velocity.x) / GRAVITY


func _on_PlayerChecker_body_exited(body : Node) -> void:
	if body is PLAYER:
		global_position = player.global_position
