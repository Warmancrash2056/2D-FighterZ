extends RigidBody2D

signal FacingLeft
signal FacingRight
signal JumpCloud
signal IsBlocking
signal IsAttacking
signal IsResetting
# Test to see if i can add the resource during instancing. #
var Controls: Resource
@onready var Player_Stats: Node = $'Player Stats'
@onready var Player_Indicator: Sprite2D = $'Player Indicator'
@onready var Animator: AnimationPlayer = $Animator
@onready var Sprite: Sprite2D = $Sprite
@onready var Wall_Detector: RayCast2D = $'Wall Detector'
@onready var Floor_Detector: RayCast2D = $'Floor Detector'
@onready var Floor_Detector2: RayCast2D = $'Floor Detector2'

@onready var ray = $"Raycast Controller"
@onready var Hurtbox:Area2D = $Hurtbox
@onready var Player_Identifier: Node2D = $'..'
var direction = 1

var movement_dir: Vector2
var input_buffer = []
var max_buffer_limit = 4
var buffer_time = 0.1
const Hold_threshold = 0.15
var input_hold_times= {}
var input_states = {}

var can_move = true
var can_direct = true
var can_jump = true
var can_dash = true
var can_attack = true
var can_block = true
var previouslyjumped = false


enum {SurfaceGround, SurfaceWall, SurfaceAir}
var surface_state = SurfaceAir

enum {
	Idle,
	Forward_Step,
	Backward_Step,
	Moving_Left,
	Turning_Left,
	Moving_Right,
	Turning_Right,
	Running,
	Dash,
	Wall,
	Air,
	Ground_Block_Start_Tap,
	Ground_Block_Held,
	Ground_Block_To_Idle,
	Block_Slide,
	Air_Block_Start_Tap,
	Air_Block_Held,
	Neutral_Light,
	Neutral_Heavy,
	Neutral_Air,
	Neutral_Recovery,
	Side_Light_Start_Tap,
	Side_Light_Held_Release,
	Side_Light_Held,
	Side_Heavy_Start_Tap,
	Side_Heavy_Held_Release,
	Side_Heavy_Held,
	Side_Air_Start_Tap,
	Side_Air_Held_Release,
	Side_Air_Held,
	Down_Light_Start_Tap,
	Down_Light_Held_Release,
	Down_Light_Held,
	Down_Heavy_Start_Tap,
	Down_Heavy_Held_Release,
	Down_Heavy_Held,
	Down_Air_Start_Tap,
	Down_Air_Held_Release,
	Down_Air_Held,
	Dowm_Recovery_Start_Tap,
	Dowm_Recovery_Held_Release,
	Dowm_Recovery_Held,
	Ground_Throw_Start_Tap,
	Ground_Throw_Held_Release,
	Ground_Throw_Held,
	Air_Throw_Start_Tap,
	Air_Throw_Held_Release,
	Air_Throw_Held,
	Hurt,
	Recover,
	Respawn
}
var last_direction_press = { # The last time a direction was pressed. match with new button pressed
	"up": 0,
	"down": 0,
	"left": 0,
	"right": 0
}
var hold_start_time = {} # Captures the time he left or right button was pressed.
# Matches
var last_direction = "" # The last direction pressed.
var state = Respawn
func _ready():
	# Create idependent physics material for each player as they enter the match.
	# This will allow for the player to have their own physics material.
	# and prevent global changes.
	physics_material_override = PhysicsMaterial.new()
	physics_material_override.friction = 1
	physics_material_override.bounce = 0

func _physics_process(delta: float) -> void:
	#print(hold_start_time)
	#print(input_buffer)
	_update_input_held_status() ## Necessary function to handle whether an input is held or not.
	_process_direction()
	_process_attack_input()
	_process_block_input()
	_process_dash_input()
	_process_jump_input()
	clear_inputs()
	_process_dual_direction()
	_process_dual_combinations()
	_process_single_size_inputs()
	_process_immediate_action()
	if Hurtbox.goku_neautral_havy == true:
		var Goku_Positioner: Vector2 = CharacterList.goku_neutral_heavy_grab_position
		global_position.x= move_toward(global_position.x, Goku_Positioner.x, 150)
		global_position.y = move_toward(global_position.y, Goku_Positioner.y, 150)
	if !Animator.state == Hurt:
		if ray.completely_on_the_wall == true:
			_on_wall()

		else:
			_get_movement()

	if Animator.state in [Respawn]:
		gravity_scale = 0

	else:
		gravity_scale = 1

func _on_wall():
	gravity_scale = 0
	linear_velocity.y = 10
	linear_velocity.x = 0
	if ray.scale.x < 0:
		Sprite.flip_h = false
		if Input.is_action_pressed(Player_Identifier.Controls.right):
			linear_velocity = Vector2(200,-100)
			add_to_buffer({"type": "direction", "value": "left", "onground": ray.onground == true,
			"facing": -1 ,"timestamp": Time.get_ticks_msec()})
			FacingRight.emit()
	else:
		Sprite.flip_h = true
		if Input.is_action_pressed(Player_Identifier.Controls.left):
			linear_velocity = Vector2(-200,-100)
			add_to_buffer({"type": "direction", "value": "right", "onground": ray.onground == true,
			 "facing": 1 ,"timestamp": Time.get_ticks_msec()})
			FacingLeft.emit()




# Disable movement at crtain frame of attack and enable at the end of attack.
#Player can only move in the direction they are facing.
func _get_movement():
	var new_speed
	var air_rating: float = Player_Stats.Speed_Rating + 1.2
	var decelleration =  Player_Stats.Decelleration
	var dash_rating: float = Player_Stats.Speed_Rating + 2.5
	var current_time = Time.get_ticks_msec() / 1000.0
	if ray.onground == true:
		if Animator.state == Dash:
			new_speed = dash_rating * Player_Stats.Max_Speed
		else:
			new_speed = Player_Stats.Max_Speed * Player_Stats.Speed_Rating
			decelleration =  Player_Stats.Decelleration
	else:
		new_speed = Player_Stats.Max_Speed * air_rating
		decelleration =  5

	if ray.onwall == false:
		if can_move == true:
			var right_action = Player_Identifier.Controls.right
			var left_action = Player_Identifier.Controls.left

			if Input.is_action_just_pressed(right_action):
				hold_start_time[right_action] = current_time

			if Input.is_action_just_pressed(left_action):
				hold_start_time[left_action] = current_time

			var right_held = Input.is_action_pressed(right_action) and (current_time - hold_start_time.get(right_action, 0)) >= 0.1
			var left_held = Input.is_action_pressed(left_action) and (current_time - hold_start_time.get(left_action,0)) >= 0.1

			if right_held:
				movement_dir.x = 1

			elif left_held:
				movement_dir.x = -1

			else:
				movement_dir.x = 0

			if Animator.state in [Idle, Running, Dash, Air]:
				if movement_dir.x == 1 and Sprite.flip_h == false:
					linear_velocity.x = move_toward(linear_velocity.x, new_speed, Player_Stats.Acceleration)

				else:
					linear_velocity.x = move_toward(linear_velocity.x, 0, decelleration)

				if movement_dir.x == -1 and Sprite.flip_h == true:
					linear_velocity.x = move_toward(linear_velocity.x, new_speed * -1, Player_Stats.Acceleration)

				else:
					linear_velocity.x = move_toward(linear_velocity.x, 0, decelleration)

func _update_input_held_status():
	var current_time = Time.get_ticks_msec()
	for input_action in input_buffer:
		if input_action.type == "attack" or input_action.type == "direction":
			var action = Player_Identifier.Controls[input_action.value]
			if Input.is_action_pressed(action):
				if not input_hold_times.has(action):
					input_hold_times[action] = current_time

				var hold_duration = current_time - input_hold_times[action]
				input_action.held = hold_duration > Hold_threshold # DEFALUT VALUE IS 0.15 or 9 frames
				input_states[action] = input_action.held

			else:
				input_action.held = false
				input_hold_times.erase(action)
				input_states.erase(action)



# These two process_input() and process_attack() unction will process the input from the player and add it to the buffer.
# Check wheter on of the direction keys are pressed or held. and add it to the buffer.
func _process_direction():
	# Get the action from which the player pressed and see if player is either still holding or pressed and released.
	if can_direct == true:
		var current_time = Time.get_ticks_msec() / 1000.0
		var direction = ["left", "right", "up", "down"]
		for dir in direction:
			var action = Player_Identifier.Controls[dir]

			if Input.is_action_pressed(action):
				var is_held = input_states.get(action, false)

				add_to_buffer({
					"type": "direction",
					"value": dir,
					"onground": ray.onground == true,
					"facing": movement_dir.x,
					"timestamp": Time.get_ticks_msec(),
					"held": is_held
				})
func enable_direction():
	can_direct = true

func disable_direction():
	can_direct = false

func _process_jump_input():
	if !Animator.state == Wall:
			if can_jump == true and Input.is_action_just_pressed(Player_Identifier.Controls.jump) and Player_Stats.Jump_Count > 0:
				add_to_buffer({"type": "move", "value": "jump", "onground": ray.onground == true, "facing": 0 ,"timestamp": Time.get_ticks_msec()})
				linear_velocity.y =  -Player_Stats.Jump_Height
				JumpCloud.emit()
				Player_Stats.Jump_Count -= 1
				# Await 400ms so the jump can clear
				# await get_tree().create_timer(0.4).timeout
				previouslyjumped = true

func enable_jump():
	can_jump = true

func disable_jump():
	can_jump = false


func _process_dash_input():
	if can_dash == true and can_attack == true:
		if Input.is_action_just_pressed(Player_Identifier.Controls.dash):
			add_to_buffer({"type": "move", "value": "dash", "onground": ray.onground == true, "facing": 0 ,"timestamp": Time.get_ticks_msec()})


func enable_dash():
	can_dash = true

func disable_dash():
	can_dash = false


func _process_block_input():
	if can_block == true and can_attack == true:
		if Input.is_action_just_pressed(Player_Identifier.Controls.block):
			add_to_buffer({"type": "move", "value": "block", "onground": ray.onground == true, "facing": 0 ,"timestamp": Time.get_ticks_msec()})
			IsBlocking.emit()

func enable_block():
	can_block = true

func disable_block():
	can_block = false

func _process_attack_input():
		if can_attack == true:
			var attack = ["light", "heavy", "throw"]
			for atk in attack:
				var action = Player_Identifier.Controls[atk]
				var is_pressed = Input.is_action_pressed(action)
				var is_just_preessed = Input.is_action_just_pressed(action)
				var is_released = Input.is_action_just_released(action)

				# Set is_held status based on the action pressed.
				var is_held = is_pressed
				if 	is_just_preessed:
					is_held = true


				# Add the input to the buffer. This will be used to determine the action the player will take. \
				#Based on the input if pressed or release nad held.

				if is_just_preessed:
					add_to_buffer({
						"type": "attack",
						"value": atk,
						"onground": ray.onground == true,
						"facing": movement_dir.x,
						"timestamp": Time.get_ticks_msec(),
						"held": false
					})

func enable_attack():
	can_attack = true

func disable_attack():
	can_attack = false






func add_to_buffer(input_action):
	input_buffer.append(input_action)

	# Keep the buffer size within the buffer size of 3.
	if len(input_buffer) > max_buffer_limit:
		input_buffer.remove_at(0) # Remove the oldest input.

func clear_inputs():
	var current_time = Time.get_ticks_msec()
	var new_input_buffer = []

	for input in input_buffer:
		if current_time - input["timestamp"] <= buffer_time * 1000:
			new_input_buffer.append(input)

	input_buffer = new_input_buffer
	hold_start_time.clear()

func _input_debugger():
	if input_buffer.size() > 1 :
		pass
func _process_dual_direction():
	for dir in ["left", "right"]:
		var action = Player_Identifier.Controls[dir]

		if Input.is_action_just_pressed(action):
			var current_time = Time.get_ticks_msec()
			var time_since_last_input = current_time - last_direction_press[dir]
			if Animator.state in [Idle, Running, Dash]:
				if time_since_last_input <= 500 and last_direction == dir:
					match dir:
						"left":
							if Sprite.flip_h == false and ray.completely_on_the_floor == true:
								Animator.state = Backward_Step

							else:
								Animator.state = Forward_Step
						"right":
							if Sprite.flip_h == false and ray.completely_on_the_floor == true:
								Animator.state = Forward_Step

							else:
								Animator.state = Backward_Step


			last_direction_press[dir] = current_time
			last_direction = dir
func _process_dual_combinations():
	for i in range(len(input_buffer) - 1):
		var first_input = input_buffer[i]
		var second_input = input_buffer[i + 1]
		if first_input.type == "direction" and second_input.type == "attack":
			if first_input.held == true and first_input.onground == true and first_input.value == "up" and second_input.held == false and second_input.onground == true and second_input.value == "light":
				if Animator.state == Idle or Animator.state == Running:
					Animator.state = Neutral_Light

			if first_input.held == true and first_input.onground == true and first_input.value == "up" and second_input.held == false and second_input.onground == true and second_input.value == "heavy":
				if Animator.state == Idle or Animator.state == Running:
					Animator.state = Neutral_Heavy

			if first_input.held == true and first_input.onground == false and first_input.value == "up" and second_input.held == false and second_input.onground == false and second_input.value == "light":
				if Animator.state == Air:
					Animator.state = Neutral_Air

			if first_input.held == true and first_input.onground == false and first_input.value == "up" and second_input.held == false and second_input.onground == false and second_input.value == "heavy":
				if Animator.state == Air:
					Animator.state = Neutral_Recovery

			if first_input.held == true and first_input.onground == true and first_input.value == "down" and second_input.held == false and second_input.onground == true and second_input.value == "light":
					if Animator.state == Idle or Animator.state == Running:
						Animator.state = Down_Light_Start_Tap

			if first_input.held == true and first_input.onground == true and first_input.value == "down" and second_input.held == false and second_input.onground == true and  second_input.value == "heavy":
					if Animator.state == Idle or Animator.state == Running:
						Animator.state = Down_Heavy_Start_Tap

			if first_input.held == true and first_input.onground == false and first_input.value == "down" and second_input.held == false and second_input.onground == false and second_input.value == "light":
					if Animator.state == Air:
						Animator.state = Down_Air_Start_Tap

			if first_input.held == true and first_input.onground == false and first_input.value == "down" and second_input.held == false and second_input.onground == false and second_input.value == "heavy":
					if Animator.state == Air:
						Animator.state = Dowm_Recovery_Start_Tap

			if first_input.held == true and first_input.onground == true and first_input.value == "right" and second_input.held == false and second_input.onground == true and second_input.value == "light":
					if Animator.state == Idle or Animator.state == Running:
						Animator.state = Side_Light_Start_Tap

			if first_input.held == true and first_input.onground == true and first_input.value == "right" and second_input.held == false and second_input.onground == true and second_input.value == "heavy":
					if Animator.state == Idle or Animator.state == Running:
						Animator.state = Side_Heavy_Start_Tap

			if first_input.held == true and first_input.onground == false and first_input.value == "right" and second_input.held == false and second_input.onground == false and second_input.value == "light":
					if Animator.state == Air:
						Animator.state = Side_Air_Start_Tap


			if first_input.held == true and first_input.onground == true and first_input.value == "left" and second_input.held == false and second_input.onground == true and second_input.value == "light":
					if Animator.state == Idle or Animator.state == Running:
						Animator.state = Side_Light_Start_Tap


			if first_input.held == true and first_input.onground == true and first_input.value == "left" and second_input.held == false and second_input.value == "heavy" and second_input.onground == true:
					if Animator.state == Idle or Animator.state == Running:
						Animator.state = Side_Heavy_Start_Tap

			if first_input.held == true and first_input.value == "left" and second_input.held == false and second_input.value == "light" and second_input.onground == false:
					if Animator.state == Air:
						Animator.state = Side_Air_Start_Tap

func _proces_triple_combination():
	for i in range(len(input_buffer) - 1):
		var first_input = input_buffer[i]
		var second_input = input_buffer[i + 1]
		var third_input = input_buffer[i + 2]

		#if Animator.state == Air:
			#if first_input.type == "direction" and first_input.value == "down" and second_input.


# Change states based on input not requiring combination.
func _process_immediate_action():
	for input_action in input_buffer:
		match input_action.type:
			"move":
				if movement_dir.x != 0:
					if input_action.value == "dash" and input_action.onground == true:
						if Animator.state == Idle or Animator.state == Running:
							Animator.state = Dash
							Animator.play("Dash")

				if Animator.state in [Idle, Running]:
					if input_action.value == "block" and input_action.onground == true:
						Animator.state = Ground_Block_Start_Tap

				else:
					if input_action.value == "block" and input_action.onground == false:
						Animator.state = Air_Block_Start_Tap


			"direction":
				if Sprite.flip_h == false:
					if input_action.value == "left" and input_action.held == true:
						if Animator.state in [Idle]:
							Animator.state = Turning_Left

						if Animator.state in [Air]:
							FacingLeft.emit()
							print("Facing Left")

						if Animator.state in [Running]:
							Animator.state = Moving_Left



				if Sprite.flip_h == true:
					if input_action.value == "right" and input_action.held == true:
						if Animator.state in [Idle]:
							Animator.state = Turning_Right

						if Animator.state in [Air]:
							FacingRight.emit()

						if Animator.state in [Running]:
							Animator.state = Moving_Right

			"attack":
				if input_action.value == "throw" and input_action.onground == true:
					if Animator.state == Idle or Animator.state == Running:
						Animator.state = Ground_Throw_Start_Tap
						Animator.play("Ground Projectile")

				elif input_action.value == "throw" and input_action.onground == false:
					if Animator.state == Air:
						Animator.state = Air_Throw_Start_Tap

# Process actions that require a size of 1 input buffer
func _process_single_size_inputs() -> void:
	for input_action in input_buffer:
		if input_action.type == "attack":
			if input_buffer.size() <= 1:
				var onground = input_action.onground
				var is_direction_held = input_action.get("held", false)
				if input_action.value == "light":
					if is_direction_held == false:
						if onground == true:
							if Animator.state == Idle or Animator.state == Running:
								Animator.state = Neutral_Light
						if onground == false:
								Animator.state = Neutral_Air
				if input_action.value == "heavy":
					if is_direction_held == false:
						if onground == true:
							if Animator.state == Idle or Animator.state == Running:
								Animator.state = Neutral_Heavy

						if onground == false:
								Animator.state = Neutral_Recovery


func _on_animator_is_attacking() -> void:
	can_attack = false
	can_direct = false
	can_jump = false


func _on_animator_is_resetting() -> void:
	can_attack = true
	can_direct = true
	can_jump = true


func _on_animator_disable_movement() -> void:
	can_move = false


func _on_animator_enable_move_ment() -> void:
	can_move = true


func _on_stun_time_timeout() -> void:
	add_constant_central_force(Vector2(0,0))


func _on_hurtbox_is_hurt(Damage: int) -> void:
	CharacterList.player_1_health = Player_Stats.Health


# Refresh
func _on_refresh_block_timeout() -> void:
	can_block = true


func _on_is_attacking() -> void:
	can_attack = false
	can_direct = false
	can_jump = false
	can_dash = false


func _on_is_blocking() -> void:
	can_block = false


func _on_is_ressetting() -> void:
	can_attack = true
	can_direct = true
	can_jump = true

func face_left():
	FacingLeft.emit()

func face_right():
	FacingRight.emit()

# Enable the player actions after a certain time.
func _on_recovery_timer_timeout() -> void:
	can_attack = true
	can_direct = true
	can_jump = true
	can_dash = true



func _on_body_entered(body):
	pass # Replace with function body.
