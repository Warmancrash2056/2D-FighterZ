extends KinematicBody2D

onready var Animate = $"Scale Player/AnimationPlayer"
onready var CheckFloor = $"Check Floor"

onready var ChaseTimer = $Timer

export var controls: Resource = null

export (float) var Movement = 250
export (float) var AirMovement = 100
export (float) var Acceleration = 35
export (float) var JumpHeight = 800
export (float) var Gravity = 35

export (float) var Health = 200

var ChaseActive = false 
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
	ChainRun,
	ChainEnd,
	Death,
	Hurt
}
var Select = States.Idle

func _ready():
	pass
	
func _physics_process(delta):
	print(ChaseTimer.time_left)
	print(ChaseActive)
	print(Select)
	if Motion.x >= 1:
		$"Scale Player".set_scale(Vector2(abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
	elif Motion.x <= -1:
		$"Scale Player".set_scale(Vector2(-abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))

	
	Motion = move_and_slide(Motion, Up)

	match Select:
		States.Idle:
			Motion.y += Gravity
			if !CheckFloor.is_colliding():
				Select = States.Fall
				
			else:
				Select = States.Idle
				
			if Input.is_action_pressed(controls.input_left):
				Animate.play("Run")
				Motion.x = max(Motion.x - Acceleration, -Movement)
				
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Slight
					
				if Input.is_action_just_pressed(controls.input_dash) and ChaseActive == false:
					Select = States.Roll

				if Input.is_action_just_pressed(controls.input_dash) and ChaseActive == true:
					Select = States.ChainRun
					Motion.x = 0
					Motion.y = 0
				
	
			elif Input.is_action_pressed(controls.input_right):
				Animate.play("Run")
				Motion.x = min(Motion.x + Acceleration, Movement)
				
				
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Slight
					
				if Input.is_action_just_pressed(controls.input_dash) and ChaseActive == false:
					Select = States.Roll

				if Input.is_action_just_pressed(controls.input_dash) and ChaseActive == true:
					Select = States.ChainRun
		
			elif Input.is_action_pressed(controls.input_down):
				# Code for falling down platform #
				pass
				
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Dlight
					
				else:
					Motion.x = 0
					Animate.play("Idle")
					
				
					
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
			Motion.y += Gravity
			if is_on_floor():
				Motion.y = -JumpHeight
				
			Animate.play("Jump")
			
			if Input.is_action_pressed(controls.input_left):
				Motion.x = max(Motion.x - Acceleration, -AirMovement)
				
			elif Input.is_action_pressed(controls.input_right):
				Motion.x = min(Motion.x + Acceleration, AirMovement)
				
			else:
				Motion.x = lerp(Motion.x , 0.01, 0.01)
			
			if Motion.y > 0:
				Select = States.Fall
				
			if Input.is_action_just_pressed(controls.input_attack):
				Select = States.Nair
				
			
			
		States.Fall:
			Motion.y += Gravity
			Animate.play("Fall")
			
			 
			if is_on_floor():
				Select = States.Idle
				
			if Input.is_action_pressed(controls.input_left):
				Motion.x = max(Motion.x - Acceleration, -AirMovement)
				
			elif Input.is_action_pressed(controls.input_right):
				Motion.x = min(Motion.x + Acceleration, AirMovement)
				
			else:
				Motion.x = lerp(Motion.x , 0.01, 0.01)
			
			if Input.is_action_just_pressed(controls.input_dash) and ChaseActive == true:
				Select = States.ChainRun
			
			
		States.Nlight:
			Motion.x = 0
			Animate.play("Nlight")
			
		States.Slight:
			Motion.x = 0
			Motion.y = 0
			Animate.play("Slight")

		States.Dlight:
			Motion.x = 0
			Motion.y = 0
			Animate.play("Dlight")
			
				
		States.Ulight:
			Motion.x = 0
			Motion.y = 0
			Animate.play("Ulight")
			
				
		States.Nair:
			Motion.y = 0
			Motion.x = 0
			Animate.play("Nair")

			
		States.Defend:
			Animate.play("Block")
			Motion.y = 0
			
			
			if Motion.x != 0:
				Motion.x = lerp(Motion.x , 0 , 0.04)
			
			
		States.Roll:
			Motion.y += Gravity
			Animate.play("Roll")
			if !is_on_floor():
				Select = States.Fall
			yield(get_tree().create_timer(0.05), "timeout")
			if Input.is_action_just_pressed(controls.input_block):
				Select = States.Defend
				
		States.ChainRun:
			Motion.y = 0
			Animate.play("Chain Run")
			
			if Input.is_action_pressed(controls.input_left):
				Motion.x = -150
				
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Slight
					
			elif Input.is_action_pressed(controls.input_right):
				Motion.x = 150
				
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Slight
			elif Input.is_action_pressed(controls.input_up):
				Motion.y = -150
				
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Ulight
			elif Input.is_action_pressed(controls.input_down):
				Motion.y = 150
				
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Dlight
			
			elif Input.is_action_just_pressed(controls.input_attack):
				if CheckFloor.is_colliding():
					Select = States.Nlight
					
				else:
					Select = States.Nair
					
			elif Input.is_action_just_pressed(controls.input_block):
				Select = States.Defend
			
		States.ChainEnd:
			Animate.play("Chain End")
		States.Death:
			Animate.play("Jump")
			
		States.Hurt:
			Motion.x = 0
			Animate.play("Take Hit")





func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Nlight":
		Select = States.Idle

	if anim_name == "Slight":
		Select = States.Idle

	if anim_name == "Ulight":
		Select = States.Idle
		
	if anim_name == "Dlight":
		Select = States.Idle
		
	if anim_name == "Nair":
		Select = States.Fall
	
	if anim_name == "Roll":
		Select = States.Idle
		
	if anim_name == "Block":
		if CheckFloor.is_colliding():
			Select = States.Idle
		else: 
			Select = States.Fall
	if anim_name == "Chain Run":
		if is_on_floor():
			Select = States.Idle
			
		else:
			Select = States.Fall
		
	










func _on_Nuetral_Light_Hitbox_area_entered(area):
	ChaseTimer.start()
	ChaseActive = true





func _on_Nuetral_Air_area_entered(area):
	ChaseTimer.start()
	ChaseActive = true


func _on_Timer_timeout():
	ChaseActive = false


func _on_Down_Light_Hitbox_area_entered(area):
	ChaseActive = true


func _on_Side_Light_Second_Punch_area_entered(area):
	pass # Replace with function body.


func _on_Side_Light_First_Punch_area_entered(area):
	pass
