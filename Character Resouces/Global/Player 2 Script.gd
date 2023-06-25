extends CharacterBody2D

var controls: Resource = load("res://Character Resouces/Global/Controller Resource/Player_2.tres")
var jump_smoke = preload("res://Character Resouces/jump_smoke.tscn")
@onready var Animate = $Character
@onready var Sprite = $Sprite
@onready var smoke_position = $Marker2D

const Speed = 170
const Acceleration = 25
const Air_Speed = 135
const Fall_Speed = 100
const Roll_Speed = 400
const Jump_Height = 600
const Gravity = 30
var can_change_dir = false
var nomad_nlight_hit = false
var nomad_ulight_hit = false
var can_jump = false
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

func _transition_nlight_finisher():
	if nomad_nlight_hit == true:
		Select = States.Nuetral_Light_Finish
	else:
		pass

func  _transition_ulight_finisher():
	if nomad_ulight_hit == true:
		Select = States.Up_Light_Finsh
	

func _idle_state_():
	nomad_nlight_hit = false
	can_jump = false
	Select = States.Idling
	Animate.play("Idle")
func _can_jump():
	can_jump = true
func _fall_state_():
	Select = States.Falling
func _nlight():
	if Input.is_action_pressed(controls.input_attack):
		Select = States.Nuetral_Light_Start
func _nair():
	if Input.is_action_pressed(controls.input_attack):
		Select = States.Nuetral_Air
func _dlight():
	if Input.is_action_pressed(controls.input_down):
		if Input.is_action_pressed(controls.input_attack):
			Select = States.Down_Light
func _ulight():
	if Input.is_action_pressed(controls.input_up):
		if Input.is_action_pressed(controls.input_attack):
			Select = States.Up_Light_Start
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
	get_tree().get_root().add_child(instance_smoke_jump)
func _process(delta):
	print(nomad_nlight_hit)
	move_and_slide()
	match Select:

		States.Idling:
			set_collision_mask_value(3, true)
			if !is_on_floor():
				Select = States.Falling
			velocity.y += Gravity
			if Input.is_action_pressed(controls.input_left):
				velocity.x = max(velocity.x -Acceleration, -Speed)
				Animate.play("Run")
				Sprite.flip_h = true
				$"Scale Player".set_scale(Vector2(-abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Side_light
				if velocity.x != 0:
					if Input.is_action_just_pressed(controls.input_dash):
						Select = States.Dodge_Roll
						velocity.x = -270
						set_collision_mask_value(2, false)
			elif Input.is_action_pressed(controls.input_right):
				velocity.x = min(velocity.x + Acceleration, Speed)
				Animate.play("Run")
				Sprite.flip_h = false
				$"Scale Player".set_scale(Vector2(abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Side_light
				if velocity.x != 0:
					if Input.is_action_just_pressed(controls.input_dash):
						Select = States.Dodge_Roll
						velocity.x = 270
						set_collision_mask_value(2, false)
			else:
				velocity.x = 0
				Animate.play("Idle")
				
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Nuetral_Light_Start
					
				if Input.is_action_just_pressed(controls.input_dash):
					Select = States.Ground_Defend
					
				
			if Input.is_action_pressed(controls.input_down):
				
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Down_Light
			
				await  get_tree().create_timer(0.2).timeout
				if Input.is_action_pressed(controls.input_down):
					set_collision_mask_value(3, false)
					
			if Input.is_action_pressed(controls.input_up):
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Up_Light_Start
					
			if Input.is_action_just_pressed(controls.input_jump) and is_on_floor():
				Select = States.Jumping
		States.Jumping:
			set_collision_mask_value(3, false)
			velocity.y += Gravity
			if is_on_floor():
				Animate.play("Jump")
				velocity.y -= Jump_Height
			if velocity.y > 0:
				Select = States.Falling
				set_collision_mask_value(3, true)
			
			if Input.is_action_pressed(controls.input_left):
				velocity.x = max(velocity.x - Acceleration, -Air_Speed)
				Sprite.flip_h = true
				$"Scale Player".set_scale(Vector2(-abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Nuetral_Air
			elif Input.is_action_pressed(controls.input_right):
				velocity.x = min(velocity.x + Acceleration, Air_Speed)
				Sprite.flip_h = false
				$"Scale Player".set_scale(Vector2(abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Nuetral_Air
			else:
				velocity.x = 0
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Nuetral_Air
					
				if Input.is_action_just_pressed(controls.input_dash):
					Select = States.Air_Defend
			
		States.Falling:
			if Input.is_action_pressed(controls.input_left):
				Sprite.flip_h = true
				$"Scale Player".set_scale(Vector2(-abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
				velocity.x = max(velocity.x - Acceleration, -Fall_Speed)
			elif Input.is_action_pressed(controls.input_right):
				Sprite.flip_h = false
				$"Scale Player".set_scale(Vector2(abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
				velocity.x = min(velocity.x + Acceleration, Fall_Speed)
				
			else:
				velocity.x = 0
				
				if Input.is_action_just_pressed(controls.input_dash):
					Select = States.Air_Defend
			if !is_on_floor():
				Animate.play("Fall")
				velocity.y += Gravity
			else:
				Select = States.Idling
				_activate_jump_smoke()
		States.Nuetral_Light_Start:
			velocity.x = 0
			velocity.y = 0
			Animate.play("Nuetral Light Sarter")
		States.Nuetral_Light_Finish:
			Animate.play("Nuetral Light Finisher")
			velocity.x = 0
			velocity.y = 0
			nomad_nlight_hit = false
		States.Side_light:
			velocity.x = 0
			velocity.y = 0
			Animate.play("Slight")

		States.Down_Light:
			velocity.y = 0
			velocity.x = 0
			Animate.play("Dlight")
				
		States.Up_Light_Start:
			velocity.y = 0
			velocity.x = 0
			Animate.play("Up Light Starter")
		States.Up_Light_Finsh:
			velocity.x = 0
			velocity.y = 0
			Animate.play("Up Light Finisher")
			nomad_ulight_hit = false
		States.Nuetral_Air:
			velocity.x = lerp(velocity.x , 0.01, 0.06)
			velocity.y = 0
			Animate.play("Nair")
			
		States.Ground_Defend:
			turn_around()
			Animate.play("Ground Defend")
			velocity.y = 0
			velocity.x = 0
			can_change_dir = false
		States.Air_Defend:
			turn_around()
			Animate.play("Air Defend")
			velocity.x = 0
			velocity.y = 0
			can_change_dir = false
			
		States.Dodge_Roll:
			if can_jump == true:
				if Input.is_action_just_pressed(controls.input_jump):
					Select = States.Jumping
					print("dodge to jump")
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
	if area:
		nomad_nlight_hit = true
		


func _on_up_light_hitbox_area_entered(area):
	if area:
		nomad_ulight_hit = true
		print(nomad_ulight_hit)

