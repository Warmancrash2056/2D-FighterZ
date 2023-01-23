extends KinematicBody2D

onready var Animate = $AnimatedSprite
onready var Platform = $Platform
onready var CheckFloor = $"Check Floor"


export var controls: Resource = null

export (float) var Movement = 250
export (float) var AirMovement = 100
export (float) var Acceleration = 35
export (float) var JumpHeight = 800
export (float) var Gravity = 35


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
				Animate.play("Walk")
				Animate.flip_h = true
				Motion.x = max(Motion.x - Acceleration, -Movement)
				
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Slight
				
			elif Input.is_action_pressed(controls.input_right):
				Animate.play("Walk")
				Animate.flip_h = false
				Motion.x = min(Motion.x + Acceleration, Movement)
				
				
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Slight
			
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
				Motion.x = lerp(Motion.x , 0.01, 0.5)
				Animate.play("Idle")
				
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Nlight
				
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
			
			
		States.Slight:
			Motion.x = 0
			Animate.play("Side Light")
			
		States.Dlight:
			Motion.x = 0
			Animate.play("Down Light")
			
		States.Ulight:
			Motion.x = 0
			Animate.play("Up Light")
			
		States.Nair:
			Motion.y = 0
			Motion.x = 0
			Animate.play("Nuetral Air")
			
		States.Defend:
			Animate.play("Block")
			
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
		
	if Animate.animation == "Block":
		Animate.play("Idle")
		Select = States.Idle
		
	if Animate.animation == "Take Hit":
		Animate.play("idle")
		Select = States.Idle
		
	if Animate.animation == "Death":
		queue_free()
