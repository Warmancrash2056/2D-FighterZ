extends CharacterBody2D

signal Player1Box
signal FacingLeft
signal FacingRight
signal JumpCloud
# Test to see if i can add the resource during instancing. #
var Controls: Resource = preload('res://Character Resouces/Global/Controller Resource/Player_1.tres')
@onready var Player_Stats: Node = $'Player Stats'
@onready var Animator: AnimationPlayer = $Animator
@onready var Sprite: Sprite2D = $Sprite
@onready var Wall_Detector: RayCast2D = $'Wall Detector'
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
	Player1Box.emit()

func _physics_process(delta: float) -> void:
	_get_movement()
	move_and_slide()
func _process(delta: float) -> void:
	on_wall()
	_process_input()
	_process_attack_input()
	_process_block_input()
	_process_dash_input()
	_process_jump_input()
	_process_immediate_action()
	_process_single_size_inputs()
	clear_inputs()
	_input_debugger()
	_process_combinations()

# Disable movement at crtain frame of attack and enable at the end of attack.
#Player can only move in the direction they are facing.
func _get_movement():
	var new_speed
	var air_rating: float = Player_Stats.Speed_Rating + 0.1

	if is_on_floor():
		new_speed = Player_Stats.Max_Speed * Player_Stats.Speed_Rating

	else:
		new_speed = air_rating * Player_Stats.Max_Speed
	if can_move == true:
		movement_dir = Vector2(Input.get_action_strength(Controls.right) - Input.get_action_strength(Controls.left),0)
		movement_dir.normalized()

		if movement_dir.x == 1 and Sprite.flip_h == false:
			velocity.x = move_toward(velocity.x, new_speed, Player_Stats.Acceleration)

		elif  movement_dir.x == -1 and Sprite.flip_h == true:
			velocity.x = move_toward(velocity.x, -new_speed, Player_Stats.Acceleration)

		else:
			velocity.x = move_toward(velocity.x, 0, Player_Stats.Decelleration)
func on_wall():
	if is_on_wall() and Wall_Detector.is_colliding():
		Animator.state = Wall


func _process_input():
	if can_direct == true:
		if Input.is_action_pressed(Controls.left):
			add_to_buffer({"type": "direction", "value": "left", "onground": is_on_floor(), "facing": -1 ,"timestamp": Time.get_ticks_msec()})

		if Input.is_action_pressed(Controls.right):
			add_to_buffer({"type": "direction", "value": "right", "onground": is_on_floor(), "facing": 1 ,"timestamp": Time.get_ticks_msec()})


		if Input.is_action_pressed(Controls.down):
			add_to_buffer({"type": "direction", "value": "down", "onground": is_on_floor(), "facing": 0 ,"timestamp": Time.get_ticks_msec()})


		if Input.is_action_pressed(Controls.up):
			add_to_buffer({"type": "direction", "value": "up", "onground": is_on_floor(), "facing": 0 ,"timestamp": Time.get_ticks_msec()})
func _process_jump_input():
	if can_jump == true:
		if Input.is_action_just_pressed(Controls.jump) and Player_Stats.Jump_Count > 0:
			add_to_buffer({"type": "move", "value": "jump", "onground": is_on_floor(), "facing": 0 ,"timestamp": Time.get_ticks_msec()})
			if can_attack == true:
				velocity.y = -Player_Stats.Jump_Height
				JumpCloud.emit()
				Player_Stats.Jump_Count -= 1




func _process_dash_input():
	if can_dash == true:
		if Input.is_action_just_pressed(Controls.dash):
			add_to_buffer({"type": "move", "value": "dash", "onground": is_on_floor(), "facing": 0 ,"timestamp": Time.get_ticks_msec()})

func _process_block_input():
	if can_block == true:
		if Input.is_action_just_pressed(Controls.dash):
			add_to_buffer({"type": "move", "value": "block", "onground": is_on_floor(), "facing": 0 ,"timestamp": Time.get_ticks_msec()})
func _process_attack_input():
	if can_attack == true:
		if Input.is_action_just_pressed(Controls.throw):
			add_to_buffer({"type": "attack", "value": "throw", "onground": is_on_floor(), "facing": 0 ,"timestamp": Time.get_ticks_msec()})

		if Input.is_action_just_pressed(Controls.light):
			add_to_buffer({"type": "attack", "value": "light", "onground": is_on_floor(), "facing": 0 ,"timestamp": Time.get_ticks_msec()})

		if Input.is_action_just_pressed(Controls.heavy):
			add_to_buffer({"type": "attack", "value": "heavy", "onground": is_on_floor(), "facing": 0 ,"timestamp": Time.get_ticks_msec()})




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

func _process_combinations():
	for i in range(len(input_buffer) - 1):
		var first_input = input_buffer[i]
		var second_input = input_buffer[i + 1]
		if first_input.type == "direction":
			if first_input.facing == -1 and first_input.value == "left" and second_input.type == "attack" and second_input.value == "light" and second_input.onground == true:
				Animator.state = Side_Light

			if first_input.facing == -1 and first_input.value == "left" and second_input.type == "attack" and second_input.value == "light" and second_input.onground == false:
				Animator.state = Side_Air

			if first_input.facing == -1 and first_input.value == "left" and second_input.type == "attack" and second_input.value == "heavy" and second_input.onground == true:
				Animator.state = Side_Heavy

			if first_input.facing == 1 and first_input.value == "right" and second_input.type == "attack" and second_input.value == "light" and second_input.onground == true:
				Animator.state = Side_Light

			if first_input.facing == 1 and first_input.value == "right" and second_input.type == "attack" and second_input.value == "light" and second_input.onground == false:
				Animator.state = Side_Air

			if first_input.facing == 1 and first_input.value == "right" and second_input.type == "attack" and second_input.value == "heavy" and second_input.onground == true:
				Animator.state = Side_Heavy

			if first_input.value == "down" and second_input.type == "attack" and second_input.value == "light" and second_input.onground == true:
				Animator.state = Down_Light


			if first_input.value == "down" and second_input.type == "attack" and second_input.value == "light" and second_input.onground == false:
				Animator.state = Down_Air



			if first_input.value == "down" and second_input.type == "attack" and second_input.value == "heavy" and second_input.onground == true:
				Animator.state = Down_Heavy

			if first_input.value == "down" and second_input.type == "attack" and second_input.value == "heavy" and second_input.onground == false:
				Animator.state = Dowm_Recovery

			if first_input.value == "up" and second_input.type == "attack" and second_input.value == "light" and second_input.onground == true:
				Animator.state = Neutral_Light

			if first_input.value == "up" and second_input.type == "attack" and second_input.value == "heavy" and second_input.onground == true:
				Animator.state = Neutral_Heavy

			if first_input.value == "up" and second_input.type == "attack" and second_input.value == "light" and second_input.onground == false:
				Animator.state = Neutral_Air

			if first_input.value == "up" and second_input.type == "attack" and second_input.value == "heavy" and second_input.onground == false:
				Animator.state = Neutral_Recovery

# Change states based on input not requiring combination.
func _process_immediate_action():
	for input_action in input_buffer:
		match input_action.type:
			"move":
				if input_action.value == "block" and input_action.onground == true:
					Animator.state = Ground_Block

				if input_action.value == "block" and input_action.onground == false:
					Animator.state = Air_Block


			"direction":
				if input_action.value == "left":
					FacingLeft.emit()

				if input_action.value == "right":
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
	can_block = false
	can_direct = false
	can_jump = false


func _on_animator_is_resetting() -> void:
	can_attack = true
	can_block = true
	can_direct = true
	can_jump = true


func _on_animator_disable_movement() -> void:
	can_move = false


func _on_animator_enable_move_ment() -> void:
	can_move = true
