class_name Player2 extends CharacterBody2D

# Get character Resources
var controls: Resource = preload("res://Character Resouces/Global/Controller Resource/Player_2.tres")

signal JumpSmoke
signal FacingLeft
signal FacingRight
signal DashCloud
signal WallCloud
signal CounterCloud
signal Player1Box
signal FireProjectile


var general_nuetral_attack_fireball = preload("res://Character Resouces/General Archfield/Projectile/General Archfield Super Side Attack Projectile.tscn") # Goku Projectile Position #
# Goku Projectile Position #

var goku_ground_projectiles = preload("res://Character Resouces/Goku/Goku Ground Projectile.tscn")
var side_registered = false

# Global player nodes.
@onready var Animate = $Character
@onready var Invisibilty = $Respawn
@onready var Sprite = $Sprite
@onready var block_timer = $"Refresh Block"
@onready var right_wall_detection = $Right
@onready var left_wall_detection = $Left

# General Archfield Fireball Position #
@onready var general_arcfield_fireball_position = $"Scale Player/Super Projectile Position"
@onready var recovery_timer = $"Recovery Timer"
var follow_goku_neutral_heavy = false
var attack_reset = false
@onready var Goku_Side_End
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
const Dash_Acceleration: float = 400.0
const Dash_Decceleration: float = 200.0
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


# Reset counter smoke at the frist frame of idle and fall state.
func _reset_counter():
	can_counter = false


# Hunter Stats
	hunter_selected = true
	
	
func _attack_gravity():
	# Sets gravity after an attack.
	velocity.y += 35
	move_and_slide()
	
func change_dir():
	if direction.x < 0:
		Sprite.flip_h = true
		$"Scale Player".set_scale(Vector2(-abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
		CharacterList.player_1_facing_left == true
	elif direction.x > 0:
		Sprite.flip_h = false
		$"Scale Player".set_scale(Vector2(abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
		CharacterList.player_1_facing_left == false
func _on_wall():
	if is_on_wall():
		if left_wall_detection.is_colliding():
			Select = States.Left_Wall
			emit_signal("WallCloud")
		else:
			if right_wall_detection.is_colliding():
				Select = States.Right_Wall
				emit_signal("WallCloud")
func _movment():
	direction = Vector2(float(Input.get_action_strength(controls.right) - Input.get_action_strength(controls.left)), float(Input.get_action_strength(controls.down)))
	direction.normalized()
	if direction.x > 0:
		velocity.x = max(velocity.x, Speed, Acceleration)
		
	elif direction.x < 0:
		velocity.x = min(velocity.x , -Speed, Acceleration)
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, Decceleration)
		else:
			velocity.x = move_toward(velocity.x, 0, 20)
			
func _drop_fall():
	if direction.y > 0 and !is_on_floor():
		if Engine.get_physics_frames() % 2 == 0:

			velocity.y += 30
			set_collision_mask_value(3, false)
	else:
		set_collision_mask_value(3, true)


	if direction.y > 0 and !is_on_floor():
		if Engine.get_physics_frames() % 60 == 0:
			Select = States.Falling
			velocity.y += 45
func _ready():
	CharacterList.player_1_health = Health
	Select = States.Respawn
	block_active = false
	emit_signal("Player1Box")
	

func _reset_v():
	velocity.x = lerp(velocity.x, 0.0, 0.8)
	velocity.y = lerp(velocity.y, 0.0, 0.8)
	knockback_x = 0
	knockback_y = 0

func _activate_invisibility():
	Invisibilty.play("Invisibilty")
func _healthbar_status():
	CharacterList.player_2_health = Health

	if CharacterList.player_2_health < 700 and CharacterList.player_1_health > 400:
		knockback_multiplier = 1.0

	elif CharacterList.player_2_health < 490 and CharacterList.player_1_health> 200 :
		knockback_multiplier = 1.3

	elif CharacterList.player_2_health < 200:
		knockback_multiplier = 1.6

	else:
		if CharacterList.player_2_health < 0:
			knockback_multiplier = 1.9
			
func _reset_block():
	if block_active == true:
		if Engine.get_physics_frames() % 120 == 0:
			block_active = false
func _process(delta):
	_healthbar_status()


func _physics_process(delta):
	move_and_slide()
	match Select:
		States.Idling:
			_reset_block()
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

			if direction.x != 0:
				if Input.is_action_just_pressed(controls.light):
					Select = States.Side_Light
				
				if Input.is_action_just_pressed(controls.heavy):
					Select = States.Side_Heavy
					
				if Input.is_action_just_pressed(controls.dash):
					emit_signal("DashCloud")
					Select = States.Dash_Run
					set_collision_mask_value(2, false)
			if direction.x == 0:
				if Input.is_action_just_pressed(controls.light):
					Select = States.Nuetral_Light

				if Input.is_action_just_pressed(controls.heavy):
					Select = States.Nuetral_Heavy


				if Input.is_action_just_pressed(controls.throw):
					Select = States.Ground_Projectile
					
				if Input.is_action_just_pressed(controls.dash) and block_active == false:
					Select = States.Ground_Block
					block_active = true

			if direction.y > 0:
				if Input.is_action_just_pressed(controls.light):
					Select = States.Down_Light

			if Input.is_action_just_pressed(controls.jump) and jump_count > 0:
				emit_signal("JumpSmoke")
				Select = States.Jumping
				jump_count -= 1
				velocity.y = -Jump_Height
				Animate.play("Jump")

		States.Jumping:
			_reset_block()
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
					
				if Input.is_action_just_pressed(controls.dash) and block_active == false:
					Select = States.Air_Block
					block_active = true
					set_collision_mask_value(3, true)
					
			if direction.y == 1:
				if Input.is_action_just_pressed(controls.light):
					Select = States.Down_Air
					
			velocity.y += Gravity
			Animate.play("Jump")


			if is_on_floor():
				Select = States.Idling
				set_collision_mask_value(3, true)
			if Input.is_action_just_pressed(controls.jump) and jump_count > 0:
				emit_signal("JumpSmoke")
				jump_count -= 1
				velocity.y = -Jump_Height
				Animate.play("Jump")
		States.Falling:
			_reset_block()
			_movment()
			_on_wall()
			_drop_fall()
			change_dir()
			Animate.play("Fall")


			if Input.is_action_just_pressed(controls.jump) and jump_count > 0:
				emit_signal("JumpSmoke")
				jump_count -= 1
				velocity.y = -Jump_Height
				Select = States.Jumping
				Animate.play("Jump")
				
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
			velocity.x = lerp(velocity.x, 0.0, 0.2)
			velocity.y = 0
			Animate.play("Side Light Start")
		States.Side_Transition:
			velocity.x = 0
			velocity.y = 0
			Animate.play("Side Light Finisher")
		States.Side_Heavy:
			Animate.play("Side Heavy")
			velocity.x = lerp(velocity.x, 0.0, 0.9)
			velocity.y = 0

		States.Side_Air:
			Animate.play("Side Air")
			velocity.x = lerp(velocity.x , 0.0, 0.2)
			velocity.y = 0
		States.Down_Light:
			Animate.play("Down Light")
			velocity.x = lerp(velocity.x, 0.0, 0.8)
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
			velocity.x = lerp(velocity.x, 0.0, 0.7)
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
			velocity.x = lerp(velocity.x, 0.0, 0.05)
		States.Air_Block:
			set_velocity(Vector2.ZERO)
			Animate.play("Air Block")
			# Activate counter smoke to be called during an attack.
			can_counter = true
		States.Dash_Run:
			if velocity.x > 0:
				Sprite.flip_h == false
				
			else:
				Sprite.flip_h = true
			if direction.x == 0:
				Select = States.Idling
				velocity.x = move_toward(velocity.x, 0, Dash_Acceleration)
				
			if Input.is_action_pressed(controls.dash):
				velocity.x = move_toward(velocity.x, direction.x * Dash_Speed, Dash_Acceleration )

			else:
				if Input.is_action_just_released(controls.dash) or direction.x == 0:
					Select = States.Idling
					velocity.x = move_toward(velocity.x, Speed, Dash_Decceleration )
			if jump_count > 0:
				if Input.is_action_just_pressed(controls.jump):
					velocity.x = move_toward(velocity.x, direction.x * Speed, Decceleration )
					jump_count -= 1
					velocity.y = -Jump_Height
					Select = States.Jumping
			velocity.y += Gravity
			Animate.play("Dash")

			if Input.is_action_just_pressed(controls.dash) and block_active == false:
				Select = States.Ground_Block
				block_active = true
				velocity.x = lerp(velocity.x, 0.0, 0.2)
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
					emit_signal("JumpSmoke")
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
					emit_signal("JumpSmoke")
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
