extends CharacterBody2D
var controls: Resource = load("res://Character Resouces/Global/Controller Resource/Player_3.tres")
var jump_smoke = preload("res://Character Resouces/jump_smoke.tscn")
var counter_smoke = preload("res://Character Resouces/counter.tscn")
var sakura_ulight_smoke = preload("res://sakura_up_light_smoke.tscn")
@onready var Animate = $Character
@onready var Sprite = $Sprite
@onready var smoke_position = $Marker2D
@onready var super_energy = $"Super Energy"
@onready var deplete_energy = $"Deplete Energy"
@onready var refill_energy = $"Refill Energy"
const Speed = 150
const Acceleration = 10
const Air_Speed = 125
const Fall_Speed = 100
const Roll_Speed = 1000
const Jump_Height = 400
const Gravity = 15
var can_sakura_ulight_smoke = false
var can_jump_smoke = false
var sakura_ulight_active = false
var can_change_dir = false
var nomad_nlight_hit = false
var nomad_ulight_hit = false
var can_jump = false
var can_counter = false

var super_pts = 1
var current_super_pts = 1 
@export var Health: int
@export var Super_Pts: int

enum States {
	# Normal Mode Ststes. #
	Normal_Idling,
	Normal_Jumping,
	Normal_Falling, 
	Normal_Nuetral_Attack_Start,
	Normal_Nuetral_Attack_Finish,
	Nornmal_Side_Attack_Start,
	Normal_Side_Attack_Finish,
	Normal_Down_Attack, 
	Normal_Up_Attack_Start,
	Normal_Up_Attack_Finsh,
	Normal_Air_Attack,
	Normal_Air_Block, 
	Normal_Ground_Block, 
	Normal_Dash_Run, 
	Normal_Death, 
	Normal_Hurt,
	
	# Activate or Deactivare Super when meter reaches full. #
	Activate_Super, 
	Deactivate_Super, 
	
	# Super Mode Transformations States. #
	Super_Idling, 
	Super_Run, 
	Super_Jump, 
	Super_Fall, 
	Super_Nuetral_Attack_Starter,
	Super_Nuetral_Attack_Finisher,
	Super_Side_Attack_Starter,
	Super_Side_Attack_Finisher,
	Super_Down_Attack_Starter,
	Super_Down_Attack_Finisher, 
	Super_Up_Attack_Starter,
	Super_Up_Attack_Finisher,
	Super_Air_Attack
	}
# Default State when entering the scene tree. #
var Select = States.Normal_Idling

func _idle_energy_refill():
	if current_super_pts < 100:
		current_super_pts += super_pts
		
	else:
		current_super_pts = 100
	
func _deplete_energy():
	if current_super_pts < 0:
		Select = States.Deactivate_Super
# Check if nomad nlight or ulight starter hitbox detected the opponent to perfrom follow up attacks
func _transition_nuetral_attack_finisher():
	if nomad_nlight_hit == true:
		Select = States.Normal_Nuetral_Attack_Finish

func _reset_nomad_nuetral_attack():
	nomad_nlight_hit = false	

func  _transition_up_attack_finisher():
	if nomad_ulight_hit == true:
		Select = States.Normal_Up_Attack_Finsh
		
func _reset_nomad_ulight():
	nomad_ulight_hit = false

# Reset to idle and fall state after attacks 
func _idle_state_():
	Select = States.Normal_Idling
	Animate.play("Normal - Idle")
	
func _fall_state_():
	Select = States.Normal_Falling
	Animate.play("Fall")

func _super_idle_state():
	Select = States.Super_Idling
	Animate.play("Super - Idle")

func _super_fall_state():
	Select = States.Super_Fall
	Animate.play("Super - Fall")
	
# Between 2 and 5 frames player can perform a dodge roll
func _can_jump():
	can_jump = true
	
func _reset_jump():
	can_jump = false

# Perform attacks within 2-3 frames of the air block. #
func _counter_nuetral_attack():
	if Input.is_action_pressed(controls.input_attack):
		Select = States.Normal_Nuetral_Attack_Start
func _counter_side_attack():
	if Input.is_action_pressed(controls.input_left) or Input.is_action_pressed(controls.input_right):
		if Input.is_action_pressed(controls.input_attack):
			Select = States.Nornmal_Side_Attack_Start
func counter_down_attack():
	if Input.is_action_pressed(controls.input_down):
		if Input.is_action_pressed(controls.input_attack):
			Select = States.Normal_Down_Attack
func _counter_up_attack():
	if Input.is_action_pressed(controls.input_up):
		if Input.is_action_pressed(controls.input_attack):
			Select = States.Normal_Up_Attack_Start
			
# Reset Defend directional change at end of animation
func _reset_turn_around():
# Reset Defend directional change at end of animation
	can_change_dir = false
func turn_around():
	if can_change_dir ==  false:
		if Input.is_action_just_pressed(controls.input_right):
			Sprite.flip_h = false
			$"Scale Player".set_scale(Vector2(abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
			can_change_dir = true
		elif Input.is_action_just_pressed(controls.input_left):
			Sprite.flip_h = true
			$"Scale Player".set_scale(Vector2(-abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
			can_change_dir = true
			
			
func drop_down():
	if Input.is_action_pressed(controls.input_down):
		velocity.y += 100
		set_collision_mask_value(3, false)
	else:
		set_collision_mask_value(3, true)

func can_sakura_ulight():
	sakura_ulight_active = true
func _reset_sakura_ulight():
	sakura_ulight_active = false
func _activate_sakura_ulight_smoke():
	var instance_sakura_jump = sakura_ulight_smoke.instantiate()
	instance_sakura_jump.global_position = smoke_position.global_position
	get_tree().get_root().add_child(instance_sakura_jump)
	
# Activates jump and counter smoke at first frame of jumps and directional attacks.
func _activate_jump_smoke():
	var instance_smoke_jump = jump_smoke.instantiate()
	instance_smoke_jump.global_position = smoke_position.global_position
	get_tree().get_root().add_child(instance_smoke_jump)

func _activate_counter_smoke():
	var instance_smoke_counter = counter_smoke.instantiate()
	if can_counter == true:
		instance_smoke_counter.global_position = smoke_position.global_position
		get_tree().get_root().add_child(instance_smoke_counter)
# Reset counter smoke at the frist frame of idle and fall state.
func _reset_counter():
	# Reset counter after if player uses an attack or not.
	can_counter = false
 
func _ready():
	pass
func _process(delta):	

		
	if current_super_pts < 0:
		Select = States.Deactivate_Super
	super_energy.value = current_super_pts
	print(super_energy.value)
	move_and_slide()
	match Select:
		States.Activate_Super:
			Animate.play("Activate Super")
			velocity.x = 0
			velocity.y = 0
			deplete_energy.start()
		States.Deactivate_Super:
			Animate.play("Deactivate Super")
			velocity.x = 0
			velocity.y = 0
			deplete_energy.stop()
			current_super_pts = 0
		States.Normal_Idling:
			print(velocity)
			set_collision_mask_value(3, true)
			if !is_on_floor():
				Select = States.Normal_Falling
			velocity.y += Gravity
			if Input.is_action_pressed(controls.input_left):
				velocity.x = max(velocity.x -Acceleration, -Speed)
				Animate.play("Normal - Run")
				Sprite.flip_h = true
				$"Scale Player".set_scale(Vector2(-abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
				if velocity.x != 0:
					if Input.is_action_just_pressed(controls.input_dash):
						Select = States.Normal_Dash_Run
						velocity.x = -270
						set_collision_mask_value(2, false)
				
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Nornmal_Side_Attack_Start
			elif Input.is_action_pressed(controls.input_right):
				velocity.x = min(velocity.x + Acceleration, Speed)
				Animate.play("Normal - Run")
				Sprite.flip_h = false
				$"Scale Player".set_scale(Vector2(abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
	
				if velocity.x != 0:
					if Input.is_action_just_pressed(controls.input_dash):
						Select = States.Normal_Dash_Run
						velocity.x = 270
						set_collision_mask_value(2, false)
				
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Nornmal_Side_Attack_Start
			else:
				velocity.x = lerp(velocity.x, 0.0, 0.3)
				Animate.play("Normal - Idle")
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Normal_Nuetral_Attack_Start
					
				if Input.is_action_just_pressed(controls.input_dash):
					Select = States.Normal_Ground_Block
					
				if Input.is_action_just_pressed(controls.input_transform):
					Select = States.Activate_Super
				
			if Input.is_action_pressed(controls.input_down):
				
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Normal_Down_Attack
			
				await  get_tree().create_timer(0.2).timeout
				if Input.is_action_pressed(controls.input_down):
					set_collision_mask_value(3, false)
					
			if Input.is_action_pressed(controls.input_up):
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Normal_Up_Attack_Start
					
			if Input.is_action_just_pressed(controls.input_jump) and is_on_floor():
				Select = States.Normal_Jumping
		States.Super_Idling:
			set_collision_mask_value(3, true)
			if !is_on_floor():
				Select = States.Super_Fall
			velocity.y += Gravity
			if Input.is_action_pressed(controls.input_left):
				velocity.x = max(velocity.x -Acceleration, -Speed)
				Animate.play("Super - Run")
				Sprite.flip_h = true
				$"Scale Player".set_scale(Vector2(-abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
				
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Super_Side_Attack_Starter
					
			elif Input.is_action_pressed(controls.input_right):
				velocity.x = min(velocity.x + Acceleration, Speed)
				Animate.play("Super - Run")
				Sprite.flip_h = false
				$"Scale Player".set_scale(Vector2(abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
				
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Super_Side_Attack_Starter
			else:
				velocity.x = lerp(velocity.x, 0.0, 1)
				Animate.play("Super - Idle")
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Super_Nuetral_Attack_Starter
					
			if Input.is_action_pressed(controls.input_down):
				
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Super_Down_Attack_Starter
			
				await  get_tree().create_timer(0.2).timeout
				if Input.is_action_pressed(controls.input_down):
					set_collision_mask_value(3, false)
					
			if Input.is_action_pressed(controls.input_up):
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Super_Up_Attack_Starter
					
			if Input.is_action_just_pressed(controls.input_jump) and is_on_floor():
				Select = States.Super_Jump
		States.Normal_Jumping:
			set_collision_mask_value(3, false)
			velocity.y += Gravity
			if is_on_floor():
				Animate.play("Normal - Jump")
				velocity.y -= Jump_Height
			if velocity.y > 0:
				Select = States.Normal_Falling
				set_collision_mask_value(3, true)
			
			if Input.is_action_pressed(controls.input_left):
				velocity.x = max(velocity.x - Acceleration, -Air_Speed)
				Sprite.flip_h = true
				$"Scale Player".set_scale(Vector2(-abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
				
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Normal_Air_Attack
					
			elif Input.is_action_pressed(controls.input_right):
				velocity.x = min(velocity.x + Acceleration, Air_Speed)
				Sprite.flip_h = false
				$"Scale Player".set_scale(Vector2(abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
				
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Normal_Air_Attack
					
			else:
				velocity.x = lerp(velocity.x, 0.0, 0.01)
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Normal_Air_Attack
					
			if Input.is_action_just_pressed(controls.input_dash):
				Select = States.Normal_Air_Block
		States.Super_Jump:
			set_collision_mask_value(3, false)
			velocity.y += Gravity
			if is_on_floor():
				Animate.play("Super - Jump")
				velocity.y -= Jump_Height
			if velocity.y > 0:
				Select = States.Super_Fall
				set_collision_mask_value(3, true)
			
			if Input.is_action_pressed(controls.input_left):
				velocity.x = max(velocity.x - Acceleration, -Air_Speed)
				Sprite.flip_h = true
				$"Scale Player".set_scale(Vector2(-abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Super_Air_Attack
			elif Input.is_action_pressed(controls.input_right):
				velocity.x = min(velocity.x + Acceleration, Air_Speed)
				Sprite.flip_h = false
				$"Scale Player".set_scale(Vector2(abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Super_Air_Attack
			else:
				velocity.x = 0
				if Input.is_action_just_pressed(controls.input_attack):
					Select = States.Super_Air_Attack
		States.Normal_Falling:
			if Input.is_action_pressed(controls.input_left):
				Sprite.flip_h = true
				$"Scale Player".set_scale(Vector2(-abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
				velocity.x = max(velocity.x - Acceleration, -Fall_Speed)
			elif Input.is_action_pressed(controls.input_right):
				Sprite.flip_h = false
				$"Scale Player".set_scale(Vector2(abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
				velocity.x = min(velocity.x + Acceleration, Fall_Speed)
				
			else:
				velocity.x = lerp(velocity.x, 0.0, 0.05)
			

			if !is_on_floor():
				Animate.play("Normal - Fall")
				velocity.y += Gravity
			else:
				Select = States.Normal_Idling
				Animate.play("Normal - Idle")
		States.Super_Fall:
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
			

			if !is_on_floor():
				Animate.play("Super - Fall")
				velocity.y += Gravity
			else:
				Select = States.Super_Idling
				Animate.play("Super - Idle")
		
		States.Normal_Nuetral_Attack_Start:
			velocity.x = 0
			velocity.y = 0
			Animate.play("Normal - Nuetral Attack Starter")
		
		States.Super_Nuetral_Attack_Starter:
			velocity.x = 0
			velocity.y = 0
			Animate.play("Super - Nuetral Attack")
		
		States.Normal_Nuetral_Attack_Finish:
			Animate.play("Normal - Nuetral Attack Finisher")
			velocity.x = 0
			velocity.y = 0
			nomad_nlight_hit = false
		States.Nornmal_Side_Attack_Start:
			velocity.x = 0
			velocity.y = 0
			Animate.play("Normal - Side Attack Starter")
		
		States.Super_Side_Attack_Starter:
			velocity.x = 0
			velocity.y = 0
			Animate.play("Super - Side Attack Starter")
		States.Normal_Side_Attack_Finish:
			velocity.x = 0
			velocity.y = 0
			Animate.play("Normal - Side Attack Finisher")
		States.Normal_Down_Attack:
			velocity.y = 0
			velocity.x = 0
			Animate.play("Normal - Down Attack")
		
		States.Super_Down_Attack_Starter:
			velocity.x = 0
			velocity.y = 0
			Animate.play("Super - Down Attack")
		States.Normal_Up_Attack_Start:
			# At frame 1 start up sakura. #
			if sakura_ulight_active == true:
				velocity.y = -200
				velocity.y += Gravity
			else:
				velocity.y = 0
			velocity.x = 0
			Animate.play("Normal - Up Attack Starter")
		States.Normal_Up_Attack_Finsh:
			velocity.x = 0
			velocity.y = 0
			Animate.play("Up Light Finisher")
			nomad_ulight_hit = false
		States.Super_Up_Attack_Starter:
			velocity.x = 0
			velocity.y = 0
			Animate.play("Super - Up Attack")
		States.Normal_Air_Attack:
			velocity.x = lerp(velocity.x , 0.01, 0.06)
			velocity.y = 0
			Animate.play("Normal - Air Attack")
		
		States.Super_Air_Attack:
			velocity.x = lerp(velocity.x , 0.01, 0.06)
			velocity.y = 0
			Animate.play("Super - Air Attack")
			
		States.Normal_Ground_Block:
			turn_around()
			Animate.play("Normal - Ground Block")
			velocity.y = 0
			velocity.x = 0
		States.Normal_Air_Block:
			turn_around()
			Animate.play("Normal - Air Block")
			velocity.x = 0
			velocity.y = 0
			# Activate counter smoke to be called during an attack.
			can_counter = true
		States.Normal_Dash_Run:
			if can_jump == true:
				if Input.is_action_just_pressed(controls.input_jump):
					Select = States.Normal_Jumping
			turn_around()
			velocity.x = lerp(velocity.x , 0.0, 0.5)
			velocity.y += Gravity
			Animate.play("Normal - Dodge Dash")
			can_change_dir = false
			
			if Input.is_action_just_pressed(controls.input_dash):
				Select = States.Normal_Idling
		States.Normal_Death:
			Animate.play("Normal - Death")
			
		States.Normal_Hurt:
			velocity.x = 0
			Animate.play("Normal - Hurt")

			


func _on_up_light_hitbox_area_entered(area):
	if area:
		nomad_ulight_hit = true

func _on_nomad_nuetral_light_start_area_entered(area):
	if area:
		nomad_nlight_hit = true

func _on_nomad_nuetral_light_finish_area_entered(area):
	if area:
		nomad_nlight_hit = true

func _on_hurtbox_area_entered(area):
	Select = States.Normal_Hurt

func _on_deplete_energy_timeout():
	current_super_pts -= super_pts	

