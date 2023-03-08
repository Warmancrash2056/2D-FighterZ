extends CharacterBody2D
class_name FireKnight

@onready var Animate = $"Scale Player/AnimationPlayer"
@onready var CheckFloor = $"Check Floor"
@onready var SpriteH = $"Player Sprite2D"
@onready var Smoke = $Smoke

@onready var Nlight_Hitbox_Top =$"Scale Player/Nuetral Light3D Hitbox/Top Swing"
@onready var Nlight_Hitbox_Lower = $"Scale Player/Nuetral Light3D Hitbox/Lower"
@onready var Nlight_Hitbox_Final = $"Scale Player/Nuetral Light3D Hitbox/Final"
@onready var Nlight_Hitbox_Ground = $"Scale Player/Nuetral Light3D Hitbox/Ground"
@onready var Nair_Slash = $"Scale Player/Nuetral Air Hitbox/Slash"


@onready var Slight_Hitbox_Buttom = $"Scale Player/Side Light3D Hitbox/Buttom Swing"
@onready var Slight_Hitbox_Top = $"Scale Player/Side Light3D Hitbox/Top Swing"
@onready var Slight_Hitbox_Middle = $"Scale Player/Side Light3D Hitbox/Middle Swing"
@onready var Slight_Hitbox_Fianl = $"Scale Player/Side Light3D Hitbox/Final"

@onready var Down_Light_Start = $"Scale Player/Down Light3D Hitbox/Startup"
@onready var Down_Light_Angle_Exposion = $"Scale Player/Down Light3D Hitbox/Angled Fire Pillar"
@onready var Down_Light_Final_Explosion = $"Scale Player/Down Light3D Hitbox/Final Explosion"

@onready var Up_Light_Ignite_Blade = $"Scale Player/Up light Hitbox/Ignite Blade"
@onready var Up_Light_Flame_Pillar = $"Scale Player/Up light Hitbox/Flame Pillar"
@onready var Up_light_Ground_Flame = $"Scale Player/Up light Hitbox/Ground Flame"


@onready var ChaseTimer = $Timer

@export var controls: Resource = preload("res://Character Resouces/Global/Player_1.tres")



@export var Movement: int  = 250
@export var AirMovement: int  = 100
@export var Acceleration: int  = 35
@export var JumpHeight: int = 800
@export var Gravity : int  = 35

@export var Health = 200

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

	
func _physics_process(delta):
	#print(Input.get_connected_joypads().size())
	if Motion.x >= 1:
		SpriteH.flip_h = false
		Smoke.position.x = -17
		$"Scale Player".set_scale(Vector2(abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
	elif Motion.x <= -1:
		SpriteH.flip_h = true
		Smoke.position.x = 17
		$"Scale Player".set_scale(Vector2(-abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))

	
	set_velocity(Motion)
	set_up_direction(Up)
	move_and_slide()
	Motion = velocity

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
			await get_tree().create_timer(0.05).timeout
			if Input.is_action_just_pressed(controls.input_block):
				Select = States.Defend
				
		States.ChainRun:
			#print(Motion)
			Motion.y += Gravity
			Animate.play("Chain Run")
			
			if Input.is_action_pressed(controls.input_left):
				Motion.x = -300 
				
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Slight
					
			elif Input.is_action_pressed(controls.input_right):
				Motion.x = 300
				
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Slight
			elif Input.is_action_pressed(controls.input_up):
				
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Ulight
			elif Input.is_action_pressed(controls.input_down):
				
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
		Motion.x = 0
		if is_on_floor():
			Select = States.Idle
			
		else:
			Select = States.Fall
		
	









func _on_Up_light_Hitbox_area_entered(area):
	ChaseTimer.start()
	ChaseActive = true
	


func _on_Side_Light_Hitbox_area_entered(area):
	ChaseTimer.start()
	ChaseActive = true


func _on_Down_Light_Hitbox_area_entered(area):
	ChaseActive = true
	ChaseTimer.start()


func _on_Nuetral_Air_Hitbox_area_entered(area):
	ChaseTimer.start()
	ChaseActive = true
	


func _on_Nuetral_Light_Hitbox_area_entered(area):
	ChaseTimer.start()
	ChaseActive = true


func _on_Timer_timeout():
	ChaseActive = false
	
