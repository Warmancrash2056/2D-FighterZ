extends CharacterBody2D

var controls: Resource = load("res://Character Resouces/Global/Controller Resource/Player_2.tres")

@onready var Animate = $Character
@onready var Sprite = $Sprite

@export var Speed = 250
@export var JumpHeight = 550
@export var Gravity = 35

@export var Health: int

var Up = Vector2.UP
var Can_Attack = true
var Action_Exceeded = false
var Jump_Count = 2
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
	Hurt, 
	ActivateSuper, 
	DeactivateSuper, IdleSuper, RunSuper, JumpSuper, FallSuper, 
NlightSuper, SlightSuper, DlightSuper, UlightSuper,}
var Select = States.Idle

func _ready():
	pass


func _process(delta):
	if velocity.x >= 1:
		Sprite.flip_h = false
		$"Scale Player".set_scale(Vector2(abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
	elif velocity.x <= -1:
		Sprite.flip_h = true
		$"Scale Player".set_scale(Vector2(-abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
		
func _physics_process(delta):
	velocity.y += Gravity
	move_and_slide()

	match Select:

		States.Idle:
			if not is_on_floor():
				Select = States.Fall
				
			if Input.is_action_pressed(controls.input_left):
				Animate.play("Run")
				velocity.x = -Speed
				if Input.is_action_just_pressed(controls.input_attack):
						Select = States.Slight
						
				if Input.is_action_just_pressed(controls.input_dash):
						Select = States.Roll
						velocity.x = -350
			elif Input.is_action_pressed(controls.input_right):
				Animate.play("Run")
				velocity.x = Speed
				
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Slight
						
						
				if Input.is_action_just_pressed(controls.input_dash):
					Select = States.Roll
					velocity.x = 350
			
			else:
				velocity.x = 0
				Animate.play("Idle")
				
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Nlight
				elif Input.is_action_just_pressed(controls.input_block):
					Select = States.Defend
			if Input.is_action_pressed(controls.input_down):
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Dlight

					
			if Input.is_action_pressed(controls.input_up):
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Ulight
		
			if Input.is_action_just_pressed(controls.input_jump):
					Animate.play("Jump")
					Select = States.Jump
					$"Jump Sound".play()
					
			if Input.is_action_just_pressed(controls.input_dash):
				Select = States.ActivateSuper
				
		States.Jump:
			if is_on_floor():
				velocity.y = -JumpHeight
				
			if velocity.y > 0:
				Select = States.Fall
			if Input.is_action_pressed(controls.input_down):
				velocity.y += 10
			if Input.is_action_pressed(controls.input_left):
				velocity.x = -Speed
				
				
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Nair
				
			elif Input.is_action_pressed(controls.input_right):
				velocity.x = Speed
				
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Nair
			else:
				velocity.x = 0
				
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Nair
					
		States.Fall:
			velocity.y += Gravity
			Animate.play("Fall")
			
			if is_on_floor():
				Select = States.Idle
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

		States.ActivateSuper:
			Animate.play("Activate Super")
			
		States.IdleSuper:
			pass
			
		States.DeactivateSuper:
			Animate.play("Deactivate Super")
	
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
	if anim_name == "Activate Super":
		Select = States.DeactivateSuper
	if anim_name == "Deactivate Super":
		Select = States.Idle
