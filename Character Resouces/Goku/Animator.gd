extends AnimationPlayer

@export var Controller: Node
@export var Character: CharacterBody2D
@export var Scaler: Node
@export var Sprite: Sprite2D

# Get directions of player
var movement_dir: Vector2
var direction: int

var Attack_Vector: Vector2
var Attack_Friction = 0.8
var enable_y_movement = false
var enable_x_movement = false
var start_friction = false

const Block = Vector2.ZERO
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

signal IsResetting
signal IsJumping
signal IsAttacking
signal FacingLeft
signal FacingRight
signal OnGround
signal IsDashing
signal AttackMovingX(Vector)
signal AttackMovingY(Vector)
signal AttackFriction(Friction)
signal IsThrowing

enum {
	Idle,
	Turning,
	Running,
	Dash,
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
	Respawn
}

var state = Respawn


func _physics_process(delta):
	_attack_movment_controller()
	match state:
		Idle:
			if Character.velocity.x != 0:
				play("Run")

			else:
				play("Idle")



			if !Character.is_on_floor():
				state = Air
		Turning:
			pass

		Dash:
			play("Dash")
		Air:
			if Character.velocity.y > 0:
				play("Fall")

			else:
				play("Jump")

			if Character.is_on_floor():
				state = Idle
				OnGround.emit()

		Respawn:
			play("Respawn")

		Ground_Throw:
			play("Ground Projectile")
			Attack_Vector = Throw_Ground

		Air_Throw:
			play("Air Projectile")
			Attack_Vector = Throw_Air

		Ground_Block:
			Attack_Vector = Block
			play("Ground Block")

		Air_Block:
			Attack_Vector = Block
			play("Air Block")
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
	if enable_x_movement == true:
		AttackMovingX.emit(Attack_Vector.x)
	if enable_y_movement == true:
		AttackMovingY.emit(Attack_Vector.y)
	if start_friction == true:
		AttackFriction.emit(Attack_Friction)

#func _side_transition():
	#if side_transition == true:
		#play("Side Finish")

func idle_reset():
	Attack_Vector = Vector2.ZERO
	if Character.is_on_floor():
		OnGround.emit()
	if Character.is_on_floor():
		state = Idle
		IsResetting.emit()
		play("Idle")
	if !Character.is_on_floor():
		state = Air
		IsResetting.emit()
		play("Fall")

func enable_vertical_attack_movement():
	enable_y_movement = true

func disable_vertical_attack_movement():
	enable_y_movement = false
func start_attack_movment():
	enable_x_movement = true

func stop_attack_movment():
	enable_x_movement = false

func _start_attack_friction():
	start_friction = true

func _stop_attack_friction():
	start_friction = false
func _throw_attack():
	IsThrowing.emit()

# Disable and enable player movement player movement at keyframe
func _stop_player_movement():
	Character.velocity.x = move_toward(Character.velocity.x , 0 , 100)
	Controller.can_move = false

func _start_player_movement():
	Controller.can_move = true

# At first frame disable or enable player actions.
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

