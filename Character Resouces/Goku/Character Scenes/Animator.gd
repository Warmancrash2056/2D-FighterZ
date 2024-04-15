extends AnimationPlayer

@export var Character: CharacterBody2D
@export var Sprite: Sprite2D

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
var state = Respawn

var input_buffer = []
var buffer_time: float = 0.2

func _on_controller_attack_movement_x(Vector: Vector2) -> void:
	if Sprite.flip_h == true:
		Character.velocity.x = -Vector.x

	else:
		Character.velocity.x  = Vector.x


func _on_controller_attack_movement_y(Vector: Vector2) -> void:
	Character.velocity.y = Vector.y


