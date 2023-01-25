extends KinematicBody2D

onready var Animate = $AnimatedSprite
onready var Platform = $Platform
onready var CheckFloor = $"Check Floor"

# Collision HitBoxes #
onready var Nuetral_Light_Hitbox = $"Nuetral Light/CollisionShape2D"
onready var Down_Light_Hitbox = $"Down Light Hitbox/CollisionShape2D"
onready var Up_Light_Hitbox = $"Up Light/CollisionShape2D"
onready var Nuetral_Air_Hitbox = $"Nuetral Air/CollisionShape2D"

export var controls: Resource = null

export (float) var Movement = 250
export (float) var AirMovement = 100
export (float) var Acceleration = 35
export (float) var JumpHeight = 800
export (float) var Gravity = 35

var DirectionFacing = 0

var Motion = Vector2.ZERO
var Up = Vector2.UP

enum States {
	Idle,
	Jump,
	Fall,
	Nlight,
	Slight,
	Dlight,
	Ulight,
	Nair,
	Defend,
	Roll,
	Death,
	Hurt
}
var Select = States.Idle


	
func _physics_process(delta):
	Motion = move_and_slide(Motion, Up)
	Motion.y += Gravity
	match Select:
		States.Idle:
			
			if !CheckFloor.is_colliding():
				Select = States.Fall
				
			if Input.is_action_pressed(controls.input_left):
				Animate.play("Run")
				Animate.flip_h = true
				Motion.x = max(Motion.x - Acceleration, -Movement)
				
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Slight
					
				elif Input.is_action_just_pressed(controls.input_block):
					Select = States.Roll
					Motion.x = -300
				
				Nuetral_Light_Hitbox.position.x = -24
			elif Input.is_action_pressed(controls.input_right):
				Animate.play("Run")
				Animate.flip_h = false
				Motion.x = min(Motion.x + Acceleration, Movement)
				
				
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Slight
					
				elif Input.is_action_just_pressed(controls.input_block):
					Select = States.Roll
					Motion.x = 300
					
				Nuetral_Light_Hitbox.position.x = 24
			elif Input.is_action_pressed(controls.input_down):
				# Code for falling down platform #
				Platform.play("Disable")
				
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Dlight
					Platform.stop()
					
					
			elif Input.is_action_pressed(controls.input_up):
				
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Ulight
			else:
				Motion.x = lerp(Motion.x , 0.01, 0.8)
				Animate.play("Idle")
				
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Nlight
					
				elif Input.is_action_just_pressed(controls.input_block):
					Select = States.Defend
			if Input.is_action_just_pressed(controls.input_jump):
				Select = States.Jump
				
		States.Jump:
			if is_on_floor():
				Motion.y = -JumpHeight
				
			Animate.play("Jump")
			
			if Input.is_action_pressed(controls.input_left):
				Animate.flip_h = true
				Motion.x = max(Motion.x - Acceleration, -AirMovement)
				
			elif Input.is_action_pressed(controls.input_right):
				Animate.flip_h = false
				Motion.x = min(Motion.x + Acceleration, AirMovement)
				
			else:
				Motion.x = lerp(Motion.x , 0.01, 0.01)
			
			if Motion.y > 0:
				Select = States.Fall
				
			if Input.is_action_just_pressed(controls.input_attack):
				Select = States.Nair
			
			
		States.Fall:
			Animate.play("Fall")
			if Input.is_action_pressed(controls.input_down):
				Platform.play("Disable")
			 
			if CheckFloor.is_colliding():
				Select = States.Idle
				
			if Input.is_action_pressed(controls.input_left):
				Animate.flip_h = true
				Motion.x = max(Motion.x - Acceleration, -AirMovement)
				
			elif Input.is_action_pressed(controls.input_right):
				Animate.flip_h = false
				Motion.x = min(Motion.x + Acceleration, AirMovement)
				
			else:
				Motion.x = lerp(Motion.x , 0.01, 0.01)
			
		States.Nlight:
			Motion.x = 0
			Animate.play("Nuetral Light")
			
			if Animate.frame == 2:
				pass
			if Animate.frame == 5:
				pass
		States.Slight:
			Motion.x = 0
			Animate.play("Side Light")
			if Animate.frame == 0:
				pass
				
			if Animate.frame == 2:
				pass
				
			if Animate.frame == 3:
				pass
				
			if Animate.frame == 5:
				pass

		States.Dlight:
			Motion.x = 0
			Animate.play("Down Light")
			
			if Animate.frame == 7:
				pass
				
			if Animate.frame == 10:
				pass
				
		States.Ulight:
			Motion.x = 0
			Animate.play("Up Light")
			
			if Animate.frame == 7:
				pass
				
			if Animate.frame == 10:
				pass
			
		States.Nair:
			Motion.y = 0
			Motion.x = 0
			Animate.play("Nuetral Air")
			
			if Animate.frame == 2:
				pass
				
			if Animate.frame == 3:
				pass
			
		States.Defend:
			Animate.play("Defend")
		States.Roll:
			Animate.play("Roll")
		States.Death:
			Animate.play("Death")
			
		States.Hurt:
			Animate.play("Take Hit")


func _on_AnimatedSprite_animation_finished():
	if Animate.animation == "Nuetral Light":
		Animate.play("Idle")
		Select = States.Idle
		Platform.play("RESET")
	
	if Animate.animation == "Side Light":
		Animate.play("Idle")
		Select = States.Idle
		Platform.play("RESET")
		
	if Animate.animation == "Down Light":
		Animate.play("Idle")
		Select = States.Idle
		
	if Animate.animation == "Up Light":
		Animate.play("Idle")
		Select = States.Idle
	
	if Animate.animation == "Nuetral Air":
		Animate.play("Fall")
		Select = States.Fall
		
	if Animate.animation == "Defend":
		Animate.play("Idle")
		Select = States.Idle
		
	if Animate.animation == "Roll":
		Animate.play("Idle")
		Select = States.Idle
		
	if Animate.animation == "Take Hit":
		Animate.play("idle")
		Select = States.Idle
		
	if Animate.animation == "Death":
		queue_free()
