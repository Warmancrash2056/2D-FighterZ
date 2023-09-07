extends CharacterBody2D

# Get character Resources
var controls: Resource = preload("res://Character Resouces/Global/Controller Resource/Player_3.tres")
var jump_smoke = preload("res://Character Resouces/jump_smoke.tscn")
var sakura_ulight_smoke = preload("res://Character Resouces/Sakura/Projectile/sakura_up_attack_smoke.tscn")
var counter_smoke = preload("res://Character Resouces/Global/counter.tscn")
var dash_smoke = preload("res://Character Resouces/Global/dash_smoke.tscn")
var hunter_side_attack_arrow = preload( "res://Character Resouces/Hunter/Projectile/Hunter Side Attack Arrow.tscn")
var general_nuetral_attack_fireball = preload("res://Character Resouces/General Archfield/Projectile/General Archfield Super Side Attack Projectile.tscn")
var hunter_super_side_attack_spear = preload("res://Character Resouces/Hunter/Projectile/projectiles_and_effects/Hunter Super Spear.tscn")
var hunter_down_attack_shower = preload("res://Character Resouces/Hunter/Projectile/Hunter Arrow Shower .tscn")
var hunter_air_attack_arrow = preload("res://Character Resouces/Hunter/Projectile/Hunter Air Attack Arrow.tscn")


@onready var Animate = $Character
@onready var Sprite = $Sprite
@onready var smoke_position = $"Jump Smoke"
@onready var counter_position = $"Counter Position"
@onready var block_timer = $"Refresh Block"
@onready var dash_smoke_position = $"Scale Player/Dash Smoke Position"
@onready var hunter_super_side_attack_position = $"Scale Player/Hunter Super Side Attack Position"
@onready var hunter_side_arrow_position = $"Scale Player/Hunter Side Attack Arrow Position"
@onready var hunter_super_nuetral_position = $"Scale Player/Hunter Super Nuetral Attack Position"
@onready var hunter_air_attack_position = $"Scale Player/Hunter Air Attack Position"
@onready var hunter_down_attack_position = $"Scale Player/Hunter Down Attack Position"
# General Archfield Fireball Position #
@onready var general_arcfield_fireball_position = $"Scale Player/Super Projectile Position"

# Used to detect if there is a wall.
@onready var right_wall_detection = $Right
@onready var left_wall_detection = $Left
var goku_selected = false
var general_selected = false
var nomad_selected = false
var sakura_selected = false
var hunter_selected = false
var atlantis_selected = false
var henry_selected = false


var Speed = 0
var Acceleration = 50
var Air_Speed = 0
var Fall_Speed = 0
var Roll_Speed = 600
var Jump_Height = 600
var Gravity = 25

var can_sakura_ulight_smoke = false
var can_jump_smoke = false
var sakura_ulight_active = false
var can_change_dir = false

var nomad_nuetral_attack_hit = false
var nomad_up_attack_hit = false

var can_jump = false
var can_counter = false
var block_active = false
var attack_active = false

var jump_count = 3
# Increment super points every hit 
var add_super_pts = 5

# Current Supe pts available at the start of match 
var current_super_pts = 0

@export var Health: int
@export var Super_Pts: int

enum States {
	# Normal Mode Ststes. #
	Idling,
	Jumping,
	Landing,
	Falling,
	
	Air_Projectile,
	Ground_Projectile,
	
	Nuetral_Light,
	Nuetral_Air,
	Nuetral_Heavy,
	# Nuetral is a heavy input that lift the player up.
	Nuetral_Recovery,
	
	Side_Heavy,
	Side_Light,
	Side_Air,
	Side_Air_Heavy,
	
	Down_Light,
	Down_Heavy,
	Down_Air,
	Down_Air_Heavy,
	
	
	Air_Block, 
	Ground_Block, 
	
	Dash_Run, 
	Death, 
	Hurt,
	Respawn,
	Left_Wall,
	Right_Wall
	}
	
func _goku_stats():
	CharacterList.goku_selected = true
	goku_selected = true
	Speed = 350
	Air_Speed = 150
	Fall_Speed = 100
	
func _hunter_stats():
	hunter_selected = true
	Speed = 350
	Air_Speed = 350
	Fall_Speed = 150
	
func _general_stats():
	nomad_selected = true
	Speed = 125
	Air_Speed = 250
	Fall_Speed = 175
	
	
	
# Default State when entering the scene tree. #
var Select = States.Respawn

func _reset_nomad_nuetral_attack():
	nomad_nuetral_attack_hit = false	

	
func _reset_nomad_up_attack():
	nomad_up_attack_hit = false

# Reset to idle and fall state after attacks 
func _idle_state_():
	Select = States.Idling
	Animate.play("Idle")
	
func _fall_state_():
	Select = States.Falling
	Animate.play("Fall")

	
# Between 2 and 5 frames player can perform a dodge roll
func _can_jump():
	can_jump = true
	
func _reset_jump():
	can_jump = false

# Perform attacks within 2-3 frames of the air block. #
func _counter_nuetral_light():
	if Input.is_action_pressed(controls.light):
		Select = States.Nuetral_Light

func _counter_nuetral_heavy():
	if Input.is_action_pressed(controls.heavy):
		Select = States.Nuetral_Heavy
		
func _counter_side_light():
	if Input.is_action_pressed(controls.left) or Input.is_action_pressed(controls.right):
		if Input.is_action_pressed(controls.light):
			Select = States.Side_Heavy
			print("counter side light")
func _counter_side_heavy():
	if Input.is_action_pressed(controls.left) or Input.is_action_pressed(controls.right):
		if Input.is_action_pressed(controls.light):
			Select = States.Side_Heavy
			
func counter_dowm_light():
	if Input.is_action_pressed(controls.down):
		if Input.is_action_pressed(controls.heavy):
			Select = States.Down_Heavy
func counter_down_heavy():
	if Input.is_action_pressed(controls.down):
		if Input.is_action_pressed(controls.heavy):
			Select = States.Down_Light
			
# Reset Defend directional change at end of animation
func _reset_turn_around():
# Reset Defend directional change at end of animation
	can_change_dir = false
func turn_around():
	if can_change_dir ==  false:
		if Input.is_action_just_pressed(controls.right):
			Sprite.flip_h = false
			$"Scale Player".set_scale(Vector2(abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
			CharacterList.main_player_facing_left = false
			can_change_dir = true
		elif Input.is_action_just_pressed(controls.left):
			Sprite.flip_h = true
			$"Scale Player".set_scale(Vector2(-abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
			CharacterList.main_player_facing_left = true
			can_change_dir = true
			
func _general_archfield_freball():
	var instance_fireball = general_nuetral_attack_fireball.instantiate()
	instance_fireball.global_position = general_arcfield_fireball_position.global_position
	get_tree().get_root().add_child(instance_fireball)
	if CharacterList.main_player_facing_left == true:
		instance_fireball.velocity.x = -100
		instance_fireball.scale.x = -1
	else:
		instance_fireball.velocity.x = 100
		
		instance_fireball.scale.x = 1
		
func hunter_spear_throw():
	var instance_spear = hunter_super_side_attack_spear.instantiate()
	instance_spear.global_position = hunter_super_side_attack_position.global_position
	get_tree().get_root().add_child(instance_spear)
	
	if CharacterList.main_player_facing_left == true:
		instance_spear.velocity.x = -700
		instance_spear.scale.x = -1
	else:
		instance_spear.velocity.x = 700
		instance_spear.scale.x = 1
		
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
		instance_smoke_counter.global_position = counter_position.global_position
		get_tree().get_root().add_child(instance_smoke_counter)
# Reset counter smoke at the frist frame of idle and fall state.
func _reset_counter():
	# Reset counter after if player uses an attack or not.
	can_counter = false
 
func _activate_dash_smoke():
	var instance_dash_smoke = dash_smoke.instantiate()
	instance_dash_smoke.global_position = dash_smoke_position.global_position
	get_tree().get_root().add_child(instance_dash_smoke)
	
func activate_hunter_side_attack():
	var instance_hunter_arrow = hunter_side_attack_arrow.instantiate()
	instance_hunter_arrow.global_position = hunter_side_arrow_position.global_position
	get_tree().get_root().add_child(instance_hunter_arrow)
	if CharacterList.main_player_facing_left == true:
		instance_hunter_arrow.velocity.x = -600
		instance_hunter_arrow.scale.x = -1
	else:
		instance_hunter_arrow.velocity.x = 600
		instance_hunter_arrow.scale.x = 1
func hunter_air_attack():
	var instance_arrow = hunter_air_attack_arrow.instantiate()
	instance_arrow.global_position = hunter_air_attack_position.global_position
	get_tree().get_root().add_child(instance_arrow)
	
	if CharacterList.main_player_facing_left == true:
		instance_arrow.velocity = Vector2(-150,150)
		instance_arrow.scale.x = -1
	else:
		instance_arrow.velocity = Vector2(150,150)
		instance_arrow.scale.x = 1
		
func hunter_down_attack():
	var instance_shower = hunter_down_attack_shower.instantiate()
	instance_shower.global_position = hunter_down_attack_position.global_position
	get_tree().get_root().add_child(instance_shower)
	
	if CharacterList.main_player_facing_left == true:
		instance_shower.scale.x = -1
	else:
		instance_shower.scale.x = 1
func _process(delta):
	if is_on_floor():
		jump_count = 3
func _ready():
	pass
func _physics_process(delta):
	move_and_slide()
	match Select:
		States.Idling:
			set_collision_mask_value(3, true)
			if velocity.y > 200:
				Select = States.Jumping
				Animate.play("Fall")
			velocity.y += Gravity
			if Input.is_action_pressed(controls.left):
				velocity.x = max(velocity.x -Acceleration, -Speed)
				Animate.play("Run")
				Sprite.flip_h = true
				$"Scale Player".set_scale(Vector2(-abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
				CharacterList.main_player_facing_left = true
				if velocity.x != 0:
					if Input.is_action_just_pressed(controls.dash):
						Select = States.Dash_Run
						velocity.x = -Roll_Speed
						set_collision_mask_value(2, false)
				
				if Input.is_action_just_pressed(controls.light):
					Select = States.Side_Light
				
				if Input.is_action_just_pressed(controls.heavy):
					Select = States.Side_Heavy
					
			elif Input.is_action_pressed(controls.right):
				velocity.x = min(velocity.x + Acceleration, Speed)
				Animate.play("Run")
				Sprite.flip_h = false
				$"Scale Player".set_scale(Vector2(abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
				CharacterList.main_player_facing_left = false
				if velocity.x != 0:
					if Input.is_action_just_pressed(controls.dash):
						Select = States.Dash_Run
						velocity.x = Roll_Speed
						set_collision_mask_value(2, false)
						
				
				if Input.is_action_just_pressed(controls.light):
					Select = States.Side_Light
				
				if Input.is_action_just_pressed(controls.heavy):
					Select = States.Side_Heavy
			else:
				velocity.x = lerp(velocity.x, 0.0, 0.3)
				Animate.play("Idle")
				if Input.is_action_just_pressed(controls.light):
					Select = States.Nuetral_Light
					
				if Input.is_action_just_pressed(controls.heavy):
					Select = States.Nuetral_Heavy
				if Input.is_action_just_pressed(controls.dash) and block_active == false:
					Select = States.Ground_Block
					block_active = true
				
				
				# New Mechanic for projectile throw	
				if Input.is_action_just_pressed(controls.throw):
					Select = States.Ground_Projectile
				
			if Input.is_action_pressed(controls.down):
				
				if Input.is_action_just_pressed(controls.heavy):
					Select = States.Down_Heavy
					
				if Input.is_action_just_pressed(controls.light):
					Select = States.Down_Light
			
				await  get_tree().create_timer(0.2).timeout
				if Input.is_action_pressed(controls.down):
					set_collision_mask_value(3, false)
					
					
			if Input.is_action_just_pressed(controls.jump) and jump_count > 0:
				Select = States.Jumping
				jump_count -= 1
				_activate_jump_smoke()
				$"Character Jump Sound".play()
				velocity.y = -Jump_Height 
		States.Jumping:
			velocity.y += Gravity
			Animate.play("Jump")
			
			
			if Input.is_action_pressed(controls.down):
				velocity.y += 40
				set_collision_mask_value(3, false)
			else:
				set_collision_mask_value(3, true)
				
			if is_on_wall():
				if left_wall_detection.is_colliding():
					Select = States.Left_Wall
				else:
					if right_wall_detection.is_colliding():
						Select = States.Right_Wall
		
		
			if is_on_floor():
				Select = States.Idling
				set_collision_mask_value(3, true)
			if jump_count > 0:
				if Input.is_action_just_pressed(controls.jump):
					jump_count -= 1
					velocity.y = -Jump_Height
					Animate.play("Jump")
					_activate_jump_smoke()
					$"Character Jump Sound".play()
			if Input.is_action_pressed(controls.left):
				velocity.x = max(velocity.x - Acceleration, -Air_Speed)
				Sprite.flip_h = true
				$"Scale Player".set_scale(Vector2(-abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
				CharacterList.main_player_facing_left = true
				if Input.is_action_just_pressed(controls.light):
					Select = States.Side_Air
					
			elif Input.is_action_pressed(controls.right):
				velocity.x = min(velocity.x + Acceleration, Air_Speed)
				Sprite.flip_h = false
				$"Scale Player".set_scale(Vector2(abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
				CharacterList.main_player_facing_left = false
				if Input.is_action_just_pressed(controls.light):
					Select = States.Side_Air
					
					
			else:
				velocity.x = lerp(velocity.x, 0.0, 0.05)
				if Input.is_action_just_pressed(controls.light):
					Select = States.Nuetral_Air
				
				if Input.is_action_just_pressed(controls.throw):
					Select = States.Air_Projectile
			if Input.is_action_pressed(controls.down):
				if Input.is_action_just_pressed(controls.heavy):
					Select = States.Down_Air_Heavy
				
					
			if Input.is_action_just_pressed(controls.dash) and block_active == false:
				Select = States.Air_Block
				block_active = true
				set_collision_mask_value(3, true)
			
		States.Falling:
			Animate.play("Fall")
			if Input.is_action_pressed(controls.down):
				velocity.y += 20
				set_collision_mask_value(3, false)
			else:
				set_collision_mask_value(3, true)
			if is_on_wall():
				if left_wall_detection.is_colliding():
					Select = States.Left_Wall
				else:
					if right_wall_detection.is_colliding():
						Select = States.Right_Wall
			if Input.is_action_pressed(controls.left):
				Sprite.flip_h = true
				$"Scale Player".set_scale(Vector2(-abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
				CharacterList.main_player_facing_left = true
				velocity.x = max(velocity.x - Acceleration, -Fall_Speed)
			elif Input.is_action_pressed(controls.right):
				Sprite.flip_h = false
				$"Scale Player".set_scale(Vector2(abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
				velocity.x = min(velocity.x + Acceleration, Fall_Speed)
				CharacterList.main_player_facing_left = false
				
			else:
				velocity.x = lerp(velocity.x, 0.0, 0.05)
				
			if jump_count > 0:
				if Input.is_action_just_pressed(controls.jump):
					jump_count -= 1
					velocity.y = -Jump_Height
					Select = States.Jumping
					_activate_jump_smoke()
					$"Character Jump Sound".play()
			if Input.is_action_just_pressed(controls.dash) and block_active == false:
				Select = States.Air_Block
				block_active = true

			if !is_on_floor():
				velocity.y += Gravity
			else:
				Select = States.Idling
				Animate.play("Idle")
				jump_count = 3
				
		States.Side_Light:
			velocity.x = lerp(velocity.x, 0.0, 0.3)
			velocity.y = 0
			Animate.play("Side Light Start")
		
		States.Side_Heavy:
			Animate.play("Side Heavy")
			velocity.x = lerp(velocity.x, 0.0, 0.3)
			velocity.y = 0
			
		States.Side_Air:
			Animate.play("Side Air")
			velocity.x = lerp(velocity.x , 0.0, 0.05)
			velocity.y = 1
		States.Down_Light:
			Animate.play("Down Light")
			velocity.x = lerp(velocity.x, 0.0, 0.3)
			velocity.y = 0
			
		States.Down_Heavy:
			velocity.x = lerp(velocity.x, 0.0, 0.3)
			velocity.y = 0
			Animate.play("Down Heavy")
		States.Down_Air:
			pass
		States.Down_Air_Heavy:
			Animate.play("Down Air Heavy")
			velocity.x = lerp(velocity.x , 0.0, 0.08)
			velocity.y = 0
		States.Nuetral_Light:
			velocity.x = lerp(velocity.x, 0.0, 0.3)
			velocity.y = 0
			Animate.play("Nuetral Light")
		
		States.Nuetral_Heavy:
			# At frame 1 start up sakura. #
			if sakura_ulight_active == true:
				velocity.y = -200
				velocity.y += Gravity
			else:
				velocity.y = 0
			velocity.x = lerp(velocity.x, 0.0, 0.05)
			velocity.y = 0
			Animate.play("Nuetral Heavy")
		States.Nuetral_Air:
			velocity.x = lerp(velocity.x , 0.0, 0.05)
			velocity.y = 10
			Animate.play("Nuetral Air")
		
		States.Ground_Block:
			#  Activate turn around at the start of the state. #
			turn_around()
			Animate.play("Ground Block")
			velocity.y = 0
			velocity.x = 0
			block_timer.start()
		States.Air_Block:
			#  Activate turn around at the start of the state. #
			turn_around()
			Animate.play("Air Block")
			velocity.x = lerp(velocity.x, 0.0, 0.05)
			velocity.y = 0
			block_timer.start()
			# Activate counter smoke to be called during an attack.
			can_counter = true
		States.Dash_Run:
			if can_jump == true:
				if Input.is_action_just_pressed(controls.jump):
					Select = States.Jumping
					velocity.y = -Jump_Height
					_activate_jump_smoke()
					$"Character Jump Sound".play()
			velocity.x = lerp(velocity.x , 0.0, 0.01)
			velocity.y += Gravity
			Animate.play("Dash")
			
			if block_timer.time_left == 0:
				if Input.is_action_just_pressed(controls.dash):
					Select = States.Ground_Block
			
			if velocity.y > 200:
				Select = States.Falling
				
			if CharacterList.main_player_facing_left == true:
				if Input.is_action_just_pressed(controls.right):
					Select = States.Idling
					velocity.x = 0
					
			else:
				if Input.is_action_just_pressed(controls.left):
					Select = States.Idling
					velocity.x = 0
		States.Hurt:
			Animate.play("Hurt")
		
		States.Respawn:
			Animate.play("Respawn")
			velocity.x = 0
			velocity.y = 0
		States.Right_Wall:
			jump_count = 3
			Animate.play("Wall")
			velocity.y = 1
			velocity.x = 0
			Sprite.flip_h = true
			$"Scale Player".set_scale(Vector2(abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
			if Input.is_action_pressed(controls.left):
				if Input.is_action_just_pressed(controls.jump):
					velocity.x = -200
					Select = States.Jumping
					velocity.y = -Jump_Height
					_activate_jump_smoke()
					$"Character Jump Sound".play()
		States.Left_Wall:
			jump_count = 3
			Animate.play("Wall")
			velocity.y = 1
			velocity.x = 0
			Sprite.flip_h = false
			$"Scale Player".set_scale(Vector2(-abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
			
			if Input.is_action_pressed(controls.right):
				if Input.is_action_just_pressed(controls.jump):
					Select = States.Jumping
					velocity.x = 200
					velocity.y = -Jump_Height
					print("On Left Side")
					_activate_jump_smoke()
					$"Character Jump Sound".play()
			velocity.y += Gravity
		States.Air_Projectile:
			Animate.play("Air Projectile")
			velocity.x = lerp(velocity.x , 0.0, 0.05)
			velocity.y = 0
		
		States.Ground_Projectile:
			Animate.play("Ground Projectile")
			velocity.x = 0
			velocity.y = 0
func _on_hurtbox_area_entered(area):
	Select = States.Hurt


func _on_area_2d_area_entered(area):
	CharacterList.health -= 10
	if area.is_in_group("Off Stage - Galvin"):
		position = CharacterList.galvin_player_respawn
		Select = States.Respawn	
		$Area2D/Respawn.play("Invisibilty")
		print('respawn')


func _on_refresh_block_timeout():
		block_active = false
