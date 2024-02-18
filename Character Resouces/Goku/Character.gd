class_name Aniamtor extends AnimationPlayer

@export var Controller: Node
@export var Character: CharacterBody2D
@export var Scaler: Node
var Attack_Vector: Vector2
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

signal IsMoving
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

func _process(delta: float):
	match state:
		Idle:
			emit_signal("IsStopping")
			play("Idle")
			
			if !Character.is_on_floor():
				state = Fall
			if Controller.direction.x != 0:
				if Engine.get_process_frames() % 2 == 0:
					state = Running
			if Controller.direction.y == 1:
				if Input.is_action_just_pressed(Controller.Controls.light):
					emit_signal("IsAttacking")
					state = Down_Light
					
				if Input.is_action_just_pressed(Controller.Controls.heavy):
					emit_signal("IsAttacking")
					state = Down_Heavy
			elif Input.is_action_just_pressed(Controller.Controls.light):
					emit_signal("IsAttacking")
					state = Neutral_Light
				
			elif Input.is_action_just_pressed(Controller.Controls.heavy):
					emit_signal("IsAttacking")
					state = Neutral_Heavy
				
			if Input.is_action_just_pressed(Controller.Controls.dash):
					state = Dash
				
			if Input.is_action_just_pressed(Controller.Controls.jump):
					state = Jump
					IsJumping.emit()
			
		Running:
			IsMoving.emit()
			play("Run")
			
			if Controller.direction.x == 0:
				state = Idle
				
			if !Character.is_on_floor():
				state = Fall
				
			if Controller.direction.y == 1:
					if Input.is_action_just_pressed(Controller.Controls.light):
						emit_signal("IsAttacking")
						state = Down_Light
						
					if Input.is_action_just_pressed(Controller.Controls.heavy):
						emit_signal("IsAttacking")
						state = Down_Heavy
			elif Input.is_action_just_pressed(Controller.Controls.light):
					emit_signal("IsAttacking")
					state = Side_Light
				
			elif Input.is_action_just_pressed(Controller.Controls.heavy):
					emit_signal("IsAttacking")
					state = Side_Heavy
				
			if Input.is_action_just_pressed(Controller.Controls.dash):
					state = Dash
				
			if Input.is_action_just_pressed(Controller.Controls.jump):
					state = Jump
					IsJumping.emit()
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
				IsJumping.emit()
		Jump:
			play("Jump")
			
				
			if Controller.direction.y == 1:
					if Input.is_action_just_pressed(Controller.Controls.light):
						emit_signal("IsAttacking")
						state = Down_Air
						
					if Input.is_action_just_pressed(Controller.Controls.heavy):
						emit_signal("IsAttacking")
						state = Dowm_Recovery
						
			if Controller.direction.x != 0:
				IsMoving.emit()
				
				if Input.is_action_just_pressed(Controller.Controls.light):
						emit_signal("IsAttacking")
						state = Down_Air
			elif Input.is_action_just_pressed(Controller.Controls.light):
					emit_signal("IsAttacking")
					state = Side_Light
				
			elif Input.is_action_just_pressed(Controller.Controls.heavy):
					emit_signal("IsAttacking")
					state = Side_Heavy
				
			if Input.is_action_just_pressed(Controller.Controls.dash):
					state = Dash
				
			if Input.is_action_just_pressed(Controller.Controls.jump):
					state = Jump
					IsJumping.emit()
			if Character.is_on_floor():
				state = Idle
				emit_signal("OnGround")
				Controller.jump = false
		Fall:
			play("Fall")
			
			if Controller.direction.y != 0:
				
				if Controller.light == true:
					emit_signal("IsAttacking")
					state = Down_Air
					Controller.light = false

					
				if Controller.heavy == true:
					emit_signal("IsAttacking")
					state = Dowm_Recovery
					Controller.heavy = false
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
			if Character.is_on_floor():
				play("Ground Projectile")
				
			else:
				play("Air Projectile")
				
		Neutral_Light:
			play("Neutral Light")
			
		Neutral_Heavy:
			play("Neutral Heavy")
			
		Neutral_Air:
			Attack_Vector = NAir
			play("Neutral Air")
			
		Neutral_Recovery:
			Attack_Vector = NRecovery
			play("Neutral Recovery")
			
		Side_Light:
			Attack_Vector = Slight
			play("Side Light")
		
		Side_Heavy:
			Attack_Vector = SHeavy
			play("Side Heavy")
			
		Side_Air:
			Attack_Vector = SAir
			play("Side Air")
			
		Down_Light:
			Attack_Vector = Dlight
			play("Down Light")
			
		Down_Heavy:
			Attack_Vector = DHeavy
			play("Down Heavy")
		
		Down_Air:
			Attack_Vector = DAir
			play("Down Air")
			
		Dowm_Recovery:
			Attack_Vector = DRecovery
			play("Down Recovery")
			

#func _side_transition():
	#if side_transition == true:
		#play("Side Finish")


func _attack_movement():
	print(Character.velocity)
	Character.velocity.x = Scaler.direction * Attack_Vector.x
	Character.velocity.y = Attack_Vector.y 


func idle_reset():
	Attack_Vector = Vector2.ZERO
	if Character.is_on_floor():
		state = Idle
		IsResetting.emit()
		
	if !Character.is_on_floor():
		state = Fall
		IsResetting.emit()
