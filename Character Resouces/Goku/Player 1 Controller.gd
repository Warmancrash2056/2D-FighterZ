extends Node2D

signal Player1Box

# Test to see if i can add the resource during instancing. #
@export var Controls: Resource = preload("res://Character Resouces/Global/Controller Resource/Player_1.tres")
@onready var Character: CharacterBody2D = $Character
@onready var Animator: AnimationPlayer = $Character/Character
@onready var Sprite: Sprite2D = $Character/Sprite

var direction = 1

var movement_dir: Vector2
var input_buffer = []
var max_buffer_limit = 3
var buffer_time = 0.3
var can_direct = true
var can_jump = true
var can_dash = true
var can_attack = true
enum {
	Idle,
	Turning,
	Running,
	Dash,
	Jump,
	Fall,
	Block,
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
	Throw,
	Hurt,
	Respawn
}

var state = Respawn
func _ready():
	Player1Box.emit()
	
func _process(delta: float) -> void:
	print(input_buffer)
	movement_dir = Vector2(Input.get_action_strength(Controls.right) - Input.get_action_strength(Controls.left),0)
	movement_dir.normalized()
	_process_input()
	_process_immediate_action()
	clear_inputs()
	_input_debugger()
	_process_combinations()
	
func _process_input():
	if can_direct:
		if Input.is_action_pressed(Controls.left):
			add_to_buffer({"type": "direction", "value": "left", "onground": Character.is_on_floor(), "facing": -1 ,"timestamp": Time.get_ticks_msec()})
			direction = -1

		if Input.is_action_pressed(Controls.right):
			add_to_buffer({"type": "direction", "value": "right", "onground": Character.is_on_floor(), "facing": 1 ,"timestamp": Time.get_ticks_msec()})
			direction = 1

		if Input.is_action_pressed(Controls.down):
			add_to_buffer({"type": "direction", "value": "down", "onground": Character.is_on_floor(), "facing": 0 ,"timestamp": Time.get_ticks_msec()})


		if Input.is_action_pressed(Controls.up):
			add_to_buffer({"type": "direction", "value": "up", "onground": Character.is_on_floor(), "facing": 0 ,"timestamp": Time.get_ticks_msec()})

	if can_jump == true:
		if Input.is_action_just_pressed(Controls.jump):
			add_to_buffer({"type": "move", "value": "jump", "onground": Character.is_on_floor(), "facing": 0 ,"timestamp": Time.get_ticks_msec()})

	if can_dash == true:
		if Input.is_action_just_pressed(Controls.dash):
			add_to_buffer({"type": "move", "value": "dash", "onground": Character.is_on_floor(), "facing": 0 ,"timestamp": Time.get_ticks_msec()})

	if can_attack == true:
		if Input.is_action_just_pressed(Controls.throw):
			add_to_buffer({"type": "attack", "value": "throw", "onground": Character.is_on_floor(), "facing": 0 ,"timestamp": Time.get_ticks_msec()})

		if Input.is_action_just_pressed(Controls.light):
			add_to_buffer({"type": "attack", "value": "light", "onground": Character.is_on_floor(), "facing": 0 ,"timestamp": Time.get_ticks_msec()})

		if Input.is_action_just_pressed(Controls.heavy):
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

func _process_immediate_action():
	for input_action in input_buffer:
		match input_action.type:
			"move":
				
				if state == Idle:
					if input_action.value == "dash" and input_action.facing == 0:
						state = Block

			"direction":
				if input_action.value == "left" and Sprite.flip_h == false:
					state = Turning

				if input_action.value == "right" and Sprite.flip_h == true:
					state = Turning

			"attack":
				if input_action.value == "throw" and input_action.facing == 0:
					state = Throw

				if Animator.state == Idle:
					if input_action.value == "light" and input_action.onground == true:
						Animator.state = Neutral_Light

		
