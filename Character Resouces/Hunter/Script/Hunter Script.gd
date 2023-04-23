extends CharacterBody2D

@export var controls: Resource

# Call the animation for arrow shower in animationplayer
@onready var DownArrow = $"Scale Player/Down Light Arrow"
@onready var Animate = $"Scale Player/AnimationPlayer"
@onready var SpriteH = $Animation

@export var Movement: int  = 175
@export var AirMovement: int  = 120
@export var Acceleration: int  = 35
@export var JumpHeight: int = 600
@export var Gravity : int  = 35

@export var Health = 900
var can_attack = true
var Motion = Vector2.ZERO
var Up = Vector2.UP
var action_pts = 6
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
	$Action.value = action_pts
func _add_action_pts():
	
	if action_pts < 6:
		action_pts += 1
		
	else:
		action_pts = 6

func _down_light():
	print("good")
	DownArrow.play("Shower")
	DownArrow.visible = true
	$"Down Light Sound".play()

func _physics_process(delta):
	
	if action_pts <= 0:
		can_attack = false
	else:
		can_attack = true
	$Action.value = action_pts
	print(float($Action.value))
	if Motion.x >= 1:
		SpriteH.flip_h = false
		$"Scale Player".set_scale(Vector2(abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
	elif Motion.x <= -1:
		SpriteH.flip_h = true
		$"Scale Player".set_scale(Vector2(-abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))

	
	set_velocity(Motion)
	set_up_direction(Up)
	move_and_slide()
	Motion = velocity

	match Select:

		States.Idle:
			Motion.y += Gravity 
			if !is_on_floor():
				Select = States.Fall
				
			else:
				Select = States.Idle
				
			if Input.is_action_pressed(controls.input_left):
				Animate.play("Run")
				Motion.x = max(Motion.x - Acceleration, -Movement)
				if can_attack == true:
					if Input.is_action_just_pressed(controls.input_attack):
						Select = States.Slight
						action_pts -= 2
						
					if Input.is_action_just_pressed(controls.input_dash):
						Select = States.Roll
						Motion.x = -350
						action_pts -= 3.5
			elif Input.is_action_pressed(controls.input_right):
				Animate.play("Run")
				Motion.x = min(Motion.x + Acceleration, Movement)
				
				if can_attack == true:
					if Input.is_action_just_pressed(controls.input_attack):
						Select = States.Slight
						action_pts -= 3.5
						
						
					if Input.is_action_just_pressed(controls.input_dash):
						Select = States.Roll
						Motion.x = 350
						action_pts -= 2

		
			elif Input.is_action_pressed(controls.input_down):
				if can_attack == true:
				
					if Input.is_action_just_pressed(controls.input_attack):
						Select = States.Dlight
						action_pts -= 4
						
					else:
						Motion.x = 0
						Animate.play("Idle")
						
				
					
			elif Input.is_action_pressed(controls.input_up):
				if can_attack == true:
					if Input.is_action_just_pressed(controls.input_attack):
						Select = States.Ulight
						action_pts -= 4.5
			else:
				Motion.x = lerp(Motion.x , 0.01, 0.8)
				Animate.play("Idle")
				if can_attack == true:
					if Input.is_action_just_pressed(controls.input_attack):
						Select = States.Nlight
						action_pts -= 2
						
					elif Input.is_action_just_pressed(controls.input_block):
						Select = States.Defend
						action_pts -= 4.8
			if can_attack == true:
				if Input.is_action_just_pressed(controls.input_jump):
					Select = States.Jump
					$"Jump Sound".play()
					action_pts -= 1
				
		States.Jump:
			Motion.y += Gravity
			if is_on_floor():
				Motion.y = -JumpHeight
					
				
			Animate.play("Jump")
			if can_attack == true:
				if Input.is_action_pressed(controls.input_down):
					Motion.y += 20
					action_pts -= 0.1
				
			if Input.is_action_pressed(controls.input_left):
				Motion.x = max(Motion.x - Acceleration, -AirMovement)
				if can_attack == true:
					if Input.is_action_just_pressed(controls.input_attack):
						Select = States.Nair
						action_pts -= 2
				
			elif Input.is_action_pressed(controls.input_right):
				Motion.x = min(Motion.x + Acceleration, AirMovement)
				if can_attack == true:
					if Input.is_action_just_pressed(controls.input_attack):
						Select = States.Nair
						action_pts -= 2
			else:
				Motion.x = lerp(Motion.x , 0.01, 0.01)
				if can_attack == true:
					if Input.is_action_just_pressed(controls.input_attack):
						Select = States.Nair
						action_pts -= 2
			if Motion.y > 0:
				Select = States.Fall
				
			
		States.Fall:
			Motion.y += Gravity
			Animate.play("Fall")
			
			if is_on_floor():
				Select = States.Idle
				
			if can_attack == true:
				if Input.is_action_pressed(controls.input_down):
					Motion.y += 20
					action_pts -= 0.1
			if Input.is_action_pressed(controls.input_left):
				Motion.x = max(Motion.x - Acceleration, -AirMovement)
				
			elif Input.is_action_pressed(controls.input_right):
				Motion.x = min(Motion.x + Acceleration, AirMovement)
			
			else:
				Motion.x = lerp(Motion.x , 0.01, 0.01)
				
					
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
			Motion.x = lerp(Motion.x , 0.1, 0.03)
			Motion.y = 0
			Animate.play("Nair")

			
		States.Defend:
			Animate.play("Block")
			Motion.y = 0
			Motion.x = 0
			
		
			
			
		States.Roll:
			Motion.x = lerp(Motion.x , 0.01, 0.02)
			Motion.y += Gravity
			Animate.play("Roll")
			if !is_on_floor():
				Select = States.Fall
			await get_tree().create_timer(0.05).timeout
			if can_attack == true:
				if Input.is_action_just_pressed(controls.input_block):
					Select = States.Defend
					
				elif Input.is_action_just_pressed(controls.input_jump):
					Select = States.Jump
				
		States.Death:
			Animate.play("Jump")
			
		States.Hurt:
			Motion.x = 0
			Animate.play("Take Hit")





	
func _on_animation_player_animation_finished(anim_name):
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
		if is_on_floor():
			Select = States.Idle
		else: 
			Select = States.Fall
	


func _on_down_light_arrow_animation_looped():
	if DownArrow.animation == "Shower":
		DownArrow.stop()
		DownArrow.frame = 0
		DownArrow.visible = false
		$"Down Light Sound".stop()



