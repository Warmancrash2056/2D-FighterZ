extends CharacterBody2D

var controls: Resource
signal Player2Box
signal IsJumping
signal OnWall
signal IsDashing
signal FacingLeft
signal FacingRight

# Goku Projectile Position #
var side_registered = false
@onready var Animate: AnimationPlayer = $Character
@onready var Sprite: Sprite2D = $Sprite
@onready var player_icon: Node2D = $'Player Icon'
@onready var Stats: Node = $'Player Stats'
@onready var floor_detector = $'Floor Detector'
@onready var Block_Timer: Timer = $'Refresh Block'
@onready var Recovery_Time: Timer = $'Recovery Timer'
@onready var right_wall_detection = $Right
@onready var left_wall_detection = $Left
var follow_goku_neutral_heavy = false
var attack_reset = false
# Goku Projectile Position #

var knockback_multiplier: float = 0.5
var knockback_x: float
var knockback_y: float

var is_attacking = false
var move_vec: Vector2

var sakura_ulight_active = false
var can_change_dir = false

var can_jump = false
var can_counter = false
var block_active = false
var attack_active = false
var can_move = true

var jump_count = 3


var Health: int = 500

enum States {
	# Normal Mode Ststes. #
	Idling,
	Jumping,
	Landing,

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
		Select = States.Jumping
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
		FacingRight.emit()
		CharacterList.player_1_facing_left = false

	elif Input.is_action_pressed(controls.left):
		FacingLeft.emit()
		CharacterList.player_1_facing_left = true
# Goku Stats
func _goku_side_finish():
	if side_registered == true:
		Select = States.Side_Transition

func _reset_side_transition():
	if side_registered == true:
		side_registered = false


func _reset_counter():
	can_counter = false

func _ready():
	CharacterList.player_2_icon = player_icon.Icon
	CharacterList.player_2_health = Health
	Select = States.Respawn

func _bounce():
	if is_on_wall():
		knockback_x *= -1

	elif is_on_ceiling():
		knockback_y *= -1

func _reset_v():
	velocity.x = lerp(velocity.x, 0.0, 0.8)
	velocity.y = lerp(velocity.y, 0.0, 0.8)
	knockback_x = 0
	knockback_y = 0

func _process(delta):
	CharacterList.player_2_health = Health

	if CharacterList.player_2_health < 700 and CharacterList.player_2_health > 400:
		knockback_multiplier = 1.0

	elif CharacterList.player_2_health < 490 and CharacterList.player_2_health> 200 :
		knockback_multiplier = 1.3

	elif CharacterList.player_2_health < 200:
		knockback_multiplier = 1.6

	else:
		if CharacterList.player_2_health < 0:
			knockback_multiplier = 1.9

func _attack_active():
	is_attacking = true

func _attack_disabled():
	is_attacking = false

func _movement_enabled():
	can_move = true

func _movement_disabled():
	can_move = false

func _ground_movement():
	var air_rating : float = Stats.Speed_Rating + 0.1
	var attack_rating: float = 0.1
	var new_speed: int = Stats.Speed_Rating * Stats.Max_Speed

	move_vec = Vector2(Input.get_action_strength(controls.right) - Input.get_action_strength(controls.left),
	Input.get_action_strength(controls.up) - Input.get_action_strength(controls.down))

	if !is_on_floor() and !is_attacking == true:
		new_speed = air_rating * Stats.Max_Speed

	if is_attacking == true:
		new_speed = attack_rating * Stats.Max_Speed
	move_vec.normalized()

	if can_move == true:
		if move_vec.x != 0:
			velocity.x = move_toward(velocity.x , move_vec.x * new_speed, Stats.Acceleration)

		else:
			velocity.x = move_toward(velocity.x , 0, Stats.Decelleration)


func _dash_mpvement():
	var new_rating: float = Stats.Speed_Rating + 0.35
	var new_speed: int = new_rating * Stats.Max_Speed

	if Sprite.flip_h == true:
		velocity.x = move_toward(velocity.x , -new_speed, Stats.Acceleration)

	else:
		velocity.x = move_toward(velocity.x , new_speed, Stats.Acceleration)

func _physics_process(delta):
	if !is_on_floor() and is_attacking == false:
		velocity.y += Stats.Gravity
	move_and_slide()
	match Select:
		States.Idling:
			turn_around()
			_ground_movement()
			jump_count = 3
			set_collision_mask_value(3, true)
			if move_vec.x != 0:
				if is_on_floor():
					Animate.play("Run")
				if Input.is_action_just_pressed(controls.light):
					Select = States.Side_Light

				if Input.is_action_just_pressed(controls.heavy):
					Select = States.Side_Heavy

				if velocity.x != 0:
					if Input.is_action_just_pressed(controls.dash):
						Select = States.Dash_Run
						set_collision_mask_value(2, false)


			else:
				if is_on_floor():
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
				IsJumping.emit()
				velocity.y = -Stats.Jump_Height
				Animate.play("Jump")

			elif Input.is_action_pressed(controls.down):

				if Input.is_action_just_pressed(controls.heavy):
					Select = States.Down_Heavy

				if Input.is_action_just_pressed(controls.light):
					Select = States.Down_Light

				await  get_tree().create_timer(0.2).timeout
				if Input.is_action_pressed(controls.down):
					set_collision_mask_value(3, false)

			if !floor_detector.is_colliding() and !is_on_floor():
				Select = States.Jumping
		States.Jumping:
			_ground_movement()
			turn_around()
			if move_vec.x != 0:
				if Input.is_action_just_pressed(controls.light):
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

			if velocity.y > 0:
				Animate.play("Fall")

			else:
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



			if floor_detector.is_colliding() and is_on_floor():
				Select = States.Idling
				Animate.play("Idle")
				set_collision_mask_value(3, true)


			if Input.is_action_just_pressed(controls.jump) and jump_count > 0:
				jump_count -= 1
				velocity.y = -Stats.Jump_Height
				IsJumping.emit()

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
			velocity.x = lerp(velocity.x, 0.0, 0.1)
			velocity.y = 0
			Animate.play("Nuetral Heavy")
		States.Nuetral_Air:
			#velocity.x = lerp(velocity.x , 0.0, 0.7)
			#velocity.y = lerp(velocity.y , 0.0, 0.2)
			Animate.play("Nuetral Air")

		States.Ground_Block:
			#  Activate turn around at the start of the state. #
			turn_around()
			Animate.play("Ground Block")
			velocity.y = 0
			velocity.x = 0
			Block_Timer.start()
		States.Air_Block:
			set_velocity(Vector2.ZERO)
			#  Activate turn around at the start of the state. #
			turn_around()
			Animate.play("Air Block")
			Block_Timer.start()
			# Activate counter smoke to be called during an attack.
			can_counter = true

		States.Dash_Run:
			if Input.is_action_pressed(controls.dash):
				_dash_mpvement()

			else:
				if Input.is_action_just_released(controls.dash):
					Select = States.Idling
					velocity.x = move_toward(velocity.x, 0, Stats.Acceleration )
			if jump_count > 0:
				if Input.is_action_just_pressed(controls.jump):
					jump_count -= 1
					velocity.y = -Stats.Jump_Height
					Select = States.Jumping
					IsJumping.emit()
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

			if Sprite.flip_h == true:
				if Input.is_action_just_pressed(controls.right):
					Select = States.Idling
					velocity.x = 0



			if Sprite.flip_h == false:
				if Input.is_action_just_pressed(controls.left):
					Select = States.Idling
					velocity.x = 0

			if !is_on_floor():
				Select = States.Jumping

		States.Hurt:
			_bounce()
			if is_on_floor():
				Animate.play("Ground Hurt")
			else:
				if !is_on_floor():
					Animate.play("Air Hurt")
			velocity.x = knockback_x * knockback_multiplier
			velocity.y= knockback_y * knockback_multiplier
			#print("Is Recovering ",rec.time_left)
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
			FacingLeft.emit()
			if Input.is_action_pressed(controls.left):
				if Input.is_action_just_pressed(controls.jump):
					Animate.play("Jump")
					velocity.x = -200
					Select = States.Jumping
					velocity.y = -Stats.Jump_Height
					OnWall.emit()

			if !right_wall_detection.is_colliding():
				Select = States.Jumping
		States.Left_Wall:
			jump_count = 3
			Animate.play("Wall")
			velocity.y = 35
			velocity.x = 0
			FacingRight.emit()
			if Input.is_action_pressed(controls.right):
				if Input.is_action_just_pressed(controls.jump):
					Animate.play("Jump")
					velocity.x = 200
					Select = States.Jumping
					velocity.y = -Stats.Jump_Height
					OnWall.emit()

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
		Recovery_Time.start(0.4)
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
		Recovery_Time.start(0.55)
		Health -= 20
		Select = States.Hurt
		if CharacterList.player_2_facing_left == true:
			knockback_x = -750
		else:
			knockback_x = 750


		knockback_y = 0

	if area.is_in_group("Goku | Nuetral Air Right Side"):
		print("Goku | Nuetral Air Right Side")
		Recovery_Time.start(0.3)
		Health -= 10
		Select = States.Hurt
		knockback_x = 0
		knockback_y = -400

	if area.is_in_group("Goku | Nuetral Air Middle Side"):
		print("Goku | Nuetral Air Middle Side")
		Recovery_Time.start(0.3)
		Health -= 10
		Select = States.Hurt
		knockback_x = 0
		knockback_y = -400

	if area.is_in_group("Goku | Nuetral Air Left Side"):
		print("Goku | Nuetral Air Left Side")
		Recovery_Time.start(0.3)
		Health -= 10
		Select = States.Hurt
		knockback_x = 0
		knockback_y = -400

	if area.is_in_group("Goku | Down Light"):
		print("Goku | Down Light")
		Recovery_Time.start(0.4)
		Select = States.Hurt
		Health -= 10
		print("Goku | Nuetral Light End")
		knockback_y = -400

	if area.is_in_group("Goku | Down Air"):
		print("Goku | Down Air")
		Recovery_Time.start(0.4)
		Select = States.Hurt
		Health -= 10
		print("Goku | Nuetral Light End")
		knockback_y = 400

	if area.is_in_group("Goku | Nuetral Light End"):
		Recovery_Time.start(0.6)
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
		Recovery_Time.start(0.35)
		knockback_x = 0
		knockback_y = 0
		Health -= 50

	if area.is_in_group("Goku | Side Light Punch - Finial Damager"):
		Select = States.Hurt
		Recovery_Time.start(0.35)
		Health -= 25
		knockback_x = 0
		knockback_y = 0

	if area.is_in_group("Goku | Side Light Transitional Check"):
		Recovery_Time.start(0.35)
		Select = States.Hurt
		knockback_x = 0
		knockback_y = 0


	if area.is_in_group("Goku Sde Light Finish - First Punch"):
		Recovery_Time.start(0.35)
		Select = States.Hurt
		Health -= 20
		knockback_x = 0
		knockback_y = 0

	if area.is_in_group("Goku Sde Light Finish - Second Punch"):
		Select = States.Hurt
		Recovery_Time.start(0.35)
		Health -= 25
		print("Goku | Nuetral Light End")
		if CharacterList.player_2_facing_left == true:
			knockback_x = -1200
		else:
			knockback_x = 1200

		knockback_y = 0

	if area.is_in_group("Goku | Down Heavy Initial"):
		Recovery_Time.start(0.3)
		Select = States.Hurt
		knockback_x = 0
		knockback_y -= 450
		Health -= 10


	if area.is_in_group("Goku | Down Heavy Final"):
		Recovery_Time.start(0.3)
		Select = States.Hurt
		knockback_x = 0
		knockback_y -= 450
		Health -= 10

	if area.is_in_group("Goku | Side Heavy Start"):
		Recovery_Time.start(0.1)
		Select = States.Hurt
		Health -= 10
		if CharacterList.player_2_facing_left == true:
			knockback_x -= 500

		else:
			knockback_x += 500

		knockback_y = -600

	if area.is_in_group("Goku | Side Heavy End"):
		Recovery_Time.start(0.2)
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
