extends KinematicBody2D

onready var Animate = $Node2D/AnimationPlayer
onready var Sprites = $AnimatedSprite
onready var Platform = $Platform
onready var CheckFloor = $"Check Floor"

onready var Nuetral_Side_light_Hitbox = $"Nuetral Light/CollisionShape2D"
onready var Down_Light_Hitbox = $"Down Light/CollisionShape2D"
onready var Up_Light_Hitbox = $"Up Light/CollisionShape2D"
onready var Nuetral_Air_Hitbox = $"Nuetral Air/CollisionShape2D"

export var controls: Resource = null

export (float) var Movement = 250
export (float) var AirMovement = 100
export (float) var Acceleration = 35
export (float) var JumpHeight = 800
export (float) var Gravity = 35

export (float) var Health = 200

var Motion = Vector2.ZERO
var Up = Vector2.UP

var Direction = 1
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
	if Motion.x >= 1:
		$Node2D.set_scale(Vector2(abs($Node2D.get_scale().x), $Node2D.get_scale().y))
	elif Motion.x <= -1:
		$Node2D.set_scale(Vector2(-abs($Node2D.get_scale().x), $Node2D.get_scale().y))

	
	Motion = move_and_slide(Motion, Up)
	Motion.y += Gravity
	match Select:
		States.Idle:
			
			if !CheckFloor.is_colliding():
				Select = States.Fall
				
			if Input.is_action_pressed(controls.input_left):
				Animate.play("run")
				Sprites.flip_h = true
				Motion.x = max(Motion.x - Acceleration, -Movement)
				
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Slight
					
				elif Input.is_action_just_pressed(controls.input_block):
					Select = States.Roll
					Motion.x = -300
	
			elif Input.is_action_pressed(controls.input_right):
				Animate.play("run")
				Sprites.flip_h = false
				Motion.x = min(Motion.x + Acceleration, Movement)
				
				
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Slight
					
				elif Input.is_action_just_pressed(controls.input_block):
					Select = States.Roll
					Motion.x = 300
		
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
				Sprites.flip_h = true
				Motion.x = max(Motion.x - Acceleration, -AirMovement)
				
			elif Input.is_action_pressed(controls.input_right):
				Sprites.flip_h = false
				Motion.x = min(Motion.x + Acceleration, AirMovement)
				
			else:
				Motion.x = lerp(Motion.x , 0.01, 0.01)
			
		States.Nlight:
			Motion.x = 0
			Animate.play("Nuetral Light")
			
		States.Slight:
			Motion.x = 0
			Animate.play("Side Light")
			if Animate.frame == 0:
				Nuetral_Side_light_Hitbox.disabled = false
				
			if Animate.frame == 2:
				Nuetral_Side_light_Hitbox.disabled = true
				
			if Animate.frame == 3:
				Nuetral_Side_light_Hitbox.disabled = false
				
			if Animate.frame == 5:
				Nuetral_Side_light_Hitbox.disabled = true

		States.Dlight:
			Motion.x = 0
			Animate.play("Down Light")
			
			if Animate.frame == 7:
				Down_Light_Hitbox.disabled = false
				
			if Animate.frame == 10:
				Down_Light_Hitbox.disabled = true
				
		States.Ulight:
			Motion.x = 0
			Animate.play("Up Light")
			
			if Animate.frame == 7:
				Up_Light_Hitbox.disabled = false
				
			if Animate.frame == 10:
				Up_Light_Hitbox.disabled = true
				
		States.Nair:
			Motion.y = 0
			Motion.x = 0
			Animate.play("Nuetral Air")
			
			if Animate.frame == 2:
				Nuetral_Air_Hitbox.disabled = false
				
			if Animate.frame == 3:
				Nuetral_Air_Hitbox.disabled = true
			
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
		Animate.play("Idle")
		Select = States.Idle
		
	if Animate.animation == "Death":
		queue_free()


func _on_Hurtbox_area_entered(area):
	Select = States.Hurt
	
	Health -= 20
	print(Health)
	
	if Health <= 0:
		Select = States.Death
