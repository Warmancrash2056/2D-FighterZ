extends CharacterBody2D

signal Player1Box
signal FacingLeft
signal FacingRight
signal JumpCloud
signal IsAttacking
signal IsBlocking
signal IsRessetting
# Test to see if i can add the resource during instancing. #
var Controls: Resource
@onready var Player_Stats: Node = $'Player Stats'
@onready var Player_Indicator: Sprite2D = $'Player Indicator'
@onready var Animator: AnimationPlayer = $Animator
@onready var Sprite: Sprite2D = $Sprite
@onready var Wall_Detector: RayCast2D = $'Wall Detector'
@onready var Hurtbox:Area2D = $Hurtbox
@onready var Player_Identifier: Node2D = $'..'
var direction = 1

var movement_dir: Vector2
var input_buffer = []
var max_buffer_limit = 3
var buffer_time = 0.1


var can_move = true
var can_direct = true
var can_jump = true
var can_dash = true
var can_attack = true
var can_block = true
enum {
	Idle,
	Turning,
	Running,
	Dash,
	Wall,
	Air,
	Ground_Block,
	Air_Block,
	Neutral_Light,
	Neutral_Heavy,
	Neutral_Air,
	Neutral_Recovery,
	Side_Light,
	Side_Heavy,
	Side_Air,
	Down_Light,
	Down_Heavy,
	Down_Air,
	Dowm_Recovery,
	Ground_Throw,
	Air_Throw,
	Hurt,
	Recover,
	Respawn
}

var state = Respawn
func _ready():
	pass

func _physics_process(delta: float) -> void:
	if Hurtbox.goku_neautral_havy == true:
		global_position = CharacterList.goku_neutral_heavy_grab_position
	_get_movement()
	move_and_slide()
func _process(delta: float) -> void:
	_process_input()
	_process_attack_input()
	_process_block_input()
	_process_dash_input()
	_process_jump_input()
	_process_immediate_action()
	_process_single_size_inputs()
	clear_inputs()
	_input_debugger()
	_process_dual_combinations()


# Disable movement at crtain frame of attack and enable at the end of attack.
#Player can only move in the direction they are facing.
func _get_movement():
	if Wall_Detector.is_colliding() and Animator.state == Wall:
		velocity.y = 10

	else:
		velocity.y += Player_Stats.Gravity
	var new_speed
	var air_rating: float = Player_Stats.Speed_Rating + 0.25
	var decelleration =  Player_Stats.Decelleration
	if is_on_floor():
		new_speed = Player_Stats.Max_Speed * Player_Stats.Speed_Rating
		decelleration =  Player_Stats.Decelleration
	else:
		new_speed = air_rating * Player_Stats.Max_Speed
		decelleration =  5


	if can_move == true:
		movement_dir = Vector2(Input.get_action_strength(Player_Identifier.Controls.right) - Input.get_action_strength(Player_Identifier.Controls.left),0)
		movement_dir.normalized()

		if movement_dir.x == 1:
			velocity.x = move_toward(velocity.x, new_speed, Player_Stats.Acceleration)

		elif  movement_dir.x == -1:
			velocity.x = move_toward(velocity.x, -new_speed, Player_Stats.Acceleration)

		else:
			velocity.x = move_toward(velocity.x, 0, decelleration)

func _process_input():
	if can_direct == true:
		if Input.is_action_pressed(Player_Identifier.Controls.left):
			add_to_buffer({"type": "direction", "value": "left", "onground": is_on_floor(), "facing": -1 ,"timestamp": Time.get_ticks_msec()})

		if Input.is_action_pressed(Player_Identifier.Controls.right):
			add_to_buffer({"type": "direction", "value": "right", "onground": is_on_floor(), "facing": 1 ,"timestamp": Time.get_ticks_msec()})

		if Input.is_action_pressed(Player_Identifier.Controls.down):
			add_to_buffer({"type": "direction", "value": "down", "onground": is_on_floor(), "facing": 0 ,"timestamp": Time.get_ticks_msec()})
			if Animator.state == Air and !is_on_floor() and can_attack == true:
				if Input.is_action_just_pressed(Player_Identifier.Controls.down):
					await get_tree().create_timer(0.2).timeout
					if can_attack == true:
						velocity.y += 100

		if Input.is_action_pressed(Player_Identifier.Controls.up):
			add_to_buffer({"type": "direction", "value": "up", "onground": is_on_floor(), "facing": 0 ,"timestamp": Time.get_ticks_msec()})
func _process_jump_input():
		if can_jump == true and Input.is_action_just_pressed(Player_Identifier.Controls.jump) and Player_Stats.Jump_Count > 0:
			add_to_buffer({"type": "move", "value": "jump", "onground": is_on_floor(), "facing": 0 ,"timestamp": Time.get_ticks_msec()})
			velocity.y = -Player_Stats.Jump_Height
			JumpCloud.emit()
			Player_Stats.Jump_Count -= 1

func _process_dash_input():
	if can_dash == true:
		if Input.is_action_just_pressed(Player_Identifier.Controls.dash):
			add_to_buffer({"type": "move", "value": "dash", "onground": is_on_floor(), "facing": 0 ,"timestamp": Time.get_ticks_msec()})

func _process_block_input():
	if can_block == true and can_attack == true:
		if Input.is_action_just_pressed(Player_Identifier.Controls.dash):
			add_to_buffer({"type": "move", "value": "block", "onground": is_on_floor(), "facing": 0 ,"timestamp": Time.get_ticks_msec()})
			IsBlocking.emit()
func _process_attack_input():
	if can_attack == true:
		if Input.is_action_just_pressed(Player_Identifier.Controls.throw):
			add_to_buffer({"type": "attack", "value": "throw", "onground": is_on_floor(), "facing": 0 ,"timestamp": Time.get_ticks_msec()})
			IsAttacking.emit()

		if Input.is_action_just_pressed(Player_Identifier.Controls.light):
			add_to_buffer({"type": "attack", "value": "light", "onground": is_on_floor(), "facing": 0 ,"timestamp": Time.get_ticks_msec()})
			IsAttacking.emit()

		if Input.is_action_just_pressed(Player_Identifier.Controls.heavy):
			add_to_buffer({"type": "attack", "value": "heavy", "onground": is_on_floor(), "facing": 0 ,"timestamp": Time.get_ticks_msec()})
			IsAttacking.emit()








func add_to_buffer(input_action):
	input_buffer.append(input_action)

	# Keep the buffer size within the buffer size of 3.
	if len(input_buffer) > max_buffer_limit:
		input_buffer.pop_at(0) # Remove the oldest input.

func clear_inputs():
	var current_time = Time.get_ticks_msec()
	var new_input_buffer = []

	for input in input_buffer:
		if current_time - input.timestamp <= buffer_time * 1000:
			new_input_buffer.append(input)

	input_buffer = new_input_buffer

func _input_debugger():
	if input_buffer.size() > 1 :
		pass

func _process_dual_combinations():
	for i in range(len(input_buffer) - 1):
		var first_input = input_buffer[i]
		var second_input = input_buffer[i + 1]
		if first_input.type == "direction":
			if first_input.onground == true and first_input.value == "right" and second_input.onground == true and second_input.type == "attack" and second_input.value == "light":
				Animator.state = Side_Light

			if first_input.onground == true and first_input.value == "left" and  second_input.onground == true and second_input.type == "attack" and second_input.value == "light":
				Animator.state = Side_Light

			if first_input.onground == true and first_input.value == "right" and second_input.onground == true and second_input.type == "attack" and second_input.value == "heavy":
				if Animator.state == Idle:
					Animator.state = Side_Heavy

			if first_input.onground == true and first_input.value == "left"  and second_input.onground == true and second_input.type == "attack" and second_input.value == "heavy":
				if Animator.state == Idle:
					Animator.state = Side_Heavy

			if first_input.onground == false and first_input.value == "right" and second_input.onground == false and second_input.type == "attack" and second_input.value == "light":
				if Animator.state == Air:
					Animator.state = Side_Air

			if first_input.onground == false and first_input.value == "left" and second_input.onground == false and second_input.type == "attack" and second_input.value == "light":
				if Animator.state == Air:
					Animator.state = Side_Air


			if first_input.value == "down" and second_input.type == "attack" and second_input.value == "light":
				if is_on_floor():
					Animator.state = Down_Light

				else:
					Animator.state = Down_Air

			if first_input.value == "down" and second_input.type == "attack" and second_input.value == "heavy":
				if is_on_floor():
					Animator.state = Down_Heavy

				else:
					Animator.state = Dowm_Recovery

			if first_input.value == "up" and second_input.type == "attack" and second_input.value == "light":
				if is_on_floor():
					Animator.state = Neutral_Light

				else:
					Animator.state = Neutral_Air


			if first_input.value == "up" and second_input.type == "attack" and second_input.value == "heavy":
				if is_on_floor():
					Animator.state = Neutral_Heavy

				else:
					Animator.state = Neutral_Recovery

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
				if input_action.value == "block" and input_action.onground == true:
					Animator.state = Ground_Block

				if input_action.value == "block" and input_action.onground == false:
					Animator.state = Air_Block

				if input_action.value == "jump" and Player_Stats.Jump_Count > 0:
					Animator.state = Air
					velocity.y = -Player_Stats.Jump_Height


			"direction":
				if input_action.value == "left" and !Animator.state == Wall:
					FacingLeft.emit()



				if input_action.value == "right" and !Animator.state == Wall:
					FacingRight.emit()

			"attack":
				if input_action.value == "throw" and input_action.onground == true:
					Animator.state = Ground_Throw

				if input_action.value == "throw" and input_action.onground == false:
					Animator.state = Air_Throw

# Process actions that require a size of 1 input buffer
func _process_single_size_inputs() -> void:
	for input_action in input_buffer:
		match input_action.type:
			"attack":
				if input_buffer.size() < 2:
					if input_action.value == "light" and input_action.onground == true:
						Animator.state = Neutral_Light

					if input_action.value == "heavy" and input_action.onground == true:
						Animator.state = Neutral_Heavy

					if input_action.value == "light" and input_action.onground == false:
						Animator.state = Neutral_Air

					if input_action.value == "heavy" and input_action.onground == false:
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
	velocity.x = move_toward(velocity.x, 0, 100)
	velocity.y = move_toward(velocity.y, 0, 100)


func _on_hurtbox_is_hurt(Damage: int) -> void:
	CharacterList.player_1_health = Player_Stats.Health


# Refresh
func _on_refresh_block_timeout() -> void:
	can_block = true


func _on_is_attacking() -> void:
	can_attack = false
	can_direct = false
	can_jump = false


func _on_is_blocking() -> void:
	can_block = false


func _on_is_ressetting() -> void:
	can_attack = true
	can_direct = true
	can_jump = true
