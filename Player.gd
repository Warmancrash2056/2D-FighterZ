extends KinematicBody2D

export (float) var MovementSpeed = 120
export (float) var JumpHeight = 900
export (float) var Gravity = 35
export (float) var ForceKnockback = 5
export (float) var Friction = 300

var AttackPoints = 1
var Dodge = 1
onready var Animate = $AnimatedSprite
onready var CheckFloor = $"Is On Floor Cast"
onready var AttackTimer = $"Attack Timer"

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
	Move,
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
			print("Idle")
			_apply_gravity_()
			if !is_on_floor():
				SelectState = StateList.Fall
				Animate.play("Fall")
				
			Motion.x = 0
			if Input.is_action_pressed("Left"):
				Motion.x = -MovementSpeed
				Animate.play("Run")
				Animate.flip_h = true
				DirectionFacing = -1
				
				if Input.is_action_just_pressed("Attack") && AttackPoints == 1:
					SelectState = StateList.Slight
					AttackTimer.start()
					
					
			elif Input.is_action_pressed("Right"):
				Motion.x = MovementSpeed
				Animate.play("Run")
				Animate.flip_h = false
				DirectionFacing = 1
				
				if Input.is_action_just_pressed("Attack") && AttackPoints == 1 :
					SelectState = StateList.Slight
					AttackTimer.start()
					
			elif Input.is_action_pressed("Up"):
				
				if Input.is_action_just_pressed("Attack"):
					SelectState = StateList.Ulight
					
			elif Input.is_action_pressed("Down"):
				$AnimationPlayer.play("Disable ")
				
				if Input.is_action_just_pressed("Attack"):
					SelectState = StateList.Dlight
			
			else:
				Motion.x = 0
				Animate.play("Idle")
				
				if Input.is_action_just_pressed("Attack"):
					SelectState = StateList.Nlight
					
					
				
			if Input.is_action_just_pressed("Jump"):
				SelectState = StateList.Jump
				
			if Input.is_action_just_pressed("Dash"):
				SelectState = StateList.Dash
				Motion.x = 0
				
		StateList.Jump:
			_apply_gravity_()
			if is_on_floor():
				Motion.y = -JumpHeight
				
			if Motion.y < 0:
				Animate.play("Jump")
				
			else:
				SelectState = StateList.Fall
			
			if Input.is_action_just_pressed("Attack"):
				SelectState = StateList.Nair
				
		StateList.Fall:
			_apply_gravity_()
			Animate.play("Fall")
			
			if is_on_floor():
				SelectState = StateList.Idle
				Animate.play("Idle")

		StateList.Ulight:
			Animate.play("Up Light")
			
		StateList.Nlight:
			Animate.play("Nuetral Light")
			$AnimationPlayer.play("Nuetral Light")
			
		StateList.Slight:
			Motion.x = 0
			Animate.play("Side Light")
			
		StateList.Dlight:
			Animate.play("Down Light")
			
		StateList.Nair:
			Motion.y = 0
			Animate.play("Nuetral Air")
			$AnimationPlayer.play("Nuetral Air")
			
		StateList.Dash:
			_apply_gravity_()
			Animate.play("Dodge Phase")
			
			if Input.is_action_pressed("Up"):
				Motion.y = -MovementSpeed
				
			elif Input.is_action_pressed("Down"):
				Motion.y = MovementSpeed
			


func _on_AnimatedSprite_animation_finished():
	if Animate.animation == "Side Light":
		Animate.play("Idle")
		SelectState = StateList.Idle
		
	if Animate.animation == "Nuetral Air":
		Animate.play("Fall")
		SelectState = StateList.Fall
		
		
		
	if Animate.animation == "Nuetral Light":
		SelectState = StateList.Idle
		Animate.play("Idle")
		$AnimationPlayer.play("RESET")

	if Animate.animation == "Down Light":
		SelectState = StateList.Idle
		Animate.play("Idle")
		$AnimationPlayer.play("RESET")
		
	if Animate.animation == "Up Light":
		SelectState = StateList.Idle
		Animate.play("Idle")
		
	if Animate.animation == "Dodge Phase":
		SelectState = StateList.Idle
		Animate.play("Idle")
	



	




func _on_Attack_Timer_timeout():
	AttackPoints = 1
