extends CharacterBody2D
var controls: Resource = load("res://Character Resouces/Global/Controller Resource/Player_3.tres")
var jump_smoke = preload("res://jump_smoke.tscn")
@onready var Animate = $Character
@onready var Sprite = $Sprite
@onready var smoke_position = $Marker2D

const Speed = 200
const Air_Speed = 220
const Jump_Height = 450
const Gravity = 20

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

func drop_down():
	if Input.is_action_pressed(controls.input_down):
		velocity.y += 20
		set_collision_mask_value(3, false)
	else:
		set_collision_mask_value(3, true)
		

func _activate_jump_smoke():
	var instance_smoke_jump = jump_smoke.instantiate()
	instance_smoke_jump.global_position = smoke_position.global_position
	get_parent().add_child(instance_smoke_jump)
func _process(delta):
	move_and_slide()
	match Select:

		States.Standing:
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
					if Input.is_action_just_pressed(controls.input_dash):
						Select = States.Roll
			if Input.is_action_pressed(controls.input_down):
				
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Dlight
			
				await  get_tree().create_timer(0.2).timeout
				if Input.is_action_pressed(controls.input_down):
					set_collision_mask_value(3, false)
					
			if Input.is_action_pressed(controls.input_up):
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Ulight
					
			if Input.is_action_just_pressed(controls.input_jump) and is_on_floor():
				Select = States.Jump
			if Input.is_action_pressed(controls.input_right):
				Sprite.flip_h = false
				$"Scale Player".set_scale(Vector2(abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
			
			if Input.is_action_pressed(controls.input_left):
				Sprite.flip_h = true
				$"Scale Player".set_scale(Vector2(-abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
		States.Jump:
			set_collision_mask_value(3, false)
			velocity.y += Gravity
			if is_on_floor():
				Animate.play("Jump")
				velocity.y -= Jump_Height
			if velocity.y > 0:
				Select = States.Fall
				set_collision_mask_value(3, true)
			
			if Input.is_action_pressed(controls.input_down):
				velocity.y += 20
				set_collision_mask_value(3, false)
			else:
				set_collision_mask_value(3, true)
				
			var direction = Input.get_axis(controls.input_left, controls.input_right)
			if direction:
				velocity.x = direction * Air_Speed
			else:
				velocity.x = move_toward(velocity.x, 0, Air_Speed)
			
				
			if Input.is_action_just_pressed(controls.input_attack):
				Select = States.Nair
				
			if Input.is_action_just_pressed(controls.input_dash):
				Select = States.Defend
			
			if Input.is_action_pressed(controls.input_right):
				Sprite.flip_h = false
				$"Scale Player".set_scale(Vector2(abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
			
			if Input.is_action_pressed(controls.input_left):
				Sprite.flip_h = true
				$"Scale Player".set_scale(Vector2(-abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
		States.Fall:
			velocity.y += Gravity
			Animate.play("Fall")
			if Input.is_action_pressed(controls.input_down):
				velocity.y += 20
				set_collision_mask_value(3, false)
			else:
				set_collision_mask_value(3, true)
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
			velocity.y = 0
			Animate.play("Nlight")
			
		States.Slight:
			velocity.x = 0
			velocity.y = 0
			Animate.play("Slight")

		States.Dlight:
			velocity.y = 0
			velocity.x = 0
			Animate.play("Dlight")
				
		States.Ulight:
			velocity.y = 0
			velocity.x = 0
			Animate.play("Ulight")
				
		States.Nair:
			velocity.y = 0
			Animate.play("Nair")
			
		States.Defend:
			Animate.play("Block")
			velocity.y = 0
			velocity.x = 0
			
		States.Roll:
			velocity.x = lerp(velocity.x , 0.01, 0.02)
			velocity.y = 0
			Animate.play("Roll")
				
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
