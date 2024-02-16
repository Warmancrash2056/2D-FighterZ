class_name Aniamtor extends AnimationPlayer

@export var Controller: Node
@export var Character: CharacterBody2D
@export var Attack_Vector: Vector2
@export var Attack_Friction: float = 0.0
signal IsMoving
signal OnGround
signal IsDashing
signal IsStopping
signal IsAttacking
signal IsResetting
signal IsJumping
signal IsThrowing
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


var state = Respawn
func _ready():
	pass # Replace with function body.

func _process(delta):
	pass
	
func _physics_process(delta: float):
	match state:
		Idle:
			emit_signal("IsStopping")
			play("Idle")
			
			if !Character.is_on_floor():
				state = Fall
			if Controller.direction.x != 0:
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
			elif Controller.light == true:
				emit_signal("IsAttacking")
				state = Neutral_Light
				Controller.light = false
				
			elif Controller.heavy == true:
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
				
			if Controller.jump == true:
				state = Jump
			
		Running:
			IsMoving.emit()
			play("Run")
			
			if Controller.direction.x == 0:
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
				
			
			if Controller.jump == true:
				state = Jump
				
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
				
			if Controller.jump == true:
				state = Jump
		Jump:
			play("Jump")
			IsJumping.emit()
			
			if Character.velocity.y > 0:
				state = Fall
				
				
			if Controller.direction.x != 0:
				emit_signal("IsMoving")
				
				if Controller.light == true:
					emit_signal("IsAttacking")
					state = Side_Air
					Controller.light = false
					
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
				
			
			if Controller.jump == true:
				state = Jump
			
			if Character.Jump_Count <= 0:
				if Character.is_on_floor():
					state = Idle
					emit_signal("OnGround")
					Controller.jump = false
		Fall:
			play("Fall")
			
			if Character.is_on_floor():
				state = Idle
				emit_signal("OnGround")
				Controller.jump = false
			if Controller.jump == true:
				state = Jump
				
			if Controller.direction.x != 0:
				emit_signal("IsMoving") 
					
			else:
				emit_signal("IsStopping")

	
				
			if Controller.throw == true:
				state = Throw
				Controller.throw = false
			
			if Controller.dash == true:
				emit_signal("IsDashing")
				state = Block
				Controller.dash = false
				
		Block:
			if Character.is_on_floor():
				play("Ground Block")
				
			else:
				play("Air Block")
				
				
		Respawn:
			play("Respawn")
			
		Throw:
			if Character.is_on_floor():
				play("Ground Projectile")
				
			else:
				play("Air Projectile")
				
		Neutral_Light:
			IsAttacking.emit()
			play("Neutral Light")
			
		Neutral_Heavy:
			IsAttacking.emit()
			play("Neutral Heavy")
			
		Neutral_Air:
			IsAttacking.emit()
			play("Neutral Air")
			
		Neutral_Recovery:
			IsAttacking.emit()
			play("Neutral Recovery")
			
		Side_Light:
			IsAttacking.emit()
			play("Side Light")
		
		Side_Heavy:
			play("Side Heavy")
			
		Side_Air:
			play("Side Air")
			
		Down_Light:
			play("Down Light")
			
		Down_Heavy:
			play("Down Heavy")
			
		Dowm_Recovery:
			play("Down Recovery")
			

#func _side_transition():
	#if side_transition == true:
		#play("Side Finish")

func _reset_state():
	Attack_Friction = 0.0
	Attack_Vector = Vector2.ZERO
	if Character.is_on_floor():
		state = Idle
		IsResetting.emit()
		
	if !Character.is_on_floor():
		state = Fall
		IsResetting.emit()


