extends AnimationPlayer

@export var Controller: Node
@export var Character: CharacterBody2D
@export var Scaler: Node
@export var Sprite: Sprite2D

# Get directions of player
var movement_dir: Vector2
var direction: int

var Attack_Vector: Vector2
var Attack_Friction = 0.1
var start_movement = false
var start_friction = false
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
var buffer_time = 0.1
var can_direct = true
var can_jump = true
var can_dash = true
var can_attack = true

signal IsMoving(Vector: Vector2)
signal IsResetting
signal IsStopping
signal IsJumping
signal IsAttacking
signal FacingLeft
signal FacingRight
signal OnGround
signal IsDashing
signal AttackMoving(Vector)
signal AttackFriction(Friction)
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


func _physics_process(delta):
	match state:
		Idle:

			if Controller.movement_dir.x != 0:
				state = Running

			if !Character.is_on_floor():
				state = Jump
			play("Idle")
			IsStopping.emit()
		Turning:
			pass

		Running:
			IsMoving.emit(Controller.direction)
			play("Run")

			if Controller.movement_dir.x == 0:
				state = Idle

		Dash:
			play("Dash")
		Jump:
			play("Jump")

			if Character.is_on_floor():
				state = Idle
				emit_signal("OnGround")

		Fall:
			play("Fall")

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
				Attack_Vector = Throw_Ground

			else:
				play("Air Projectile")
				Attack_Vector = Throw_Air

		Neutral_Light:
			Attack_Vector = Nlight
			play("Neutral Light")

		Neutral_Heavy:
			Attack_Vector = NHeavy
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
			AttackFriction.emit(0.9)

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

func _attack_movment_controller():
	if start_movement == true:
		_attack_movement()

	if start_friction == true:
		_attack_friction()
#func _side_transition():
	#if side_transition == true:
		#play("Side Finish")


func _attack_movement():
	Attack_Vector.x *= Scaler.direction
	AttackMoving.emit(Attack_Vector)

func _attack_friction():
	AttackFriction.emit(Attack_Friction)


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

func _start_attack_friction():
	start_friction = true

func _stop_attack_friction():
	start_friction = false
func _throw_attack():
	IsThrowing.emit()
func _on_is_attacking():
	Controller.can_jump = false
	Controller.can_direct = false
	Controller.can_attack = false

func attack_active():
	IsAttacking.emit()

func _attack_deactive():
	IsResetting.emit()

func _on_is_resetting():
	Controller.can_jump = true
	Controller.can_direct = true
	Controller.can_attack = true



func _on_block_timer_timeout() -> void:

