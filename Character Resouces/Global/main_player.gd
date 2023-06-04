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
var can_change_dir = false
@export var Health: int

enum States {
	Idling,
	Jumping,
	Falling, 
	Nuetral_Light_Start,
	Nuetral_Light_Finish,
	Side_light, 
	Down_Light, 
	Up_Light_Start,
	Up_Light_Finsh,
	Nuetral_Air,
	Air_Defend, 
	Ground_Defend, 
	Dodge_Roll, 
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
var Select = States.Idling
func _idle_state_():
	Select = States.Standing
	Animate.play("Idle")
func _fall_state_():
	Select = States.Fall
	Animate.play("Fall")
func _nlight():
	if Input.is_action_pressed(controls.input_attack):
		Select = States.Nlight
func _nair():
	if Input.is_action_pressed(controls.input_attack):
		Select = States.Nair
func _dlight():
	if Input.is_action_pressed(controls.input_down):
		if Input.is_action_pressed(controls.input_attack):
			Select = States.Dlight
func _ulight():
	if Input.is_action_pressed(controls.input_up):
		if Input.is_action_pressed(controls.input_attack):
			Select = States.Ulight
func turn_around():
	if can_change_dir ==  false:
		if Input.is_action_just_pressed(controls.input_right):
			Sprite.flip_h = false
			$"Scale Player".set_scale(Vector2(abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
			can_change_dir = true
			print("right")
		elif Input.is_action_just_pressed(controls.input_left):
			Sprite.flip_h = true
			$"Scale Player".set_scale(Vector2(-abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
			can_change_dir = true
			print("left")
			
			
func drop_down():
	if Input.is_action_pressed(controls.input_down):
		velocity.y += 100
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
			if Input.is_action_pressed(controls.input_left):
				velocity.x = -Speed
				Animate.play("Run")
				Sprite.flip_h = true
				$"Scale Player".set_scale(Vector2(-abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Slight
				if velocity.x != 0:
					if Input.is_action_just_pressed(controls.input_dash):
						Select = States.Roll
						velocity.x = -270
			elif Input.is_action_pressed(controls.input_right):
				velocity.x = Speed
				Animate.play("Run")
				Sprite.flip_h = false
				$"Scale Player".set_scale(Vector2(abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Slight
				if velocity.x != 0:
					if Input.is_action_just_pressed(controls.input_dash):
						Select = States.Roll
						velocity.x = 270
			else:
				velocity.x = 0
				Animate.play("Idle")
				
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Nlight
					
				if Input.is_action_just_pressed(controls.input_dash):
					Select = States.GroundDefend
					
				
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
		States.Jump:
			set_collision_mask_value(3, false)
			velocity.y += Gravity
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
				
			if Input.is_action_just_pressed(controls.input_dash):
				Select = States.AirDefend
			
			if Input.is_action_pressed(controls.input_right):
				Sprite.flip_h = false
				$"Scale Player".set_scale(Vector2(abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
			
			if Input.is_action_pressed(controls.input_left):
				Sprite.flip_h = true
				$"Scale Player".set_scale(Vector2(-abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
		States.Fall:
			velocity.y += Gravity
			Animate.play("Fall")
			var direction = Input.get_axis(controls.input_left, controls.input_right)
			if direction:
				velocity.x = direction * Air_Speed
			else:
				velocity.x = move_toward(velocity.x, 0, Air_Speed)
			
			if Input.is_action_just_pressed(controls.input_dash):
				Select = States.AirDefend
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
			Animate.play("Nuetral Light Sarter")
		States.
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
			Animate.play("Up Light Statrter")
				
		States.Nair:
			velocity.y = 0
			Animate.play("Nair")
			
		States.GroundDefend:
			Animate.play("Ground Defend")
			velocity.y = 0
			velocity.x = 0
			
		States.AirDefend:
			Animate.play("Air Defend")
			velocity.x = 0
			velocity.y = 0
			
		States.Roll:
			turn_around()
			velocity.x = lerp(velocity.x , 0.01, 0.05)
			velocity.y += Gravity
			Animate.play("Roll")
			can_change_dir = false
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
			


func _on_nomad_nuetral_light_area_entered(area):
	Animate.play()
