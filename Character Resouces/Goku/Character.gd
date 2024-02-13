class_name Aniamtor extends AnimationPlayer

@export var Controller: Node
@export var Character: CharacterBody2D

signal IsMoving
signal IsDashing
signal IsStopping
signal IsAttacking
signal IsBlocking
signal IsJumping
enum {
	Idle,
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


var state = Idle
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match state:
		Idle:
			play("Idle")
			if Controller.direction.x != 0:
				emit_signal("IsMoving")
				if Engine.get_process_frames() % 2 == 0:
					state = Running
			if Controller.direction.y != 0:
				if Controller.light == true:
					emit_signal("IsAttacking")
					state = Down_Light
					Controller.light = false
					
				if Controller.heavy == true:
					emit_signal("IsAttacking")
					state = Down_Light
					Controller.heavy = false
			if Controller.light == true:
				emit_signal("IsAttacking")
				state = Neutral_Light
				Controller.light = false
				
			if Controller.heavy == true:
				emit_signal("IsAttacking")
				state = Neutral_Heavy
				Controller.heavy = false
				
			if Controller.throw == true:
				emit_signal("IsAttacking")
				state = Throw
				Controller.throw = false
				
			if Controller.dash == true:
				emit_signal("IsStopping")
				state = Block
				Controller.dash = false
				
			if Controller.jump == true and Character.Jump_Count > 0:
				emit_signal("IsJumping")
				state = Jump
				Controller.jump = false
			
		Running:
			play("Run")
			
			if Controller.direction.x == 0:
				emit_signal("IsStopping")
				state = Idle
				
			if Controller.direction.y != 0:
				if Controller.light == true:
					emit_signal("IsAttacking")
					state = Down_Light
					Controller.light = false
					
				if Controller.heavy == true:
					emit_signal("IsAttacking")
					state = Down_Light
					Controller.heavy = false
					
			if Controller.light == true:
				emit_signal("IsAttacking")
				state = Side_Light
				Controller.light = false
				
			if Controller.heavy == true:
				emit_signal("IsAttacking")
				state = Side_Heavy
				Controller.heavy = false
				
			if Controller.throw == true:
				emit_signal("IsAttacking")
				state = Throw
				Controller.throw = false
			
			if Controller.dash == true:
				emit_signal("IsDashing")
				state = Dash
				Controller.dash = false
				
			
			if Controller.jump == true and Character.Jump_Count > 0:
				emit_signal("IsJumping")
				state = Jump
				Controller.jump = false
				Character.Jump_Count -= 1
				
		Dash:
			play("Dash")
			
			if Controller.direction.x != 0:
				if Controller.light == true:
					emit_signal("IsAttacking")
					state = Side_Light
					Controller.light = false
					
				if Controller.heavy == true:
					emit_signal("IsAttacking")
					state = Side_Heavy
					Controller.heavy = false
			if Controller.direction.y != 0:
				if Controller.light == true:
					emit_signal("IsAttacking")
					state = Down_Light
					Controller.light = false
					
				if Controller.heavy == true:
					emit_signal("IsAttacking")
					state = Down_Heavy
					Controller.heavy = false
					
			if Controller.throw == true:
				emit_signal("IsAttacking")
				state = Throw
				Controller.throw = false
			
			if Controller.dash == true:
				emit_signal("IsStopping")
				state = Block
				Controller.dash = false
				
			if Controller.jump == true and Character.Jump_Count > 0:
				emit_signal("IsJumping")
				state = Jump
				Controller.jump = false
				Character.Jump_Count -= 1
		Jump:
			play("Jump")
			
			if Controller.direction.x != 0:
				emit_signal("IsMoving")
				
				if Controller.light == true:
					emit_signal("IsAttacking")
					state = Side_Air
					
			else:
				emit_signal("IsStopping")
				
				if Controller.light == true:
					emit_signal("IsAttacking")
					state = Neutral_Air
					Controller.light = false
					
				if Controller.heavy == true:
					emit_signal("IsAttacking")
					state = Neutral_Recovery
					Controller.heavy = false
				
				
			if Controller.direction.y != 0:
				
				if Controller.light == true:
					emit_signal("IsAttacking")
					state = Down_Air
					Controller.light = false

					
				if Controller.heavy == true:
					emit_signal("IsAttacking")
					state = Dowm_Recovery
					Controller.heavy = false
				
			if Controller.throw == true:
				emit_signal("IsAttacking")
				state = Throw
				Controller.throw = false
			
			if Controller.dash == true:
				emit_signal("IsDashing")
				state = Block
				Controller.dash = false
				
			
			if Controller.jump == true and Character.Jump_Count > 0:
				emit_signal("IsJumping")
				state = Jump
				Controller.jump = false
				Character.Jump_Count -= 1
			
func _side_transition():
	pass
