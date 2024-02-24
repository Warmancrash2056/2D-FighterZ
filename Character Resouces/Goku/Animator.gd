class_name Aniamtor extends AnimationPlayer

@export var Controller: Node
@export var Character: CharacterBody2D
@export var Scaler: Node
@export var Sprite: Sprite2D

# Get directions of player
var movement_dir: Vector2
var direction: int 

var Attack_Vector: Vector2
var start_movement = false
@export var Throw_Ground: Vector2
@export var Throw_Air: Vector2
@export var Nlight: Vector2
@export var NHeavy: Vector2
@export var NAir: Vector2
@export var NRecovery: Vector2
@export var Slight: Vector2
@export var SHeavy: Vector2
@export var SAir: Vector2
@export var Dlight: Vector2
@export var DHeavy: Vector2
@export var DAir: Vector2
@export var DRecovery: Vector2

var input_buffer = []
var max_buffer_limit = 3
var buffer_time = 0.2
var can_direct = true
var can_jump = true
var can_dash = true
var can_attack = true

signal FacingLeft
signal FacingRight
signal IsMoving(vector)
signal OnGround
signal IsDashing
signal IsStopping
signal AttackMoving(Vector)
signal IsAttacking
signal IsResetting
signal IsJumping
signal IsThrowing
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
func _process_input():
	print(can_attack, can_direct, can_jump)
	if can_direct:
		if Input.is_action_pressed(Controller.Controls.left):
			add_to_buffer({"type": "direction", "value": "left", "onground": Character.is_on_floor(), "facing": -1 ,"timestamp": Time.get_ticks_msec()})
			direction = -1
		if Input.is_action_pressed(Controller.Controls.right):
			add_to_buffer({"type": "direction", "value": "right", "onground": Character.is_on_floor(), "facing": 1 ,"timestamp": Time.get_ticks_msec()})
			FacingRight.emit()
			direction = 1
			
		if Input.is_action_pressed(Controller.Controls.down):
			add_to_buffer({"type": "direction", "value": "down", "onground": Character.is_on_floor(), "facing": 0 ,"timestamp": Time.get_ticks_msec()})
			
	
		if Input.is_action_pressed(Controller.Controls.up):
			add_to_buffer({"type": "direction", "value": "up", "onground": Character.is_on_floor(), "facing": 0 ,"timestamp": Time.get_ticks_msec()})
			
	if can_jump == true:
		if Input.is_action_just_pressed(Controller.Controls.jump):
			add_to_buffer({"type": "move", "value": "jump", "onground": Character.is_on_floor(), "facing": 0 ,"timestamp": Time.get_ticks_msec()})
			IsJumping.emit()
	
	if can_dash == true:	
		if Input.is_action_just_pressed(Controller.Controls.dash):
			add_to_buffer({"type": "move", "value": "dash", "onground": Character.is_on_floor(), "facing": 0 ,"timestamp": Time.get_ticks_msec()})
	if can_attack == true:	
		if Input.is_action_just_pressed(Controller.Controls.throw):
			add_to_buffer({"type": "attack", "value": "throw", "onground": Character.is_on_floor(), "facing": 0 ,"timestamp": Time.get_ticks_msec()})
		elif Input.is_action_just_pressed(Controller.Controls.light):
			add_to_buffer({"type": "attack", "value": "light", "onground": Character.is_on_floor(), "facing": 0 ,"timestamp": Time.get_ticks_msec()})
		elif Input.is_action_just_pressed(Controller.Controls.heavy):
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
	
func _process_combinations():
	for i in range(len(input_buffer) - 1):
		var first_input = input_buffer[i]
		var second_input = input_buffer[i + 1]
		if first_input.type == "direction":
			if first_input.facing == -1 and first_input.value == "left" and second_input.type == "attack" and second_input.value == "light":
				if first_input.onground == true:
					state = Side_Light
				
				else:
					state = Side_Air
			
			if first_input.facing == -1 and first_input.value == "left" and second_input.type == "attack" and second_input.value == "heavy":
				if first_input.onground == true:
						state = Side_Heavy
				
			if first_input.facing == 1 and first_input.value == "right" and second_input.type == "attack" and second_input.value == "light":
				if first_input.onground == true:
					state = Side_Light
				
				else:
					state = Side_Air
			
			if first_input.facing == 1 and first_input.value == "right" and second_input.type == "attack" and second_input.value == "heavy":
					if first_input.onground == true:
						state = Side_Heavy
				
			if first_input.value == "down" and second_input.type == "attack" and second_input.value == "light":
				if first_input.onground == true:
					state = Down_Light
				
				else:
					state = Down_Air
					
			
			if first_input.value == "down" and second_input.type == "attack" and second_input.value == "heavy":
				if first_input.onground == true:
					state = Down_Heavy
					
				else:
					state = Dowm_Recovery
		if first_input.type == "direction" and first_input.value == "up" and second_input.type == "attack" and second_input.value == "light":
				if second_input.onground == true:
					state = Neutral_Light
					
				else:
					state = Neutral_Air
		
func _process_immediate_action():
	for input_action in input_buffer:
		match input_action.type:
			"move":
				if input_action.value == "jump":
					state = Jump
				
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
				
			
func _process(delta):
	movement_dir = Vector2(Input.get_action_strength(Controller.Controls.right) - Input.get_action_strength(Controller.Controls.left),0)
	movement_dir.normalized()
func _physics_process(delta):
	_process_input()
	_process_combinations()
	_process_immediate_action()
	clear_inputs()		
	
	match state:
		Idle:
			if !Character.is_on_floor():
				state = Jump
			emit_signal("IsStopping")
			play("Idle")
			
			if movement_dir.x != 0:
				if Engine.get_physics_frames() % 2 == 0:
					state = Running
					
			if Input.is_action_just_pressed(Controller.Controls.light):
				#state = Neutral_Light
				IsAttacking.emit()
				
			elif Input.is_action_just_pressed(Controller.Controls.heavy):
				state = Neutral_Heavy
				IsAttacking.emit()
			
		Turning:
			if direction == 1:
				FacingRight.emit()
				state = Idle # change to turn animation 
				
			if direction == -1:
				FacingLeft.emit()
				state = Idle
			
		Running:
			IsMoving.emit(movement_dir)
			play("Run")
			
			if movement_dir.x == 0:
				state = Idle
		Dash:
			play("Dash")
		Jump:
			play("Jump")
			if movement_dir.x != 0:
				IsMoving.emit(movement_dir)
				
			else:
				IsStopping.emit()
			if Character.is_on_floor():
				state = Idle
				emit_signal("OnGround")
				
								
			if Input.is_action_just_pressed(Controller.Controls.light):
				state = Neutral_Air
				IsAttacking.emit()
				
			elif Input.is_action_just_pressed(Controller.Controls.heavy):
				state = Neutral_Recovery
				IsAttacking.emit()
				
		Fall:
			play("Fall")
			
			if movement_dir.x != 0:
				IsMoving.emit()
				
			else:
				IsStopping.emit()
				
			if Character.is_on_floor():
				state = Idle
				emit_signal("OnGround")
		Block:
			if Character.is_on_floor():
				play("Ground Block")
				
			else:
				play("Air Block")
				
				
		Respawn:
			play("Respawn")
			
		Throw:
			
			if start_movement == true:
				_attack_movement()
				
			if Character.is_on_floor():
				play("Ground Projectile")
				Attack_Vector = Throw_Ground
				
			else:
				play("Air Projectile")
				Attack_Vector = Throw_Air
				
		Neutral_Light:
			Attack_Vector = Nlight
			if start_movement == true:
				_attack_movement()
			play("Neutral Light")
			
		Neutral_Heavy:
			Attack_Vector = NHeavy
			if start_movement == true:
				_attack_movement()
			play("Neutral Heavy")
			
		Neutral_Air:
			Attack_Vector = NAir
			if start_movement == true:
				_attack_movement()
			play("Neutral Air")
			
		Neutral_Recovery:
			if start_movement == true:
				_attack_movement()
			Attack_Vector = NRecovery
			play("Neutral Recovery")
			
		Side_Light:
			if start_movement == true:
				_attack_movement()
			Attack_Vector = Slight
			play("Side Light")
		
		Side_Heavy:
			if start_movement == true:
				_attack_movement()
			Attack_Vector = SHeavy
			play("Side Heavy")
			
		Side_Air:
			if start_movement == true:
				_attack_movement()
			Attack_Vector = SAir
			play("Side Air")
			
		Down_Light:
			if start_movement == true:
				_attack_movement()
			Attack_Vector = Dlight
			play("Down Light")
			
		Down_Heavy:
			if start_movement == true:
				_attack_movement()
			Attack_Vector = DHeavy
			play("Down Heavy")
		
		Down_Air:
			if start_movement == true:
				_attack_movement()
			Attack_Vector = DAir
			play("Down Air")
			
		Dowm_Recovery:
			if start_movement == true:
				_attack_movement()
			Attack_Vector = DRecovery
			play("Down Recovery")
			

#func _side_transition():
	#if side_transition == true:
		#play("Side Finish")


func _attack_movement():
	Attack_Vector.x *= Scaler.direction
	AttackMoving.emit(Attack_Vector)
	
	


func idle_reset():
	Attack_Vector = Vector2.ZERO
	can_jump = true
	if Character.is_on_floor():
		state = Idle
		IsResetting.emit()
		play("Idle")
	if !Character.is_on_floor():
		state = Fall
		IsResetting.emit()
		play("Fall")

func start_attack_movment():
	start_movement = true
	
func stop_attack_movment():
	start_movement = false
func _on_is_attacking():
	can_jump = false
	can_direct = false
	can_attack = false

func attack_active():
	IsAttacking.emit()
	
func _on_is_resetting():
	can_jump = true
	can_direct = true
	can_attack = true
