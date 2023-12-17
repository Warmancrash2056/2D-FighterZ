class_name Player2 extends CharacterBody2D
# Get character Resources
var controls: Resource = preload("res://Character Resouces/Global/Controller Resource/Player_2.tres")


# Get character Resources
var sakura_ulight_smoke = preload("res://Character Resouces/Sakura/Projectile/sakura_up_attack_smoke.tscn")

var jump_smoke = preload("res://Character Resouces/jump_smoke.tscn")
var counter_smoke = preload("res://Character Resouces/Global/counter.tscn")
var dash_smoke = preload("res://Character Resouces/Global/dash_smoke.tscn")
var wall_jump_smoke = preload("res://Autoloads/wall_jump_cloud.tscn")

var hunter_side_attack_arrow = preload( "res://Character Resouces/Hunter/Projectile/Hunter Side Attack Arrow.tscn")
var hunter_super_side_attack_spear = preload("res://Character Resouces/Hunter/Projectile/projectiles_and_effects/Hunter Super Spear.tscn")
var hunter_down_attack_shower = preload("res://Character Resouces/Hunter/Projectile/Hunter Arrow Shower .tscn")
var hunter_air_attack_arrow = preload("res://Character Resouces/Hunter/Projectile/Hunter Air Attack Arrow.tscn")

var general_nuetral_attack_fireball = preload("res://Character Resouces/General Archfield/Projectile/General Archfield Super Side Attack Projectile.tscn") # Goku Projectile Position #
# Goku Projectile Position #
@onready var goku_projectile_position = $"Scale Player/Goku Projectile Position"
var goku_air_projectile = preload("res://Character Resouces/Goku/Goku Air Projectile.tscn")
var goku_ground_projectiles = preload("res://Character Resouces/Goku/Goku Ground Projectile.tscn")
var side_registered = false
@onready var Animate: AnimationPlayer = $Character
@onready var Invisibilty = $Respawn
@onready var Sprite: Sprite2D = $Sprite
@onready var smoke_position: Marker2D = $"Jump Smoke"
@onready var wall_jump_smoke_position = $"Scale Player/Wall Jump Smoke"
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
@onready var recovery_timer = $"Recovery Timer"
var follow_goku_neutral_heavy = false
var attack_reset = false
# Goku Projectile Position #

var knockback_multiplier: float = 0.5
var knockback_x: float
var knockback_y: float

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


var Speed = 350
var Acceleration: int
var Air_Speed = 200
var Fall_Speed = 150
var Roll_Speed = 600
var Jump_Height = 500
var Gravity = 20

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


var Health: int

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
	Side_Transition,
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
	Acceleration = 270
	CharacterList.goku_selected = true
	goku_selected = true
	Health = 1000
	
func _general_stats():
	nomad_selected = true
	Speed = 125
	Air_Speed = 250
	Fall_Speed = 175

func _sakura_stats():
	pass

func _nomad_stats():
	pass



# Default State when entering the scene tree. #
var Select = States.Respawn

func _reset_nomad_nuetral_attack():
	nomad_nuetral_attack_hit = false


func _reset_nomad_up_attack():
	nomad_up_attack_hit = false

func _attack_reset():
	attack_reset = false
func quick_reset():
	follow_goku_neutral_heavy = false
	if attack_reset == true:
		if !is_on_floor():
			Select = States.Jumping
			Animate.play("Jump")
		else:
			Select = States.Idling
			Animate.play("Idle") 
	
	else:
		attack_reset = false
		
# Reset to idle and fall state after attacks
func _idle_state_():
	follow_goku_neutral_heavy = false
	if !is_on_floor():
		Select = States.Falling
		Animate.play("Fall")
	else:
		Select = States.Idling
		Animate.play("Idle")

# Between 2 and 5 frames player can perform a dodge roll
func _can_jump():
	can_jump = true

func _reset_jump():
	can_jump = false

# Perform attacks within 5-10 frames of the air block. #
func _counter_nuetral_light():
	if Input.is_action_pressed(controls.light):
		Select = States.Nuetral_Light

func _counter_nuetral_heavy():
	if Input.is_action_pressed(controls.heavy):
		Select = States.Nuetral_Heavy

func _counter_side_light():
	if Input.is_action_pressed(controls.left) or Input.is_action_pressed(controls.right):
		if Input.is_action_pressed(controls.light):
			Select = States.Side_Light
func _counter_side_heavy():
	if Input.is_action_pressed(controls.left) or Input.is_action_pressed(controls.right):
		if Input.is_action_pressed(controls.heavy):
			Select = States.Side_Heavy

func counter_dowm_light():
	if Input.is_action_pressed(controls.down):
		if Input.is_action_pressed(controls.light):
			Select = States.Down_Light
func counter_down_heavy():
	if Input.is_action_pressed(controls.down):
		if Input.is_action_pressed(controls.heavy):
			Select = States.Down_Heavy


# Reset Defend directional change at end of animation
func _reset_turn_around():
	can_change_dir = false
func turn_around():
	if can_change_dir ==  false:
		if Input.is_action_just_pressed(controls.right):
			Sprite.flip_h = false
			$"Scale Player".set_scale(Vector2(abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
			CharacterList.player_2_facing_left = false
			can_change_dir = true
		elif Input.is_action_just_pressed(controls.left):
			Sprite.flip_h = true
			$"Scale Player".set_scale(Vector2(-abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
			CharacterList.player_2_facing_left = true
			can_change_dir = true
# General Archfield Stats.
func _general_archfield_freball():
	var instance_fireball = general_nuetral_attack_fireball.instantiate()
	instance_fireball.global_position = general_arcfield_fireball_position.global_position
	get_tree().get_root().add_child(instance_fireball)
	if CharacterList.player_2_facing_left == true:
		instance_fireball.velocity.x = -100
		instance_fireball.scale.x = -1
	else:
		instance_fireball.velocity.x = 100

		instance_fireball.scale.x = 1

# Goku Stats
func _goku_side_finish():
	if side_registered == true:
		Select = States.Side_Transition
	
func _reset_side_transition():
	if side_registered == true:
		side_registered = false
func _goku_air_projectile():
	var instance_molten_sand = goku_air_projectile.instantiate()
	instance_molten_sand.global_position = goku_projectile_position.global_position
	get_tree().get_root().add_child(instance_molten_sand)

	if CharacterList.player_2_facing_left == true:
		instance_molten_sand.velocity.x = -700
		instance_molten_sand.scale.x = -1
	else:
		instance_molten_sand.velocity.x = 700
		instance_molten_sand.scale.x = 1
		
func _goku_ground_projectile():
	var instance_molten_earth = goku_ground_projectiles.instantiate()
	instance_molten_earth.global_position = goku_projectile_position.global_position
	get_tree().get_root().add_child(instance_molten_earth)

	if CharacterList.player_2_facing_left == true:
		instance_molten_earth.velocity.x = -700
		instance_molten_earth.scale.x = -1.5
	else:
		instance_molten_earth.velocity.x = 700
		instance_molten_earth.scale.x = 1.5
func hunter_spear_throw():
	var instance_spear = hunter_super_side_attack_spear.instantiate()
	instance_spear.global_position = hunter_super_side_attack_position.global_position
	get_tree().get_root().add_child(instance_spear)

	if CharacterList.player_2_facing_left == true:
		instance_spear.velocity.x = -700
		instance_spear.scale.x = -1.5
	else:
		instance_spear.velocity.x = 700
		instance_spear.scale.x = 1.5

# Sakura Nuetral Heavy Shuriken Star #
func _activate_sakura_nheavy(): # inside the nuetral heavy state set data for action specific to character.
	sakura_ulight_active = true
func _reset_sakura_nheavy(): # Deactivate once action finished
	sakura_ulight_active = false
func _activate_sakura_nheavy_smoke():
	var instance_sakura_jump = sakura_ulight_smoke.instantiate()
	instance_sakura_jump.global_position = smoke_position.global_position
	get_tree().get_root().add_child(instance_sakura_jump)


# Activates cloud effects at first frame of action.
func _activate_jump_smoke():
	var instance_smoke_jump = jump_smoke.instantiate()
	instance_smoke_jump.global_position = smoke_position.global_position
	get_tree().get_root().add_child(instance_smoke_jump)
func _activate_wall_jump_smoke():
	var instance_wall_jump = wall_jump_smoke.instantiate()
	instance_wall_jump.global_position = wall_jump_smoke_position.global_position
	get_tree().get_root().add_child(instance_wall_jump)

	if CharacterList.player_2_facing_left == true:
		instance_wall_jump.scale.y = 3
	else:
		instance_wall_jump.scale.y = -3

func _activate_counter_smoke():
	var instance_smoke_counter = counter_smoke.instantiate()
	if can_counter == true:
		instance_smoke_counter.global_position = counter_position.global_position
		get_tree().get_root().add_child(instance_smoke_counter)
# Reset counter smoke at the frist frame of idle and fall state.
func _reset_counter():
	can_counter = false

func _activate_dash_smoke():
	var instance_dash_smoke = dash_smoke.instantiate()
	instance_dash_smoke.global_position = dash_smoke_position.global_position
	get_tree().get_root().add_child(instance_dash_smoke)
	
	if CharacterList.player_2_facing_left == true:
		instance_dash_smoke.scale.x = -1
	else:
		instance_dash_smoke.scale.x = 1
# Hunter Stats
func activate_hunter_side_attack():
	var instance_hunter_arrow = hunter_side_attack_arrow.instantiate()
	instance_hunter_arrow.global_position = hunter_side_arrow_position.global_position
	get_tree().get_root().add_child(instance_hunter_arrow)
	if CharacterList.player_2_facing_left == true:
		instance_hunter_arrow.velocity.x = -600
		instance_hunter_arrow.scale.x = -1
	else:
		instance_hunter_arrow.velocity.x = 600
		instance_hunter_arrow.scale.x = 1
func hunter_air_attack():
	var instance_arrow = hunter_air_attack_arrow.instantiate()
	instance_arrow.global_position = hunter_air_attack_position.global_position
	get_tree().get_root().add_child(instance_arrow)

	if CharacterList.player_2_facing_left == true:
		instance_arrow.velocity = Vector2(-150,150)
		instance_arrow.scale.x = -1
	else:
		instance_arrow.velocity = Vector2(150,150)
		instance_arrow.scale.x = 1

func hunter_down_attack():
	var instance_shower = hunter_down_attack_shower.instantiate()
	instance_shower.global_position = hunter_down_attack_position.global_position
	get_tree().get_root().add_child(instance_shower)

	if CharacterList.player_2_facing_left == true:
		instance_shower.scale.x = -1
	else:
		instance_shower.scale.x = 1
func _hunter_stats():
	hunter_selected = true
	Speed = 350
	Air_Speed = 350
	Fall_Speed = 150
	
func _ready():
	CharacterList.player_1_health = Health
	Select = States.Respawn
	recovery_timer.start()

func _bounce():
	if is_on_wall():
		knockback_x *= -1
		
	elif is_on_ceiling():
		knockback_y *= -1
		
	if is_on_floor():
		knockback_y *= -1
	
func _reset_v():
	velocity.x = lerp(velocity.x, 0.0, 0.8)
	velocity.y = lerp(velocity.y, 0.0, 0.8)
	knockback_x = 0
	knockback_y = 0
func _activate_invisibility():
	Invisibilty.play("Invisibilty")
func _dodge_move():
	var move_x = Input.get_action_strength(controls.right) - Input.get_action_strength(controls.left)
	var move_y = Input.get_action_strength(controls.down) - Input.get_action_strength(controls.up)
			
	if move_x != 0:
		velocity.x = move_toward(velocity.x, move_x * 50, 10)
				
	if move_y != 0:
		velocity.y = move_toward(velocity.y, move_y * 50, 10)
func _process(delta):
	CharacterList.player_2_health = Health
	
	if CharacterList.player_2_health < 700 and CharacterList.player_2_health > 400:
		knockback_multiplier = 1.0
		
	elif CharacterList.player_2_health < 490 and CharacterList.player_2_health> 200 :
		knockback_multiplier = 1.3
		
	elif CharacterList.player_2_health < 200:
		knockback_multiplier = 1.6
		
	else:
		if CharacterList.player_1_health < 0:
			knockback_multiplier = 1.9
func _physics_process(delta):
	var move_vec = Input.get_action_strength(controls.right) - Input.get_action_strength(controls.left)
	move_and_slide()
	match Select:
		States.Idling:
			jump_count = 3
			set_collision_mask_value(3, true)
			if !is_on_floor():
				Select = States.Jumping
				Animate.play("Jump")
			velocity.y += Gravity
			if move_vec < 0:
				velocity.x = max(velocity.x -Acceleration, -Speed)
				Animate.play("Run")
				Sprite.flip_h = true
				$"Scale Player".set_scale(Vector2(-abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
				CharacterList.player_2_facing_left = true
				if velocity.x != 0:
					if Input.is_action_just_pressed(controls.dash):
						Select = States.Dash_Run
						set_collision_mask_value(2, false)
						
				if Input.is_action_just_pressed(controls.light):
					Select = States.Side_Light

				if Input.is_action_just_pressed(controls.heavy):
					Select = States.Side_Heavy

			elif move_vec > 0:
				velocity.x = min(velocity.x + Acceleration, Speed)
				Animate.play("Run")
				Sprite.flip_h = false
				$"Scale Player".set_scale(Vector2(abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
				CharacterList.player_2_facing_left = false
				if velocity.x != 0:
					if Input.is_action_just_pressed(controls.dash):
						Select = States.Dash_Run
						set_collision_mask_value(2, false)
						


				if Input.is_action_just_pressed(controls.light):
					Select = States.Side_Light

				if Input.is_action_just_pressed(controls.heavy):
					Select = States.Side_Heavy
			else:
				velocity.x = lerp(velocity.x, 0.0, 0.2)
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



			if Input.is_action_just_pressed(controls.jump) and jump_count > 0:
				Select = States.Jumping
				jump_count -= 1
				_activate_jump_smoke()
				$"Character Jump Sound".play()
				velocity.y = -Jump_Height
				Animate.play("Jump")
			elif Input.is_action_pressed(controls.down):

				if Input.is_action_just_pressed(controls.heavy):
					Select = States.Down_Heavy

				if Input.is_action_just_pressed(controls.light):
					Select = States.Down_Light

				await  get_tree().create_timer(0.2).timeout
				if Input.is_action_pressed(controls.down):
					set_collision_mask_value(3, false)


		States.Jumping:
			if move_vec < 0:
				velocity.x = max(velocity.x - Acceleration, -Air_Speed)
				Sprite.flip_h = true
				$"Scale Player".set_scale(Vector2(-abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
				CharacterList.player_2_facing_left = true
				if Input.is_action_just_pressed(controls.light):
					Select = States.Side_Air

			elif move_vec > 0:
				velocity.x = min(velocity.x + Acceleration, Air_Speed)
				Sprite.flip_h = false
				$"Scale Player".set_scale(Vector2(abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
				CharacterList.player_2_facing_left = false
				if Input.is_action_pressed(controls.light):
					Select = States.Side_Air

			else:
				velocity.x = lerp(velocity.x, 0.0, 0.1)
				if Input.is_action_just_pressed(controls.light):
					Select = States.Nuetral_Air

				if Input.is_action_just_pressed(controls.throw):
					Select = States.Air_Projectile
			
			if Input.is_action_pressed(controls.down):
				if Input.is_action_just_pressed(controls.light):
					Select = States.Down_Air
			if Input.is_action_just_pressed(controls.dash) and block_active == false:
				Select = States.Air_Block
				block_active = true
				set_collision_mask_value(3, true)
			
			velocity.y += Gravity
			Animate.play("Jump")

			if Input.is_action_pressed(controls.down):
				velocity.y += 15
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
			if Input.is_action_just_pressed(controls.jump) and jump_count > 0:
				jump_count -= 1
				velocity.y = -Jump_Height
				Animate.play("Jump")
				_activate_jump_smoke()
				$"Character Jump Sound".play()
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
			if move_vec < 0:
				Sprite.flip_h = true
				$"Scale Player".set_scale(Vector2(-abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
				CharacterList.player_2_facing_left = true
				velocity.x = max(velocity.x - Acceleration, -Fall_Speed)
			elif move_vec > 0:
				Sprite.flip_h = false
				$"Scale Player".set_scale(Vector2(abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
				velocity.x = min(velocity.x + Acceleration, Fall_Speed)
				CharacterList.player_2_facing_left = false

			else:
				velocity.x = lerp(velocity.x, 0.0, 0.1)

			if Input.is_action_just_pressed(controls.jump) and jump_count > 0:
				jump_count -= 1
				velocity.y = -Jump_Height
				Animate.play("Jump")
				_activate_jump_smoke()
				$"Character Jump Sound".play()
			if Input.is_action_just_pressed(controls.dash) and block_active == false:
				Select = States.Air_Block
				block_active = true
				set_velocity(Vector2.ZERO)

			if !is_on_floor():
				velocity.y += Gravity
			else:
				Select = States.Idling
				Animate.play("Idle")
				jump_count = 3

		States.Side_Light:
			velocity.x = lerp(velocity.x, 0.0, 0.7)
			velocity.y = 0
			Animate.play("Side Light Start")
		States.Side_Transition:
			velocity.x = 0
			velocity.y = 0
			Animate.play("Side Light Finisher")
		States.Side_Heavy:
			Animate.play("Side Heavy")
			velocity.x = lerp(velocity.x, 0.0, 0.8)
			velocity.y = 0

		States.Side_Air:
			Animate.play("Side Air")
			velocity.x = lerp(velocity.x , 0.0, 0.1)
			velocity.y = 0
		States.Down_Light:
			Animate.play("Down Light")
			velocity.x = lerp(velocity.x, 0.0, 0.9)
			velocity.y = 0

		States.Down_Heavy:
			velocity.x = lerp(velocity.x, 0.0, 0.6)
			velocity.y = 0
			Animate.play("Down Heavy")
		States.Down_Air:
			velocity.x = lerp(velocity.x, 0.0, 0.1)
			velocity.y = 5
			Animate.play("Down Air")
		States.Down_Air_Heavy:
			Animate.play("Down Air Heavy")
			velocity.x = lerp(velocity.x , 0.0, 0.9)
			velocity.y = 0
		States.Nuetral_Light:
			velocity.x = lerp(velocity.x, 0.0, 0.4)
			velocity.y = 0
			Animate.play("Nuetral Light")

		States.Nuetral_Heavy:
			# At frame 1 start up sakura. #
			if sakura_ulight_active == true:
				velocity.y = -200
				velocity.y += Gravity
			else:
				velocity.y = 0
			velocity.x = lerp(velocity.x, 0.0, 0.1)
			velocity.y = 0
			Animate.play("Nuetral Heavy")
		States.Nuetral_Air:
			velocity.x = lerp(velocity.x , 0.0, 0.7)
			velocity.y = lerp(velocity.y , 0.0, 0.2)
			Animate.play("Nuetral Air")

		States.Ground_Block:
			#  Activate turn around at the start of the state. #
			turn_around()
			Animate.play("Ground Block")
			velocity.y = 0
			velocity.x = 0
			block_timer.start()
		States.Air_Block:
			set_velocity(Vector2.ZERO)
			#  Activate turn around at the start of the state. #
			turn_around()
			Animate.play("Air Block")
			block_timer.start()
			# Activate counter smoke to be called during an attack.
			can_counter = true
		States.Dash_Run:
			if Input.is_action_pressed(controls.dash):
				velocity.x = move_toward(velocity.x, move_vec * Roll_Speed, Acceleration )
				
			else:
				if Input.is_action_just_released(controls.dash):
					Select = States.Idling
					velocity.x = move_toward(velocity.x, move_vec * 0, Acceleration )
				
				
			if jump_count > 0:
				if Input.is_action_just_pressed(controls.jump):
					jump_count -= 1
					velocity.y = -Jump_Height
					Select = States.Jumping
					_activate_jump_smoke()
					$"Character Jump Sound".play()
			velocity.y += Gravity
			Animate.play("Dash")
			
			
						
			if Input.is_action_pressed(controls.left) or Input.is_action_pressed(controls.right):
				if Input.is_action_just_pressed(controls.light):
					Select = States.Side_Light
					
				if Input.is_action_just_pressed(controls.heavy):
					Select = States.Side_Heavy
					
			else:
				if Input.is_action_just_pressed(controls.light):
					Select = States.Nuetral_Light
				
				if Input.is_action_just_pressed(controls.heavy):
					Select = States.Nuetral_Heavy
				
				if Input.is_action_just_pressed(controls.dash) and block_active == false:
						Select = States.Ground_Block
						block_active = true
						
				if Input.is_action_pressed(controls.down):
						if Input.is_action_just_pressed(controls.light):
								Select = States.Down_Light
								
						if Input.is_action_just_pressed(controls.heavy):
								Select = States.Down_Heavy

			if CharacterList.player_2_facing_left == true:
				if Input.is_action_just_pressed(controls.right):
					Select = States.Idling
					velocity.x = 0
				
						
				
			if CharacterList.player_2_facing_left == false:
				if Input.is_action_just_pressed(controls.left):
					Select = States.Idling
					velocity.x = 0
			
			if !is_on_floor():
				Select = States.Jumping

		States.Hurt:
			_bounce()
			if is_on_floor():
				velocity.y += Gravity
				Animate.play("Ground Hurt")
			else:
				if !is_on_floor():
					Animate.play("Air Hurt")
			velocity.x = move_toward(velocity.x, knockback_x * knockback_multiplier, Acceleration)
			velocity.y= move_toward(velocity.y, knockback_y * knockback_multiplier, Acceleration)
			print("Is Recovering ",recovery_timer.time_left)
			print("Knockback Value: ", knockback_multiplier, " : Current Velocity", velocity)
			
			if follow_goku_neutral_heavy == true:
				global_position = CharacterList.goku_neutral_heavy_grab_position
		States.Respawn:
			follow_goku_neutral_heavy = false
			Animate.play("Respawn")
			Health = 1000
			knockback_multiplier = 0.5
			velocity.x = 0
			velocity.y = 0
		States.Right_Wall:
			jump_count = 3
			Animate.play("Wall")
			velocity.y = 35
			velocity.x = 0
			Sprite.flip_h = true
			$"Scale Player".set_scale(Vector2(abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
			CharacterList.player_2_facing_left = false
			if Input.is_action_pressed(controls.left):
				if Input.is_action_just_pressed(controls.jump):
					Animate.play("Jump")
					velocity.x = -200
					Select = States.Jumping
					velocity.y = -Jump_Height
					_activate_wall_jump_smoke()
					$"Character Jump Sound".play()
					
			if !right_wall_detection.is_colliding():
				Select = States.Jumping
		States.Left_Wall:
			jump_count = 3
			Animate.play("Wall")
			velocity.y = 35
			velocity.x = 0
			Sprite.flip_h = false
			$"Scale Player".set_scale(Vector2(-abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
			CharacterList.player_2_facing_left = true
			if Input.is_action_pressed(controls.right):
				if Input.is_action_just_pressed(controls.jump):
					Animate.play("Jump")
					velocity.x = 200
					Select = States.Jumping
					velocity.y = -Jump_Height
					_activate_wall_jump_smoke()
					$"Character Jump Sound".play()
					
			if !left_wall_detection.is_colliding():
				Select = States.Jumping
					
		States.Air_Projectile:
			Animate.play("Air Projectile")
			velocity.x = lerp(velocity.x , 0.0, 0.05)
			velocity.y = 0

		States.Ground_Projectile:
			Animate.play("Ground Projectile")
			velocity.x = 0
			velocity.y = 0

func _on_area_2d_area_entered(area):
	
	if area.is_in_group("Goku | Ground Projectile"):
		recovery_timer.start(0.35)
		Select = States.Hurt
		print("Goku | Ground Projectile")
		if CharacterList.player_1_facing_left == true:
			knockback_x -= 400
			
		else:
			knockback_x += 400
	
	if area.is_in_group("Goku | Air Projectile"):
		recovery_timer.start(0.35)
		Select = States.Hurt
		print("Goku | Air Projectile")
		if CharacterList.player_1_facing_left == true:
			knockback_x -= 400
			
		else:
			knockback_x += 400
		
	if area.is_in_group("Goku | Neautral Heavy Positioner"):
		follow_goku_neutral_heavy = true
		Select = States.Hurt
		print("Goku | Neautral Heavy Positioner")
		
	if area.is_in_group("Goku | Neautral Heavy Shatter"):
		print("Goku | Neautral Heavy Shatter")
		follow_goku_neutral_heavy = false
		Select = States.Hurt
		recovery_timer.start(0.4)
		if CharacterList.player_1_facing_left == true:
			knockback_x = 300
		else:
			knockback_x = -300
		if is_on_floor():
			knockback_y = -600
			
		else:
			knockback_y = 900
	if area.is_in_group("Goku | Side Air Start"):
		print("Goku | Side Air Start")
		recovery_timer.start(0.55)
		Health -= 20
		Select = States.Hurt
		if CharacterList.player_1_facing_left == true:
			knockback_x = -750
		else:
			knockback_x = 750
			
			
		knockback_y = 0
		
	if area.is_in_group("Goku | Nuetral Air Right Side"):
		print("Goku | Nuetral Air Right Side")
		recovery_timer.start(0.3)
		Health -= 10
		Select = States.Hurt
		knockback_x = 0
		knockback_y = -400
		
	if area.is_in_group("Goku | Nuetral Air Middle Side"):
		print("Goku | Nuetral Air Middle Side")
		recovery_timer.start(0.3)
		Health -= 10
		Select = States.Hurt
		knockback_x = 0
		knockback_y = -400
	
	if area.is_in_group("Goku | Nuetral Air Left Side"):
		print("Goku | Nuetral Air Left Side")
		recovery_timer.start(0.3)
		Health -= 10
		Select = States.Hurt
		knockback_x = 0
		knockback_y = -400
		
	if area.is_in_group("Goku | Down Air"):
		print("Goku | Down Air")
		recovery_timer.start(0.4)
		Select = States.Hurt
		Health -= 10
		print("Goku | Nuetral Light End")
		knockback_y = 400
		
	if area.is_in_group("Goku | Down Light"):
		print("Goku | Down Light")
		recovery_timer.start(0.4)
		Select = States.Hurt
		Health -= 10
		print("Goku | Nuetral Light End")
		knockback_y = -400
		
	if area.is_in_group("Goku | Nuetral Light End"):
		recovery_timer.start(0.6)
		Select = States.Hurt
		Health -= 10
		print("Goku | Nuetral Light End")
		if CharacterList.player_1_facing_left == true:
			knockback_x = -350
		else:
			knockback_x = 350
		
		knockback_y = -350
	if area.is_in_group("Goku | Side Light Punch - Initial Damager"):
		Select = States.Hurt
		recovery_timer.start(0.35)
		knockback_x = 0
		knockback_y = 0
		Health -= 50
		
	if area.is_in_group("Goku | Side Light Punch - Finial Damager"):
		Select = States.Hurt
		recovery_timer.start(0.35)
		Health -= 25
		knockback_x = 0
		knockback_y = 0
		
	if area.is_in_group("Goku | Side Light Transitional Check"):
		recovery_timer.start(0.35)
		Select = States.Hurt
		knockback_x = 0
		knockback_y = 0
		
		
	if area.is_in_group("Goku Sde Light Finish - First Punch"):
		recovery_timer.start(0.35)
		Select = States.Hurt
		Health -= 20	
		knockback_x = 0
		knockback_y = 0
		
	if area.is_in_group("Goku Sde Light Finish - Second Punch"):
		Select = States.Hurt
		recovery_timer.start(0.45)
		Health -= 25
		print("Goku | Second Punch")
		if CharacterList.player_1_facing_left == true:
			knockback_x = -800
		else:
			knockback_x = 800
		
		knockback_y = 0
	
	if area.is_in_group("Goku | Down Heavy Initial"):
		recovery_timer.start(0.3)
		Select = States.Hurt
		knockback_x = 0
		knockback_y -= 450
		Health -= 10
		
		
	if area.is_in_group("Goku | Down Heavy Final"):
		recovery_timer.start(0.3)
		Select = States.Hurt
		knockback_x = 0
		knockback_y -= 450
		Health -= 10
		
	if area.is_in_group("Goku | Side Heavy Start"):
		recovery_timer.start(0.1)
		Select = States.Hurt
		Health -= 10
		if CharacterList.player_1_facing_left == true:
			knockback_x -= 500
			
		else:
			knockback_x += 500
		
		knockback_y = -600
	
	if area.is_in_group("Goku | Side Heavy End"):
		recovery_timer.start(0.2)
		Select = States.Hurt
		Health -= 10
		if CharacterList.player_1_facing_left == true:
			knockback_x -= 500
			
		else:
			knockback_x += 500
		
		knockback_y = -600
		
	if area.is_in_group("Off Stage - Galvin"):
		await get_tree().create_timer(0.2).timeout
		var tween = get_tree().create_tween()
		tween.tween_property(self, "global_position", CharacterList.galvin_player_respawn, 1.5)
		Select = States.Respawn





func _on_refresh_block_timeout():
		block_active = false


func _on_area_2d_body_entered(body):
	pass # Replace with function body.


func _on_goku__side_light_transitional_check_area_entered(area):
	side_registered = true
	attack_reset = true

func _on_goku__side_light_punch__finial_damager_area_entered(area):
	attack_reset = true


func _on_goku__side_light_punch__initial_damager_area_entered(area):
	attack_reset = true

func _on_goku__side_heavy_end_area_entered(area):
	attack_reset = true

func _on_goku__side_air_final_area_entered(area):
	attack_reset = true

func _on_goku__side_light_heavy_area_entered(area):
	attack_reset = true

func _on_goku__side_air_tracker_area_entered(area):
	attack_reset = true

func _on_goku__side_air_start_area_entered(area):
	attack_reset = true

func _on_goku__nuetral_light_midle_area_entered(area):
	attack_reset = true

func _on_goku__nuetral_light_end_area_entered(area):
	attack_reset = true


func _on_goku__nuetral_light_start_area_entered(area):
	attack_reset = true


func _on_goku__nuetral_air_right_side_area_entered(area):
	attack_reset = true


func _on_goku__nuetral_air_middle_side_area_entered(area):
	attack_reset = true


func _on_goku__nuetral_air_left_side_area_entered(area):
	attack_reset = true

func _on_goku__down_light_area_entered(area):
	attack_reset = true

func _on_goku__down_heavy_final_area_entered(area):
	attack_reset = true

func _on_goku__down_heavy_initial_area_entered(area):
	attack_reset = true

func _on_goku_sde_light_finish__second_punch_area_entered(area):
	attack_reset = true

func _on_goku_sde_light_finish__first_punch_area_entered(area):
	attack_reset = true



func _on_recovery_timer_timeout():
	_idle_state_()
	_reset_v()
