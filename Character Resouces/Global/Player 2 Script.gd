extends CharacterBody2D

# Get character Resources
var controls: Resource = preload("res://Character Resouces/Global/Controller Resource/Player_2.tres")

var jump_smoke = preload("res://Character Resouces/jump_smoke.tscn")
var counter_smoke = preload("res://Character Resouces/Global/counter.tscn")
var dash_smoke = preload("res://Character Resouces/Global/dash_smoke.tscn")
var wall_jump_smoke = preload("res://Autoloads/wall_jump_cloud.tscn")

var general_nuetral_attack_fireball = preload("res://Character Resouces/General Archfield/Projectile/General Archfield Super Side Attack Projectile.tscn") # Goku Projectile Position #
# Goku Projectile Position #
@onready var goku_projectile_position = $"Scale Player/Goku Projectile Position"
var goku_air_projectile = preload("res://Character Resouces/Goku/Goku Air Projectile.tscn")
var goku_ground_projectiles = preload("res://Character Resouces/Goku/Goku Ground Projectile.tscn")
var side_registered = false

# Global player nodes.
@onready var Animate = $Character
@onready var Invisibilty = $Respawn
@onready var Sprite = $Sprite
@onready var smoke_position = $"Jump Smoke"
@onready var wall_jump_smoke_position = $"Scale Player/Wall Jump Smoke"
@onready var counter_position = $"Counter Position"
@onready var block_timer = $"Refresh Block"
@onready var dash_smoke_position = $"Scale Player/Dash Smoke Position"
@onready var right_wall_detection = $Right
@onready var left_wall_detection = $Left

# General Archfield Fireball Position #
@onready var general_arcfield_fireball_position = $"Scale Player/Super Projectile Position"
@onready var recovery_timer = $"Recovery Timer"
var follow_goku_neutral_heavy = false
var attack_reset = false
# Goku Projectile Position #

var knockback_multiplier: float = 0.5
var knockback_x: float
var knockback_y: float

var goku_selected = false
var general_selected = false
var nomad_selected = false
var sakura_selected = false
var hunter_selected = false
var atlantis_selected = false
var henry_selected = false

var direction = Vector2() # Get the vector input to determine character movement.
var knock_vector = Vector2() # normalize the global_position of attack to determine knockback direction
var is_facing_left: bool = false
const Speed: float = 250
const Acceleration: float = 25.0
const Decceleration: float = 50.0
const Dash_Acceleration: float = 300.0
const Dash_Decceleration: float = 50.0
const Dash_Speed: float = 550.0
const Jump_Height: float = 500
const Gravity: float = 20
var jump_count: int = 3

var can_jump_smoke = false

# Check if player can countewr. reset in idle and jump and fall animations.
var can_counter = false
# Check if player can block rreset in idle, jump, and fall
var block_active = false



var Health: float = 1000

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
	CharacterList.goku_selected = true
	goku_selected = true

func _general_stats():
	nomad_selected = true

func _sakura_stats():
	pass

func _nomad_stats():
	pass



# Default State when entering the scene tree. #
var Select = States.Respawn

# Quickly return back to idle or jump state if sucessfully lannds an attack.
func _attack_reset():
	attack_reset = false
func quick_reset(): # Attack Sucessful #
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

func _idle_state_(): # Normal Reset if unsucessful.`
	follow_goku_neutral_heavy = false
	if !is_on_floor():
		Select = States.Falling
		Animate.play("Fall")
	else:
		Select = States.Idling
		Animate.play("Idle")



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


# General Archfield Stats.
func _general_archfield_freball():
	var instance_fireball = general_nuetral_attack_fireball.instantiate()
	instance_fireball.global_position = general_arcfield_fireball_position.global_position
	get_tree().get_root().add_child(instance_fireball)
	if CharacterList.player_1_facing_left == true:
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

	if CharacterList.player_1_facing_left == true:
		instance_molten_sand.velocity.x = -700
		instance_molten_sand.scale.x = -1
	else:
		instance_molten_sand.velocity.x = 700
		instance_molten_sand.scale.x = 1

func _goku_ground_projectile():
	var instance_molten_earth = goku_ground_projectiles.instantiate()
	instance_molten_earth.global_position = goku_projectile_position.global_position
	get_tree().get_root().add_child(instance_molten_earth)

	if CharacterList.player_1_facing_left == true:
		instance_molten_earth.velocity.x = -700
		instance_molten_earth.scale.x = -1.5
	else:
		instance_molten_earth.velocity.x = 700
		instance_molten_earth.scale.x = 1.5

# Activates cloud effects at first frame of action.
func _activate_jump_smoke():
	var instance_smoke_jump = jump_smoke.instantiate()
	instance_smoke_jump.global_position = smoke_position.global_position
	get_tree().get_root().add_child(instance_smoke_jump)
func _activate_wall_jump_smoke():
	var instance_wall_jump = wall_jump_smoke.instantiate()
	instance_wall_jump.global_position = wall_jump_smoke_position.global_position
	get_tree().get_root().add_child(instance_wall_jump)

	if CharacterList.player_1_facing_left == true:
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

	if CharacterList.player_1_facing_left == true:
		instance_dash_smoke.scale.x = -1
	else:
		instance_dash_smoke.scale.x = 1
# Hunter Stats
	hunter_selected = true
func change_dir():
	if Sprite.flip_h == false:
		is_facing_left = false
		
	else:
		is_facing_left = true
	if direction.x < 0:
		Sprite.flip_h = true
		$"Scale Player".set_scale(Vector2(-abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
		
	elif direction.x > 0:
		Sprite.flip_h = false
		$"Scale Player".set_scale(Vector2(abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
func _on_wall():
	if is_on_wall():
		if left_wall_detection.is_colliding():
			Select = States.Left_Wall
		else:
			if right_wall_detection.is_colliding():
				Select = States.Right_Wall
func _movment():
	direction = Vector2(int(Input.get_action_strength(controls.right) - Input.get_action_strength(controls.left)), int(Input.get_action_strength(controls.down)))
	if direction.x != 0:
		velocity.x = move_toward(velocity.x, direction.x * Speed, Acceleration)
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, Decceleration)
		else:
			velocity.x = move_toward(velocity.x, 0, 10)
			
func _drop_fall():
	if direction.y == 1 and !is_on_floor():
		if Engine.get_physics_frames() % 6 == 0:

			velocity.y += 30
			set_collision_mask_value(3, false)
	else:
		set_collision_mask_value(3, true)


	if direction.y == 1 and !is_on_floor():
		if Engine.get_physics_frames() % 60 == 0:
			Select = States.Falling
			velocity.y += 45
			print("state fALL")
func _ready():
	CharacterList.player_1_health = Health
	Select = States.Respawn
	recovery_timer.start()


func _reset_v():
	velocity.x = lerp(velocity.x, 0.0, 0.8)
	velocity.y = lerp(velocity.y, 0.0, 0.8)
	knockback_x = 0
	knockback_y = 0

func _activate_invisibility():
	Invisibilty.play("Invisibilty")

func _process(delta):
	CharacterList.player_1_health = Health

	if CharacterList.player_1_health < 700 and CharacterList.player_1_health > 400:
		knockback_multiplier = 1.0

	elif CharacterList.player_1_health < 490 and CharacterList.player_1_health> 200 :
		knockback_multiplier = 1.3

	elif CharacterList.player_1_health < 200:
		knockback_multiplier = 1.6

	else:
		if CharacterList.player_1_health < 0:
			knockback_multiplier = 1.9


func _physics_process(delta):
	move_and_slide()
	match Select:
		States.Idling:
			change_dir()
			_movment()
			_drop_fall()
			jump_count = 3
			set_collision_mask_value(3, true)
			if !is_on_floor():
				Select = States.Jumping
				Animate.play("Jump")

			if direction.x != 0:
				Animate.play("Run")

			else:
				Animate.play("Idle")


			if Input.is_action_just_pressed(controls.dash) and block_active == false:
				Select = States.Ground_Block
				block_active = true

			if direction.x != 0:
				if Input.is_action_just_pressed(controls.light):
					Select = States.Side_Light

				if Input.is_action_just_pressed(controls.heavy):
					Select = States.Side_Heavy
			if direction.x == 0:
				if Input.is_action_just_pressed(controls.light):
					Select = States.Nuetral_Light

				if Input.is_action_just_pressed(controls.heavy):
					Select = States.Nuetral_Heavy


				if Input.is_action_just_pressed(controls.throw):
					Select = States.Ground_Projectile

			if direction.y == 1:
				if Input.is_action_just_pressed(controls.light):
					Select = States.Down_Light

			if Input.is_action_just_pressed(controls.jump) and jump_count > 0:
				Select = States.Jumping
				jump_count -= 1
				_activate_jump_smoke()
				$"Character Jump Sound".play()
				velocity.y = -Jump_Height
				Animate.play("Jump")

			if velocity.x != 0:
				if Input.is_action_just_pressed(controls.dash):
					Select = States.Dash_Run
					set_collision_mask_value(2, false)
					_activate_dash_smoke()

		States.Jumping:
			change_dir()
			_movment()
			_on_wall()
			_drop_fall()
			if direction.x != 0:
				if Input.is_action_just_pressed(controls.light):
					Select = States.Side_Air

			if direction.x == 0:
				if Input.is_action_just_pressed(controls.light):
					Select = States.Nuetral_Air

				if Input.is_action_just_pressed(controls.throw):
					Select = States.Ground_Projectile

			if direction.y == 1:
				if Input.is_action_just_pressed(controls.light):
					Select = States.Down_Air
			if Input.is_action_just_pressed(controls.dash) and block_active == false:
				Select = States.Air_Block
				block_active = true
				set_collision_mask_value(3, true)

			velocity.y += Gravity
			Animate.play("Jump")


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
			_movment()
			_on_wall()
			_drop_fall()
			change_dir()
			Animate.play("Fall")


			if Input.is_action_just_pressed(controls.jump) and jump_count > 0:
				jump_count -= 1
				velocity.y = -Jump_Height
				Select = States.Jumping
				Animate.play("Jump")
				_activate_jump_smoke()
				$"Character Jump Sound".play()
				
			if Input.is_action_just_pressed(controls.dash) and block_active == false:
				Select = States.Air_Block
				block_active = true
				velocity = Vector2.ZERO

			if !is_on_floor():
				velocity.y += Gravity
			else:
				Select = States.Idling
				Animate.play("Idle")
				jump_count = 3

		States.Side_Light:
			velocity.x = lerp(velocity.x, 0.0, 0.1)
			velocity.y = 0
			Animate.play("Side Light Start")
		States.Side_Transition:
			velocity.x = 0
			velocity.y = 0
			Animate.play("Side Light Finisher")
		States.Side_Heavy:
			Animate.play("Side Heavy")
			velocity.x = lerp(velocity.x, 0.0, 0.1)
			velocity.y = 0

		States.Side_Air:
			Animate.play("Side Air")
			velocity.x = lerp(velocity.x , 0.0, 0.06)
			velocity.y = 0
		States.Down_Light:
			Animate.play("Down Light")
			velocity.x = lerp(velocity.x, 0.0, 0.09)
			velocity.y = 0

		States.Down_Heavy:
			velocity.x = lerp(velocity.x, 0.0, 0.2)
			velocity.y = 0
			Animate.play("Down Heavy")
		States.Down_Air:
			velocity.x = lerp(velocity.x, 0.0, 0.1)
			velocity.y = 5
			Animate.play("Down Air")
		States.Down_Air_Heavy:
			Animate.play("Down Air Heavy")
			velocity.x = lerp(velocity.x , 0.0, 0.1)
			velocity.y = 0
		States.Nuetral_Light:
			print(velocity.x)
			velocity.x = lerp(velocity.x, 0.0, 0.3)
			velocity.y = 0
			Animate.play("Nuetral Light")

		States.Nuetral_Heavy:
			velocity.x = lerp(velocity.x, 0.0, 0.1)
			velocity.y = 0
			Animate.play("Nuetral Heavy")
		States.Nuetral_Air:
			velocity.x = lerp(velocity.x , 0.0, 0.1)
			velocity.y = lerp(velocity.y , 0.0, 0.1)
			Animate.play("Nuetral Air")

		States.Ground_Block:
			Animate.play("Ground Block")
			velocity.y = 0
			velocity.x = 0
			block_timer.start()
		States.Air_Block:
			set_velocity(Vector2.ZERO)
			Animate.play("Air Block")
			block_timer.start()
			# Activate counter smoke to be called during an attack.
			can_counter = true
		States.Dash_Run:
			if direction.x == 0:
				Select = States.Idling
				velocity.x = move_toward(velocity.x, Speed, Dash_Decceleration )
			if Input.is_action_pressed(controls.dash):
				velocity.x = move_toward(velocity.x, direction.x * Dash_Speed, Dash_Acceleration )

			else:
				if Input.is_action_just_released(controls.dash):
					Select = States.Idling
					velocity.x = move_toward(velocity.x, Speed, Dash_Decceleration )
			if jump_count > 0:
				if Input.is_action_just_pressed(controls.jump):
					velocity.x = move_toward(velocity.x, direction.x * Speed, Decceleration )
					jump_count -= 1
					velocity.y = -Jump_Height
					Select = States.Jumping
					_activate_jump_smoke()
					$"Character Jump Sound".play()
			velocity.y += Gravity
			Animate.play("Dash")


			if Input.is_action_just_pressed(controls.light):
				Select = States.Nuetral_Light

			if Input.is_action_just_pressed(controls.heavy):
				Select = States.Nuetral_Heavy

			if Input.is_action_pressed(controls.left) or Input.is_action_pressed(controls.right):
				if Input.is_action_just_pressed(controls.light):
					Select = States.Side_Light

				if Input.is_action_just_pressed(controls.heavy):
					Select = States.Side_Heavy


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


			if !is_on_floor():
				Select = States.Jumping

		States.Hurt:
			bounce_off_surface(delta)
			if is_on_floor():
				Animate.play("Ground Hurt")
			else:
				if !is_on_floor():
					Animate.play("Air Hurt")
			set_velocity(Vector2(knockback_x * knockback_multiplier, knockback_y * knockback_multiplier))
			#print("Is Recovering ",recovery_timer.time_left)
			#print("Knockback Value: ", knockback_multiplier, " : Current Velocity", velocity)

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
			Sprite.flip_h = false
			velocity.y = 35
			velocity.x = 0
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


func apply_knockback(enemy_position):
	knock_vector = global_position.direction_to(enemy_position).normalized()
	velocity.x = knock_vector.x * -knockback_x
	print(knock_vector.x)
# New function to handle bouncing
func bounce_off_surface(delta):
	if is_on_wall():
		knockback_x *= -1
		print("bounce")
		
	elif is_on_ceiling():
		knockback_y *= -1
		
	if is_on_floor():
		knockback_y *= -1
		print("bounce off floor")
func _on_area_2d_area_entered(area):
	apply_knockback(area.global_position)
	if area.is_in_group("Goku | Ground Projectile"):
		recovery_timer.start(0.35)
		Select = States.Hurt
		apply_knockback(area.global_position)

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
		if is_on_floor():
			knockback_y = -600
		else:
			knockback_y = 600

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
		if knock_vector.x == -1:
			knockback_x = -350

		else:
			knockback_x = -350
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
		if knock_vector > 0:
			knockback_x = 700

		else:
			knockback_x = -700
			
	if area.is_in_group("Goku | Down Heavy Initial"):
		recovery_timer.start(0.14)
		Select = States.Hurt
		knockback_x = 0
		knockback_y -= 350
		Health -= 40

	if area.is_in_group("Goku | Down Heavy Final"):
		recovery_timer.start(0.28)
		Select = States.Hurt
		knockback_x = 0
		knockback_y -= 500
		Health -= 120

	if area.is_in_group("Goku | Side Heavy Start"):
		recovery_timer.start(0.1)
		Select = States.Hurt
		Health -= 10
		if knock_vector.x == -1:
			knockback_x -= 500

		else:
			knockback_x += 500

	if area.is_in_group("Goku | Side Heavy End"):
		recovery_timer.start(0.2)
		Select = States.Hurt
		Health -= 10
		if knock_vector.x == -1:
			knockback_x -= 450

		else:
			knockback_x += 700

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
