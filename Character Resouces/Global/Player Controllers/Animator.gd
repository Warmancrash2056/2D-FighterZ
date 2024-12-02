class_name Animator extends AnimationPlayer

signal GroundKnockbackCloud
signal AirKnockbackCloud
@export var Player_Identifier: Node2D
@export var Controller: Node
@export var Recovery_Timer: Timer
@export var Movement_Timer: Timer
@export var Refresh_Block: Timer
@export var Character: RigidBody2D
@export var Scaler: Node
@export var Sprite: Sprite2D
@export var Wall_Detector: RayCast2D
@onready var Ray = $'../Node'
var movement_dir: Vector2
var direction: int
var transition_to_finish = false
var Attack_Vector: Vector2
var Attack_Friction = 0.1
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
signal OnWall
signal AttackMovingX(Vector)
signal AttackMovingY(Vector)
signal AttackFriction(Friction)

enum {SurfaceGround, SurfaceWall, SurfaceAir}

enum {
	Idle,
	Turning_Left,
	Turning_Right,
	Running,
	Dash,
	Wall,
	Air,
	Ground_Block_Start_Tap,
	Ground_Block_Held,
	Ground_Block_To_Idle,
	Block_Slide,
	Air_Block_Start_Tap,
	Air_Block_Held,
	Neutral_Light,
	Neutral_Heavy,
	Neutral_Air,
	Neutral_Recovery,
	Side_Light_Start,
	Side_Light_Finish,
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


func _physics_process(delta):
	_attack_movment_controller()
	match state:
		Idle:
			if Ray.onground == false:
				state = Air
			play("Idle")

			if Character.movement_dir.x != 0 and Ray.onground == true:
				state = Running

		Running:
			if Ray.onground == false:
				state = Air
			play("Run")

			if Character.movement_dir.x == 0 and Ray.onground == true:
				state = Idle

		Turning_Left:
			play("Turning Left")

		Turning_Right:
			play("Turning Right")

		Dash:
			play("Run")
			if Ray.onground == false:
				state = Air
			if Character.movement_dir.x == 0:
				state = Idle
				Character.can_attack = true
				Character.can_jump = true
				Character.can_direct = true

			if Sprite.flip_h == false and Character.movement_dir.x == -1:
				state = Wall
				Character.can_attack = true
				Character.can_jump = true
				Character.can_direct = true

			if Sprite.flip_h == true and Character.movement_dir.x == 1:
				state = Wall
				Character.can_attack = true
				Character.can_jump = true
				Character.can_direct = true

		Air:
			if Character.linear_velocity.y > 0:
				play("Fall")

			else:
				play("Jump")

			if Ray.onground == true:
				state = Idle
				OnGround.emit()

			if Ray.completely_on_the_wall == true:
				state = Wall
				OnWall.emit()

		Wall:
			play("Wall")

			if Ray.onwall == false:
				state = Air
		Hurt:
			if Ray.onground == true:
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

		Ground_Block_Start_Tap:
			Attack_Vector = Block
			play("Ground Block - Start -")

		Ground_Block_Held:
			play("Ground Block - Finish -")

		Air_Block_Start_Tap:
			Attack_Vector = Block
			play("Air Block")

		Neutral_Light:
			Attack_Vector = Nlight
			play("Neutral Light - Start - Tap -")

		Neutral_Heavy:
			Attack_Vector = NHeavy
			play("Neautral Heavy - Start -")

		Neutral_Air:
			Attack_Vector = NAir
			play("Neautral Air - Start -")

		Neutral_Recovery:
			Attack_Vector = NRecovery
			play("Neutral Recovery - Start -")

		Side_Light_Start:
			Attack_Vector = Slight
			play("Side Light -Start -")

		Side_Light_Finish:
			play("Side Light - Finish -")

		Side_Heavy:

			Attack_Vector = SHeavy
			play("Side Heavy - Start -")

		Side_Air:
			Attack_Vector = SAir
			play("Side Air - Start -")

		Down_Light:
			Attack_Vector = Dlight
			play("Down Light - Start -")

		Down_Heavy:
			Attack_Vector = DHeavy
			play("Down Heavy - Start -")

		Down_Air:
			Attack_Vector = DAir
			play("Down Air - Start -")

		Dowm_Recovery:
			Attack_Vector = DRecovery
			play("Down Recovery - Start -")


func _attack_movment_controller():
	if enable_x_movement == true:
		AttackMovingX.emit(Attack_Vector.x)
	if enable_y_movement == true:
		AttackMovingY.emit(Attack_Vector.y)
	if start_friction == true:
		AttackFriction.emit(Attack_Friction)

func _side_light_transition():
	print(transition_to_finish)
	if transition_to_finish == true:
		state = Side_Light_Finish
		transition_to_finish = false


func idle_reset():
	Attack_Vector = Vector2.ZERO
	Character.movement_dir.x = 0
	OnGround.emit()

	if Ray.onwall == true:
		IsAttacking.emit()
		Character.linear_velocity.y = 0
		state = Wall

	else:
		if Ray.onground == true:
			state = Idle
			play("Idle")
		else:
			state = Air
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

# Disable and enable player movement player movement at keyframe
func _stop_player_movement():
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
	Character.linear_velocity.x = lerp(Character.linear_velocity.x , 0.0, Friction)


func _on_attack_moving_x(Vector: Variant) -> void:
	if Sprite.flip_h == false:
		Character.linear_velocity.x = Vector
	else:
		Character.linear_velocity.x = -Vector

func _on_attack_moving_y(Vector: Variant) -> void:
	Character.linear_velocity.y = Vector

# From timer node reenable attack and dodge
func _on_recovery_timer_timeout() -> void:
	IsResetting.emit()
	Character.can_dash = true


func _on_stun_time_timeout() -> void:
	_start_player_movement()
	IsResetting.emit()
	idle_reset()

	return



func _on_refresh_block_timeout() -> void:
	pass # Replace with function body.


func _on_movement_cooldown_timeout() -> void:
	Character.can_move = true
	Character.can_direct = true
	Character.can_jump = true




func holding_block():
	if Input.is_action_pressed(Player_Identifier.Controls.block):
		print("Block Continue")

	else:
		idle_reset()
		Recovery_Timer.start()
		Movement_Timer.start()
		Refresh_Block.start()


func _transition_to_Finish_block():
	state = Ground_Block_Held


func _on_transitional_check_area_entered(area: Area2D) -> void:
	transition_to_finish = true

