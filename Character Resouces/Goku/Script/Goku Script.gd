extends CharacterBody2D

@export var controls: Resource


@onready var Animate = $"Scale Player/AnimationPlayer"
@onready var SpriteH = $Animation

@export var Movement: int
@export var AirMovement: int
@export var JumpHeight: int
@export var Gravity : int

@export var Health: int

var Up = Vector2.UP
var Can_Attack = true
var Action_Exceeded = false
var Jump_Count = 3
enum States {Idle, Jump, Fall, Nlight, Slight, Dlight, Ulight, Nair, Defend, Roll, Death, Hurt}
var Select = States.Idle

func _ready():
	pass


func _process(delta):
	if velocity.x >= 1:
		SpriteH.flip_h = false
		$"Scale Player".set_scale(Vector2(abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
	elif velocity.x <= -1:
		SpriteH.flip_h = true
		
func _physics_process(delta):
	velocity.y += Gravity
	move_and_slide()

	match Select:

		States.Idle:
			Jump_Count = 3
				
			if Input.is_action_pressed(controls.input_left):
				Animate.play("Run")
				velocity.x = -Movement
				if Input.is_action_just_pressed(controls.input_attack):
						Select = States.Slight
						
				if Input.is_action_just_pressed(controls.input_dash):
						Select = States.Roll
						velocity.x = -350
			elif Input.is_action_pressed(controls.input_right):
				Animate.play("Run")
				velocity.x = Movement
				
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Slight
						
						
				if Input.is_action_just_pressed(controls.input_dash):
					Select = States.Roll
					velocity.x = 350
			
			elif Input.is_action_pressed(controls.input_down):
				Animate.play("Idle")
				if Can_Attack == true:
					if Input.is_action_just_pressed(controls.input_attack):
						Select = States.Dlight

					
			elif Input.is_action_pressed(controls.input_up):
				Animate.play("Idle")
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Ulight
			else:
				velocity.x = 0
				Animate.play("Idle")
				
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Nlight
				elif Input.is_action_just_pressed(controls.input_block):
					Select = States.Defend
			if Action_Exceeded == false:
				if Input.is_action_just_pressed(controls.input_jump) and Jump_Count > 0:
					Animate.play("Jump")
					Select = States.Jump
					Jump_Count -= 1
					$"Jump Sound".play()
					velocity.y = -JumpHeight
				
		States.Jump:
			if is_on_floor():
				Select = States.Idle
			if Input.is_action_pressed(controls.input_down):
				velocity.y += 1
				Animate.play("Fall")
			if not is_on_floor():
				if Input.is_action_just_pressed(controls.input_jump) and Jump_Count > 0:
					velocity.y = -JumpHeight
					Jump_Count -= 1
					$"Jump Sound".play()
					Animate.play("Jump")
				
			if Input.is_action_pressed(controls.input_left):
				velocity.x = -AirMovement
				
				
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Nair
				
			elif Input.is_action_pressed(controls.input_right):
				velocity.x = AirMovement
				
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Nair
			else:
				velocity.x = 0
				
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Nair

		States.Nlight:
			velocity.x = 0
			Animate.play("Nlight")
			
		States.Slight:
			velocity.x = 0
			velocity.y = 0
			
			Animate.play("Slight")

		States.Dlight:
			velocity.x = 0
			velocity.y = 0
			Animate.play("Dlight")
			
				
		States.Ulight:
			velocity.x = 0
			velocity.y = 0
			Animate.play("Ulight")
			
				
		States.Nair:
			velocity.x = lerp(velocity.x , 0.1, 0.03)
			velocity.y = 0
			Animate.play("Nair")

			
		States.Defend:
			Animate.play("Block")
			velocity.y = 0
			velocity.x = 0
			
		
			
			
		States.Roll:
			velocity.x = lerp(velocity.x , 0.01, 0.02)
			Animate.play("Roll")
			if !is_on_floor():
				Select = States.Fall
				
		States.Death:
			Animate.play("Jump")
			
		States.Hurt:
			velocity.x = 0
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
		Select = States.Jump
	
	if anim_name == "Roll":
		Select = States.Idle
		
	if anim_name == "Block":
		if is_on_floor():
			Select = States.Idle
		else: 
			Select = States.Fall
	
