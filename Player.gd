extends KinematicBody2D

export (float) var MovementSpeed = 120
export (float) var JumpHeight = 900
export (float) var Gravity = 35
export (float) var ForceKnockback = 5
export (float) var Friction = 300


onready var Animate = $AnimationPlayer
onready var SpriteSheet = $Sprite
onready var CheckFloor = $"Is On Floor Cast"
onready var HitBox = $HitBox/CollisionShape2D
onready var col_position = $Position2D

var DirectionFacing = 1

var Motion = Vector2.ZERO
var Up = Vector2.UP

enum StateList {
	Nlight,
	Slight,
	Dlight,
	Ulight,
	Nair,
	Idle,
	Jump,
	Fall,
	Block,
	Dash,
	Nsig,
	Ssig,
	Dsig,
	Hurt,
	Respwan
}

var SelectState = StateList.Idle
func _apply_gravity_():
	Motion.y += Gravity
func _physics_process(delta):
	Motion = move_and_slide(Motion, Up)
	
	match SelectState:
		StateList.Idle:
			_apply_gravity_()
			if Input.is_action_pressed("Right"):
				Animate.play("Run")
				Motion.x = MovementSpeed
				col_position.scale.x *= 1
				SpriteSheet.flip_h = false
				
				if Input.is_action_just_released("Attack"):
					SelectState = StateList.Slight
					
					yield(Animate, "animation_finished")
					SelectState = StateList.Idle
					
			elif Input.is_action_pressed("Left"):
				Animate.play("Run")
				Motion.x = -MovementSpeed
				SpriteSheet.flip_h = true
				col_position.scale.x *= -1
				
				if Input.is_action_just_released("Attack"):
					SelectState = StateList.Slight
					
					yield(Animate, "animation_finished")
					SelectState = StateList.Idle
				
			else:
				Animate.play("Idle")
				Motion.x = 0
				
		StateList.Nlight:
			pass
			
		StateList.Slight:
			Animate.play("Side Light")
			
		StateList.Dlight:
			pass
			
		StateList.Ulight:
			pass
				



func _on_AnimationPlayer_animation_finished(anim_name):
	if Animate.current_animation == "Run":
		print("Hello World")
