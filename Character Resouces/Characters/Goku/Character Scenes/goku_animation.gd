extends Node

# Handle charactger animation keyframes and transitions.

@export var Character: RigidBody2D
@export var Sprite: Sprite2D
@export var Animator: AnimationPlayer
@export var Hurtbox_Collider: CollisionShape2D
@onready var Ray = $'../Raycast Controller'


enum {
	Idle,
	Forward_Step,
	Backward_Step,
	Moving_Left,
	Turning_Left,
	Moving_Right,
	Turning_Right,
	Running,
	Dash,
	Wall,
	Air,
	Ground_Block_Start_Tap,
	Ground_Block_Held,
	Ground_Block_To_Idle,
	Block_Slide,
	Air_Block_Start_Tap,
	Air_Block_Held,
	Neutral_Light,
	Neutral_Heavy,
	Neutral_Air,
	Neutral_Recovery,
	Side_Light_Start_Tap,
	Side_Light_Held_Release,
	Side_Light_Held,
	Side_Heavy_Start_Tap,
	Side_Heavy_Held_Release,
	Side_Heavy_Held,
	Side_Air_Start_Tap,
	Side_Air_Held_Release,
	Side_Air_Held,
	Down_Light_Start_Tap,
	Down_Light_Held_Release,
	Down_Light_Held,
	Down_Heavy_Start_Tap,
	Down_Heavy_Held_Release,
	Down_Heavy_Held,
	Down_Air_Start_Tap,
	Down_Air_Held_Release,
	Down_Air_Held,
	Dowm_Recovery_Start_Tap,
	Dowm_Recovery_Held_Release,
	Dowm_Recovery_Held,
	Ground_Throw_Start_Tap,
	Ground_Throw_Held_Release,
	Ground_Throw_Held,
	Air_Throw_Start_Tap,
	Air_Throw_Held_Release,
	Air_Throw_Held,
	Hurt,
	Recover,
	Respawn
}

func side_light_movement():
	if Sprite.flip_h == true:
		Character.linear_velocity.x = -5
	else:
		Character.linear_velocity.x = 5

func _neautral_recoveery():
	if Sprite.flip_h == true:
		Character.linear_velocity.y = -20
	else:
		Character.linear_velocity.y = 20

func _cancel_dash():
	if Ray.completely_on_the_floor == false:
		Animator.state = Air
