extends CharacterBody2D

var controls: Resource = load("res://Character Resouces/Global/Controller Resource/Player_2.tres")


@onready var Animate = $Character
@onready var Sprite = $Sprite
@onready var Jump_Smoke = $"Jump Smoke"
@onready var Run_Smoke = $"Smoke Run"

const Speed = 250
const Jump_Height = 550
const Gravity = 35

@export var Health: int

enum States {
	Move_Left,
	Move_Right,
	Standing,
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
var Select = States.Standing

func _ready():
	Jump_Smoke.frame = 0
	Jump_Smoke.visible = false

func smoke_jump():
	Jump_Smoke.play("Jump")
	Jump_Smoke.visible = true

func jump_height():
	if is_on_floor():
		velocity.y = -Jump_Height
	
func turn_left():
	if Sprite.flip_h == true:
		Select = States.Move_Left
	if Input.is_action_pressed(controls.input_left):
		await get_tree().create_timer(0.1).timeout
		Sprite.flip_h = true
		$"Scale Player".set_scale(Vector2(-abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
		if Input.is_action_just_pressed(controls.input_attack):
			Select = States.Nlight
			
		await get_tree().create_timer(0.1).timeout
		if Input.is_action_pressed(controls.input_left):
			Select = States.Move_Left
func turn_right():
	if Sprite.flip_h == false:
		Select = States.Move_Right
	if Input.is_action_pressed(controls.input_right):
		
		await get_tree().create_timer(0.1).timeout
		Sprite.flip_h = false
		$"Scale Player".set_scale(Vector2(abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
		if Input.is_action_just_pressed(controls.input_attack):
			Select = States.Nlight
		
		await get_tree().create_timer(0.1).timeout
		if Input.is_action_pressed(controls.input_right):
			Select = States.Move_Right
func _physics_process(delta):
	print(Sprite.flip_h)
	velocity.y += Gravity
	move_and_slide()

	match Select:

		States.Standing:
			Animate.play("Idle")
			velocity.x = 0
			
			if !is_on_floor():
				Select = States.Fall
				
			if Input.is_action_pressed(controls.input_left):
				turn_left()
				
			if Input.is_action_pressed(controls.input_right):
				turn_right()
				
			if Input.is_action_just_pressed(controls.input_attack):
				Select = States.Nlight
			if Input.is_action_just_pressed(controls.input_jump):
				Select = States.Jump
		States.Move_Left:
			if Input.is_action_pressed(controls.input_left):
				velocity.x = -Speed
				Animate.play("Run")
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Slight
					
			else:
				Select = States.Standing
			if Input.is_action_just_pressed(controls.input_jump):
				Select = States.Jump
		States.Move_Right:
			if Input.is_action_pressed(controls.input_right):
				Animate.play("Run")
				velocity.x = Speed
				
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Slight
					
			else:
				Select = States.Standing
			
			if Input.is_action_just_pressed(controls.input_jump):
				Select = States.Jump
		States.Jump:
			if is_on_floor():
				Animate.play("Jump")
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
				Select = States.Standing
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
			
func _on_character_animation_finished(anim_name):
	if anim_name == "Nlight":
		Select = States.Standing

	if anim_name == "Slight":
		Select = States.Standing

	if anim_name == "Ulight":
		Select = States.Standing
		
	if anim_name == "Dlight":
			Select = States.Standing
	
	if anim_name == "Nair":
		Select = States.Jump
	
	if anim_name == "Roll":
		Select = States.Standing
		
	if anim_name == "Block":
		if is_on_floor():
			Select = States.Standing
			
		else: 
			Select = States.Fall
	if anim_name == "Activate Super":
		Select = States.DeactivateSuper
	if anim_name == "Deactivate Super":
		Select = States.Standing



func _on_smoke_animation_looped():
	Jump_Smoke.stop()
	Jump_Smoke.frame = 0
	Jump_Smoke.visible = false


func _on_smoke_run_animation_looped():
	Run_Smoke.stop()
	Run_Smoke.frame = 0
	Run_Smoke.visible = false
