extends CharacterBody2D

enum {
	# Normal Mode Ststes. #
	Idling,
	Jumping,
	Landing,

	Air_Projectile,
	Ground_Projectile,

	Nuetral_Light,
	Nuetral_Air,
	Nuetral_Heavy,
	# Nuetral is a heavy input that lift the player up.
	Nuetral_Recovery,

	Side_Heavy,
	Side_Light,
	Side_Transition,
	Side_Air,
	Side_Air_Heavy,

	Down_Light,
	Down_Heavy,
	Down_Air,
	Down_Air_Heavy,


	Air_Block,
	Ground_Block,

	Dash_Run,
	Death,
	Hurt,
	Respawn,
	Left_Wall,
	Right_Wall
	}
var states = Respawn
@export var Controller: Resource
@export var Animator: AnimationPlayer
signal JumpCloud
signal DashCloud
signal WallCloud

var can_move: bool = true
var Vector: Vector2 = Vector2.ZERO
var input_buffer = []
var buffer_timer: float = 0.2
@export var Stat_Controller: Node
func _physics_process(delta: float) -> void:
	var run_speed
	Vector = Vector2(Input.get_action_strength(Controller.left) - Input.get_action_strength(Controller.right), 0).normalized()

	if Vector.x != 0 and can_move == true:
			velocity.x = move_toward(velocity.x, run_speed * Vector.x, Stat_Controller.Acceleration)

	if Animator.state == Idling:
		run_speed = Stat_Controller.Max_Speed * Stat_Controller.Speed_Rating

	if Animator.state == Jumping:
		var jump_rating: float = Stat_Controller.Speed_Rating + 0.15
		run_speed = Stat_Controller.Max_Speed * jump_rating

	if Animator.state == Dash_Run:
		var dash_rating: float = Stat_Controller.Speeed_Rating + 0.4
		run_speed = Stat_Controller.Max_Speed * dash_rating

func add_to_buffer(input_action):
	input
