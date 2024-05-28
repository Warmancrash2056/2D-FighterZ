extends CharacterBody2D

signal JumpCloud
signal WallCloud
signal DashCloud


# Get character Resources
var controls: Resource
# Goku Projectile Position #
var side_registered = false
@onready var Animate: AnimationPlayer = $Character
@onready var Invisibilty = $Respawn
@onready var Sprite: Sprite2D = $Sprite
@onready var smoke_position: Marker2D = $"Jump Smoke"
@onready var wall_jump_smoke_position = $"Scale Player/Wall Jump Smoke"
@onready var counter_position = $"Counter Position"
@onready var block_timer = $"Refresh Block"
@onready var dash_smoke_position = $"Scale Player/Dash Smoke Position"
# General Archfield Fireball Position #
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

@export var Speed_Rating: float
@export var Defense_Rating: float
@export var Attack_Rating: float
@export var Stamina_Rating: float

var input_vector: int
const Max_Speed = 350
const Acceleration = 50
const Fall_Speed = 150
const  Jump_Height = 500
const  Gravity = 20

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
	if Input.is_action_pressed(controls.right):
			Sprite.flip_h = false
			$"Scale Player".set_scale(Vector2(abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
	elif Input.is_action_pressed(controls.left):
			Sprite.flip_h = true
			$"Scale Player".set_scale(Vector2(-abs($"Scale Player".get_scale().x), $"Scale Player".get_scale().y))
# Goku Stats
func _goku_side_finish():
	if side_registered == true:
		Select = States.Side_Transition

func _reset_side_transition():
	if side_registered == true:
		side_registered = false

func _ready():
	CharacterList.player_1_health = Health
	Select = States.Respawn
	recovery_timer.start()

func _get_movement():
	var character_speed = Speed_Rating * Max_Speed
	var air_rating = Speed_Rating + 0.25
	var air_speed = air_rating * character_speed
	input_vector = Input.get_action_strength(controls.right) - Input.get_action_strength(controls.left)

	clamp(input_vector,-1, 1)

	if input_vector != 0:
		if is_on_floor():
			velocity.x = move_toward(velocity.x , input_vector * character_speed, Acceleration)

		else:
			velocity.x = move_toward(velocity.x , input_vector * air_speed, Acceleration)

	else:
		velocity.x = move_toward(velocity.x,0, Acceleration)

func _physics_process(delta):
	move_and_slide()
	match Select:
		States.Idling:
			_get_movement()
			turn_around()
			jump_count = 3
			set_collision_mask_value(3, true)
			if !is_on_floor():
				Select = States.Jumping
				Animate.play("Jump")
			velocity.y += Gravity
			if input_vector != 0:
				Animate.play("Run")
				if Input.is_action_just_pressed(controls.dash):
					Select = States.Dash_Run
					set_collision_mask_value(2, false)
					DashCloud.emit()

				if Input.is_action_just_pressed(controls.light):
					Select = States.Side_Light

				if Input.is_action_just_pressed(controls.heavy):
					Select = States.Side_Heavy

			else:
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
				JumpCloud.emit()
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
			_get_movement()
			turn_around()
			if input_vector != 0:
				if Input.is_action_just_pressed(controls.light):
					Select = States.Side_Air

			else:
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
				JumpCloud.emit()
		States.Falling:
			turn_around()
			_get_movement()
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

			if Input.is_action_just_pressed(controls.jump) and jump_count > 0:
				jump_count -= 1
				velocity.y = -Jump_Height
				Animate.play("Jump")
				JumpCloud.emit()
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
			var original_speed = Speed_Rating * Max_Speed
			var dash_rating = Speed_Rating + 0.5
			var dash_speed = dash_rating * Max_Speed
			if Input.is_action_pressed(controls.dash):
				if Sprite.flip_h == false:
					velocity.x = move_toward(velocity.x , dash_speed, 5000)

				else:
					velocity.x = move_toward(velocity.x , -dash_speed, 5000)

			else:
				if Input.is_action_just_released(controls.dash):
					Select = States.Idling
					velocity.x = move_toward(velocity.x, 0, Acceleration )
			if jump_count > 0:
				if Input.is_action_just_pressed(controls.jump):
					jump_count -= 1
					velocity.y = -Jump_Height
					Select = States.Jumping
					JumpCloud.emit()
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

			if CharacterList.player_1_facing_left == true:
				if Input.is_action_just_pressed(controls.right):
					Select = States.Idling
					velocity.x = 0



			if CharacterList.player_1_facing_left == false:
				if Input.is_action_just_pressed(controls.left):
					Select = States.Idling
					velocity.x = 0

			if !is_on_floor():
				Select = States.Jumping

		States.Hurt:
			if is_on_floor():
				Animate.play("Ground Hurt")
			else:
				if !is_on_floor():
					Animate.play("Air Hurt")
			velocity.x = knockback_x * knockback_multiplier
			velocity.y= knockback_y * knockback_multiplier
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
					WallCloud.emit()

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
					WallCloud.emit()

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

	if area.is_in_group("Goku | Neautral Heavy Positioner"):
		follow_goku_neutral_heavy = true
		Select = States.Hurt
		print("Goku | Neautral Heavy Positioner")

	if area.is_in_group("Goku | Neautral Heavy Shatter"):
		print("Goku | Neautral Heavy Shatter")
		follow_goku_neutral_heavy = false
		Select = States.Hurt
		recovery_timer.start(0.4)
		if CharacterList.player_2_facing_left == true:
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
		if CharacterList.player_2_facing_left == true:
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

	if area.is_in_group("Goku | Down Light"):
		print("Goku | Down Light")
		recovery_timer.start(0.4)
		Select = States.Hurt
		Health -= 10
		print("Goku | Nuetral Light End")
		knockback_y = -400

	if area.is_in_group("Goku | Down Air"):
		print("Goku | Down Air")
		recovery_timer.start(0.4)
		Select = States.Hurt
		Health -= 10
		print("Goku | Nuetral Light End")
		knockback_y = 400

	if area.is_in_group("Goku | Nuetral Light End"):
		recovery_timer.start(0.6)
		Select = States.Hurt
		Health -= 10
		print("Goku | Nuetral Light End")
		if CharacterList.player_2_facing_left == true:
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
		recovery_timer.start(0.35)
		Health -= 25
		print("Goku | Nuetral Light End")
		if CharacterList.player_2_facing_left == true:
			knockback_x = -1200
		else:
			knockback_x = 1200

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
		if CharacterList.player_2_facing_left == true:
			knockback_x -= 500

		else:
			knockback_x += 500

		knockback_y = -600

	if area.is_in_group("Goku | Side Heavy End"):
		recovery_timer.start(0.2)
		Select = States.Hurt
		Health -= 10
		if CharacterList.player_2_facing_left == true:
			knockback_x -= 500

		else:
			knockback_x += 500

		knockback_y = -600
	if area.is_in_group("Off Stage - Galvin"):
		await get_tree().create_timer(0.2).timeout
		var tween = get_tree().create_tween()
		tween.tween_property(self, "global_position", CharacterList.galvin_player_respawn, 1.5)
		Select = States.Respawn


func _on_recovery_timer_timeout():
	_idle_state_()
