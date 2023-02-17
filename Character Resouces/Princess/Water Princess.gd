extends KinematicBody2D

onready var Animate = $AnimatedSprite
onready var Platform = $Platform
onready var CheckFloor = $"Check Floor"

onready var Nuetral_Light_Hitbox = $"Nuetral Light/CollisionShape2D"
onready var Side_Light_Hitbox = $"Side Light/CollisionShape2D"
onready var Nuetral_Air_Hitbox = $"Nuetral Air/CollisionShape2D"
onready var Down_Light_Front_Hitbox = $"Down Light Front/CollisionShape2D"
onready var Down_Light_Middle_Hitbox = $"Down Light Middle/CollisionShape2D"
onready var Down_Light_Back_Hitbox = $"Down Light Back/CollisionShape2D"
onready var Up_Light_Above_Hitbox = $"Up Light Above/CollisionShape2D"
onready var Up_Light_Below_Hitbox = $"Up Light Below/CollisionShape2D"

export (float) var Health = 200

export var controls: Resource = null

export (float) var Movement = 250
export (float) var AirMovement = 100
export (float) var AirAcceleration = 5
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

func _process(delta):
	pass

	
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
			
				Down_Light_Back_Hitbox.position.x = -53
				Down_Light_Front_Hitbox.position.x = -85
				Down_Light_Middle_Hitbox.position.x = -68
				Side_Light_Hitbox.position.x = -70
				Nuetral_Air_Hitbox.position.x = -54
				Nuetral_Light_Hitbox.position.x = -45
				Up_Light_Below_Hitbox.position.x = -56
				Up_Light_Above_Hitbox.position.x = -57

			elif Input.is_action_pressed(controls.input_right):
				Animate.play("Walk")
				Animate.flip_h = false
				Motion.x = min(Motion.x + Acceleration, Movement)
				
				
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Slight
					
				Down_Light_Back_Hitbox.position.x = 53
				Down_Light_Front_Hitbox.position.x = 85
				Down_Light_Middle_Hitbox.position.x = 68
				Side_Light_Hitbox.position.x = 70
				Nuetral_Air_Hitbox.position.x = 54
				Nuetral_Light_Hitbox.position.x = 45
				Up_Light_Below_Hitbox.position.x = 56
				Up_Light_Above_Hitbox.position.x = 57
				
				
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
				Motion.x = max(Motion.x - AirAcceleration, -AirMovement)
				
				Down_Light_Back_Hitbox.position.x = -53
				Down_Light_Front_Hitbox.position.x = -85
				Down_Light_Middle_Hitbox.position.x = -68
				Side_Light_Hitbox.position.x = -70
				Nuetral_Air_Hitbox.position.x = -54
				Nuetral_Light_Hitbox.position.x = -45
				Up_Light_Below_Hitbox.position.x = -56
				Up_Light_Above_Hitbox.position.x = -57
				
			elif Input.is_action_pressed(controls.input_right):
				Animate.flip_h = false
				Motion.x = min(Motion.x + AirAcceleration, AirMovement)
				
				Down_Light_Back_Hitbox.position.x = 53
				Down_Light_Front_Hitbox.position.x = 85
				Down_Light_Middle_Hitbox.position.x = 68
				Side_Light_Hitbox.position.x = 70
				Nuetral_Air_Hitbox.position.x = 54
				Nuetral_Light_Hitbox.position.x = 45
				Up_Light_Below_Hitbox.position.x = 56
				Up_Light_Above_Hitbox.position.x = 57
				
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
				Motion.x = max(Motion.x - AirAcceleration, -AirMovement)
				
				Down_Light_Back_Hitbox.position.x = -53
				Down_Light_Front_Hitbox.position.x = -85
				Down_Light_Middle_Hitbox.position.x = -68
				Side_Light_Hitbox.position.x = -70
				Nuetral_Air_Hitbox.position.x = -54
				Nuetral_Light_Hitbox.position.x = -45
				Up_Light_Below_Hitbox.position.x = -56
				Up_Light_Above_Hitbox.position.x = -57
				
			elif Input.is_action_pressed(controls.input_right):
				Animate.flip_h = false
				Motion.x = min(Motion.x + AirAcceleration, AirMovement)
				
				Down_Light_Back_Hitbox.position.x = 53
				Down_Light_Front_Hitbox.position.x = 85
				Down_Light_Middle_Hitbox.position.x = 68
				Side_Light_Hitbox.position.x = 70
				Nuetral_Air_Hitbox.position.x = 54
				Nuetral_Light_Hitbox.position.x = 45
				Up_Light_Below_Hitbox.position.x = 56
				Up_Light_Above_Hitbox.position.x = 57
					

				
			else:
				Motion.x = lerp(Motion.x , 0.01, 0.01)
			
		States.Nlight:
			Motion.x = 0
			Animate.play("Nuetral Light")
			
			if Animate.frame == 2:
				Nuetral_Light_Hitbox.disabled = false
				
			if Animate.frame == 4:
				Nuetral_Light_Hitbox.disabled = true
			
		States.Slight:
			Motion.x = 0
			Animate.play("Side Light")
			
			if Animate.frame == 10:
				Nuetral_Light_Hitbox.disabled = false
				
			if Animate.frame == 11:
				Side_Light_Hitbox.disabled = false
				
			if Animate.frame == 12:
				Side_Light_Hitbox.disabled = true
				
			if Animate.frame == 14:
				Nuetral_Light_Hitbox.disabled = true
		States.Dlight:
			Motion.x = 0
			Animate.play("Down Light")
			
			if Animate.frame == 3:
				Down_Light_Back_Hitbox.disabled = false
				
			if Animate.frame == 4:
				Down_Light_Middle_Hitbox.disabled = false
				
			if Animate.frame == 5:
				Down_Light_Front_Hitbox.disabled = false
				
			if Animate.frame == 8:
				Down_Light_Front_Hitbox.disabled = true
				Down_Light_Middle_Hitbox.disabled = true
				Down_Light_Back_Hitbox.disabled = true
			
		States.Ulight:
			Motion.x = 0
			Animate.play("Up Light")
			
			if Animate.frame == 4:
				Up_Light_Above_Hitbox.disabled = false
				
			if Animate.frame == 12:
				Up_Light_Above_Hitbox.disabled = true
				Up_Light_Below_Hitbox.disabled = false
			
			if Animate.frame == 17:
				Up_Light_Below_Hitbox.disabled = true
				
			if Animate.frame == 22:
				Up_Light_Below_Hitbox.disabled = false
				
			if Animate.frame == 29:
				Up_Light_Below_Hitbox.disabled = true
		States.Nair:
			Motion.y = 0
			Motion.x = 0
			Animate.play("Nuetral Air")
			
			if Animate.frame == 3:
				Nuetral_Air_Hitbox.disabled = false
				
			if Animate.frame == 7:
				Nuetral_Air_Hitbox.disabled = true
		States.Defend:
			Animate.play("Blo")
			
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
		Platform.play("RESET")
		
	if Animate.animation == "Up Light":
		Animate.play("Idle")
		Select = States.Idle
		Platform.play("RESET")
	
	if Animate.animation == "Nuetral Air":
		Animate.play("Fall")
		Select = States.Fall
		Platform.play("RESET")
		
	if Animate.animation == "Block":
		Animate.play("Idle")
		Select = States.Idle
		Platform.play("RESET")
		
	if Animate.animation == "Take Hit":
		Animate.play("Idle")
		Select = States.Idle
		Platform.play("RESET")
		
	if Animate.animation == "Death":
		queue_free()
		Platform.play("RESET")


func _on_Hurtbox_area_entered(area):
	Select = States.Hurt
	
	Health -= 20
	print(Health)
	
	if Health <= 0:
		Select = States.Death
	

