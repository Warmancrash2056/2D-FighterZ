extends CharacterBody2D
var controls: Resource = load("res://Character Resouces/Global/Controller Resource/Player_3.tres")
var jump_smoke = preload("res://jump_smoke.tscn")
@onready var Animate = $Character
@onready var Sprite = $Sprite
@onready var Jump_Smoke = $"Jump Smoke"
@onready var smoke_position = $Marker2D

const Speed = 200
const Air_Speed = 120
const Jump_Height = 450
const Sakura_Ulight_Jump = 15
const Gravity = 20

var jump_points = 2


@export var Health: int


enum States {
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
	DeactivateSuper, 
	IdleSuper, 
	RunSuper, 
	JumpSuper, 
	FallSuper, 
	NlightSuper, 
	SlightSuper, 
	DlightSuper, 
	UlightSuper,}
var Select = States.Standing

func go_into_nlight():
	if Input.is_action_pressed(controls.input_attack):
		Select = States.Nlight
		print("Nlight Active")
func go_into_slight():
	if Input.is_action_pressed(controls.input_down):
		if Input.is_action_pressed(controls.input_attack):
			Select = States.Dlight
			print("Slight Active")
func _jump_smoke():
	if is_on_floor():
		var instance_smoke_jump = jump_smoke.instantiate()
		instance_smoke_jump.global_position = smoke_position.global_position
		get_parent().add_child(instance_smoke_jump)
	
	
func _ready():
	pass
	
func _physics_process(delta):
	move_and_slide()

	match Select:

		States.Standing:
			velocity.y += Gravity
			if is_on_floor():
				set_collision_mask_value(3, true)
			if !is_on_floor():
				Select = States.Fall
			velocity.y += Gravity
			var controller_direction = Input.get_axis(controls.input_left, controls.input_right)
			if controller_direction:
				velocity.x = controller_direction * Speed
				Animate.play("Run")
			else:
				velocity.x = move_toward(velocity.x, 0, Speed)
				Animate.play("Idle")
				if Input.is_action_just_pressed(controls.input_dash):
					Select = States.Defend
				
			if Input.is_action_just_pressed(controls.input_attack):
				Select = States.Nlight
				
			if Input.is_action_pressed(controls.input_right) or Input.is_action_pressed(controls.input_left):
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Slight
			if velocity.x != 0:
				if Input.is_action_pressed(controls.input_left):
					if Input.is_action_just_pressed(controls.input_dash):
						Select = States.Roll
						velocity.x = -250
				if Input.is_action_pressed(controls.input_right):
					if Input.is_action_just_pressed(controls.input_dash):
						Select = States.Roll
						velocity.x = 250

			if Input.is_action_pressed(controls.input_down):
				
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Dlight
			
				await  get_tree().create_timer(0.2).timeout
				if Input.is_action_pressed(controls.input_down):
					set_collision_mask_value(3, false)
					
			if Input.is_action_pressed(controls.input_up):
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Ulight
			if is_on_floor():
				if Input.is_action_just_pressed(controls.input_jump):
					Select = States.Jump
			
			if Input.is_action_pressed(controls.input_right):
				Sprite.flip_h = false
				$"Scale Player".set_scale(Vector2(abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
		
			if Input.is_action_pressed(controls.input_left):
				Sprite.flip_h = true
				$"Scale Player".set_scale(Vector2(-abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
			
				
		States.Jump:
			
			if is_on_floor():
				Select = States.Standing
			lerp(velocity.y , 0.1, 0.03)
			velocity.y += Gravity
			if Input.is_action_pressed(controls.input_down):
				print("pressing downa")
				velocity.y += 50
				await  get_tree().create_timer(0.2).timeout
				set_collision_mask_value(3, false)
			else:
				set_collision_mask_value(3, true)
				velocity.y = 0
			if is_on_floor():
				Animate.play("Jump")
				velocity.y -= Jump_Height
			if velocity.y > 0:
				Select = States.Fall
				set_collision_mask_value(3, true)
				
			var direction = Input.get_axis(controls.input_left, controls.input_right)
			if direction:
				velocity.x = direction * Air_Speed
			else:
				velocity.x = move_toward(velocity.x, 0, Air_Speed)
			
				
			if Input.is_action_just_pressed(controls.input_attack):
				Select = States.Nair
				
			if Input.is_action_just_pressed(controls.input_right):
				Sprite.flip_h = false
				$"Scale Player".set_scale(Vector2(abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
		
			if Input.is_action_just_pressed(controls.input_left):
				Sprite.flip_h = true
				$"Scale Player".set_scale(Vector2(-abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
				
			if Input.is_action_just_pressed(controls.input_dash):
				Select = States.Defend
		States.Fall:
			velocity.y += Gravity
			Animate.play("Fall")
			if Input.is_action_pressed(controls.input_down):
				velocity.y += 10
				await  get_tree().create_timer(0.2).timeout
				set_collision_mask_value(3,false)
			else:
				set_collision_mask_value(3,true)
			var direction = Input.get_axis(controls.input_left, controls.input_right)
			if direction:
				velocity.x = direction * Air_Speed
			else:
				velocity.x = move_toward(velocity.x, 0, Air_Speed)
			
				
			if is_on_floor():
				Select = States.Standing
				set_collision_mask_value(3, true)
				
			if Input.is_action_just_pressed(controls.input_right):
				Sprite.flip_h = false
				$"Scale Player".set_scale(Vector2(abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
		
			if Input.is_action_just_pressed(controls.input_left):
				Sprite.flip_h = true
				$"Scale Player".set_scale(Vector2(-abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
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
			set_collision_mask_value(3, true)
			velocity.x = lerp(velocity.x , 0.1, 0.03)
			velocity.y = 0
			Animate.play("Dlight")
			
				
		States.Ulight:
			velocity.x = 0
			velocity.y = 0
			Animate.play("Ulight")
			
				
		States.Nair:
			velocity.x = 0
			velocity.y = 0
			Animate.play("Nair")

			
		States.Defend:
			velocity.x = 0
			velocity.y = 0
			Animate.play("Block")
			
		
			
			
		States.Roll:
			lerp(velocity.x , 0.1, 0.03)
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
		Animate.play("Idle")
	if anim_name == "Slight":
		Select = States.Standing
		Animate.play("Idle")

	if anim_name == "Ulight":
		Select = States.Standing
		Animate.play("Idle")
		
	if anim_name == "Dlight":
		Select = States.Standing
		Animate.play("Idle")
			
	
	if anim_name == "Nair":
		Select = States.Fall
		Animate.play("Fall")
	
	if anim_name == "Roll":
		Select = States.Standing
		Animate.play("Idle")
		
	if anim_name == "Block":
		if is_on_floor():
			Select = States.Standing
			Animate.play("Idle")
			
		else: 
			Select = States.Fall
			Animate.play("Fall")
	if anim_name == "Activate Super":
		Select = States.DeactivateSuper
	if anim_name == "Deactivate Super":
		Select = States.Standing


func _on_jump_smoke_animation_looped():
	Jump_Smoke.frame = 0 
	Jump_Smoke.stop()
	Jump_Smoke.visible = false
