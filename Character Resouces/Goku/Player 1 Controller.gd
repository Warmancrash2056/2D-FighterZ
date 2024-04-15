extends Node2D

signal Player1Box
signal FacingLeft
signal FacingRight
signal IsJumping
signal IsMoving(Vector)
signal IsStopping
# Test to see if i can add the resource during instancing. #
@export var Input_Map: Node2D
@onready var Character: CharacterBody2D = $Character
@onready var Animator: AnimationPlayer = $Character/Character
@onready var Sprite: Sprite2D = $Character/Sprite
@export var Wall_Detector: RayCast2D
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
	Air,
	Wall,
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
	Respawn
}


var state = Respawn

func _physics_process(delta):
	_get_movement()
	_detect_wall()
	_turn_around()
	_process_input()
	_process_attack_input()
	_process_block_input()
	_process_dash_input()
	_process_immediate_action()
	_process_single_size_inputs()
	clear_inputs()
	_input_debugger()
	_process_combinations()
func _get_movement():
	if can_move == true:
		movement_dir = Vector2(Input.get_action_strength(Input_Map.Controler.right) - Input.get_action_strength(Input_Map.Controler.left),0)
		movement_dir.normalized()

		if movement_dir.x != 0:
			IsMoving.emit(movement_dir.x)

		else:
			IsStopping.emit()

func _detect_wall():
	if Wall_Detector.is_colliding() and Character.is_on_wall():
		print("On wall")


func _turn_around():
	if Input.is_action_pressed(Input_Map.Controler.left) and Sprite.flip_h == false:
		if Engine.get_physics_frames() % 5 == 0:
			FacingLeft.emit()


	if Input.is_action_pressed(Input_Map.Controler.right) and Sprite.flip_h == true:
		if Engine.get_physics_frames() % 5 == 0:
			FacingRight.emit()
func _process_input():
	if can_direct:
		if Input.is_action_pressed(Input_Map.Controler.left):
			add_to_buffer({"type": "direction", "value": "left", "onground": Character.is_on_floor(), "facing": -1 ,"timestamp": Time.get_ticks_msec()})
			direction = -1

		if Input.is_action_pressed(Input_Map.Controler.right):
			add_to_buffer({"type": "direction", "value": "right", "onground": Character.is_on_floor(), "facing": 1 ,"timestamp": Time.get_ticks_msec()})
			direction = 1

		if Input.is_action_pressed(Input_Map.Controler.down):
			add_to_buffer({"type": "direction", "value": "down", "onground": Character.is_on_floor(), "facing": 0 ,"timestamp": Time.get_ticks_msec()})


		if Input.is_action_pressed(Input_Map.Controler.up):
			add_to_buffer({"type": "direction", "value": "up", "onground": Character.is_on_floor(), "facing": 0 ,"timestamp": Time.get_ticks_msec()})


		if Input.is_action_just_pressed(Input_Map.Controler.jump):
			add_to_buffer({"type": "move", "value": "jump", "onground": Character.is_on_floor(), "facing": 0 ,"timestamp": Time.get_ticks_msec()})
			if can_attack == true:
				IsJumping.emit()

func _process_dash_input():
	if can_dash == true:
		if Input.is_action_just_pressed(Input_Map.Controler.dash):
			add_to_buffer({"type": "move", "value": "dash", "onground": Character.is_on_floor(), "facing": 0 ,"timestamp": Time.get_ticks_msec()})

func _process_block_input():
	if can_block == true:
		if Input.is_action_just_pressed(Input_Map.Controler.block):
			add_to_buffer({"type": "move", "value": "block", "onground": Character.is_on_floor(), "facing": 0 ,"timestamp": Time.get_ticks_msec()})
func _process_attack_input():
	if can_attack == true:
		if Input.is_action_just_pressed(Input_Map.Controler.throw):
			add_to_buffer({"type": "attack", "value": "throw", "onground": Character.is_on_floor(), "facing": 0 ,"timestamp": Time.get_ticks_msec()})

		if Input.is_action_just_pressed(Input_Map.Controler.light):
			add_to_buffer({"type": "attack", "value": "light", "onground": Character.is_on_floor(), "facing": 0 ,"timestamp": Time.get_ticks_msec()})

		if Input.is_action_just_pressed(Input_Map.Controler.heavy):
			add_to_buffer({"type": "attack", "value": "heavy", "onground": Character.is_on_floor(), "facing": 0 ,"timestamp": Time.get_ticks_msec()})




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

			if Animator.state == Idle and first_input.value == "right" and second_input.type == "attack" and second_input.value == "light" and second_input.onground == true:
				Animator.state = Side_Light

			if Animator.state == Air and first_input.value == "right" and second_input.type == "attack" and second_input.value == "light" and second_input.onground == false:
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
				if input_action.value == "left" and Sprite.flip_h == false:
					pass

				if input_action.value == "right" and Sprite.flip_h == true:
					pass

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

