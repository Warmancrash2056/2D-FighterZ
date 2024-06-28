extends AnimationPlayer


@export var Controller: Node
@export var Character: CharacterBody2D
@export var Scaler: Node
@export var Sprite: Sprite2D
@export var Wall_Detector: RayCast2D

@onready var Player_Identifier: Node2D = $'../..'
# Get directions of player
var movement_dir: Vector2
var direction: int

var Attack_Vector: Vector2
var Attack_Friction = 0.8
var enable_y_movement = false
var enable_x_movement = false
var start_friction = false

var side_transition: bool = false
var neutral_transition: bool = false
var down_tramnsition
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
@export var starting_frames: int # the amount of frames before an attack.
var active_frames: int  # the amount of frames collision are active
var end_frames: int # the amount of fames after attack
var input_buffer = []
var max_buffer_limit = 3
var buffer_time = 0.1
var can_direct = true
var can_jump = true
var can_dash = true
var can_attack = true

signal IsResetting
signal IsAttacking
signal EnableMoveMent
signal DisableMovement
signal OnGround
signal AttackMovingX(Vector)
signal AttackMovingY(Vector)
signal AttackFriction(Friction)

enum {
	Idle,
	Turning,
	Running,
	Dash,
	Left_Wall,
	Right_Wall,
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

var state = Idle


func _physics_process(delta):
	_attack_movment_controller()
	match state:
		Idle:
			if !Character.is_on_floor():
				state = Air
			play("Idle")

			if Character.movement_dir.x != 0 and Character.is_on_floor():
				state = Running


		Running:
			if !Character.is_on_floor():
				state = Air
			play("Run")

			if Character.movement_dir.x == 0:
				state = Idle
		Turning:
			play("Turn")

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

			if Character.is_on_wall() and Wall_Detector.is_colliding():
				IsAttacking.emit()
				_stop_player_movement()
				Character.velocity.y = 0
				if Wall_Detector.target_position.x == 9:
					state = Left_Wall
					Sprite.flip_h = true

				else:
					Sprite.flip_h = false
					state = Right_Wall

				if !Character.is_on_wall() and !Wall_Detector.is_colliding():
					IsResetting.emit()
					_start_player_movement()


		Left_Wall:
			play("Wall")
			Sprite.flip_h = true
			if Input.is_action_just_pressed(Player_Identifier.Controls.left):
				Character.velocity.x = -300
				Character.velocity.y = -200
				state = Air
				IsResetting.emit()
				_start_player_movement()

			if !Wall_Detector.is_colliding():
				state = Air
				IsResetting.emit()
				_start_player_movement()


		Right_Wall:
			play("Wall")
			Sprite.flip_h = false
			if Input.is_action_just_pressed(Player_Identifier.Controls.right):
				Character.velocity.x = 300
				Character.velocity.y = -200
				state = Air
				IsResetting.emit()
				_start_player_movement()

			if !Wall_Detector.is_colliding():
				state = Air
				IsResetting.emit()
				_start_player_movement()

		Hurt:
			if Character.is_on_floor():
				play("Ground Hurt")

			else:
				play("Air Hurt")
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
			play("Nuetral Light")

		Neutral_Heavy:
			Attack_Vector = NHeavy
			play("Nuetral Heavy")

		Neutral_Air:
			Attack_Vector = NAir
			play("Neautral Air")

		Neutral_Recovery:
			Attack_Vector = NRecovery
			play("Neutral Recovery")

		Side_Light:
			Attack_Vector = Slight
			play("Side Light Start")

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

func _side_transition():
	if side_transition == true:
		play("Side Finish")

func idle_reset():
	Attack_Vector = Vector2.ZERO
	Character.movement_dir.x = 0
	OnGround.emit()
	if Character.is_on_floor():
		state = Idle
		play("Idle")
	if !Character.is_on_floor():
		state = Air
		play("Fall")

	if Character.is_on_wall() and Wall_Detector.is_colliding():
		IsAttacking.emit()
		_stop_player_movement()
		Character.velocity.y = 0
		if Wall_Detector.target_position.x == 9:
			state = Left_Wall

		else:
			state = Right_Wall

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

# Disable and enable player movement player movement at keyframe
func _stop_player_movement():
	Character.velocity.x = move_toward(Character.velocity.x , 0 , 100)
	Character.can_move = false

func _start_player_movement():
	Character.can_move = true
	Character.can_direct = true
	Character.can_jump = true

# At first frame disable or enable player actions.
func _on_is_attacking():
	Character.can_jump = false
	Character.can_direct = false
	Character.can_attack = false

func _attack_deactive():
	IsResetting.emit()

func _on_is_resetting(): # Reset the attack trigger to on.
	Character.can_attack = true


func _on_attack_friction(Friction: Variant) -> void:
	pass # Replace with function body.


func _on_attack_moving_x(Vector: Variant) -> void:
	if Sprite.flip_h == false:
		Character.velocity.x = Vector
	else:
		Character.velocity.x = -Vector

func _on_attack_moving_y(Vector: Variant) -> void:
	Character.velocity.y = Vector

# From timer node reenable attack and dodge
func _on_recovery_timer_timeout() -> void:
	IsResetting.emit()


func _on_stun_time_timeout() -> void:
	idle_reset()
	_start_player_movement()
	IsResetting.emit()


func _on_refresh_block_timeout() -> void:
	pass # Replace with function body.


func _on_movement_cooldown_timeout() -> void:
	Character.can_move = true
	Character.can_direct = true
	Character.can_jump = true

