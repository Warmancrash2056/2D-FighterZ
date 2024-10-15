extends Area2D
signal CalculateConstantForce(Constant: Vector2)
signal CalculateVariableForce(Variable: Vector2)
signal CalculateStunFrames(Recovery: int)
@onready var Stun_Timer: Timer = $'Stun Time'
@export var Wall_detector: RayCast2D
@export var Character:CharacterBody2D
@export var Player_Stats: Node
@export var Sprite: Sprite2D
@export var Animator: AnimationPlayer
@export var Colider: CollisionShape2D

var knockback_multiplier: float
var knockback_vector: Vector2
signal IsHurt(Damage: int)
var stun_time: float
var damage_taken: int
var constant_force: Vector2
var variable_force: Vector2
var direction: bool

var goku_neautral_havy
var goku_neautral_heavy_positioner: bool = false

enum {
	Idle,
	Turning,
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

func _ready() -> void:
	pass
func _physics_process(delta: float) -> void:
	if Animator.state == Hurt:
		apply_force()

func _on_area_entered(area: Area2D) -> void:
	direction = area.direction
	# Variable force that is affected by the player defense.
	if area.is_in_group("Variable Force"):
		CalculateVariableForce.emit(area.Variable_Force)
		apply_force()
		IsHurt.emit(area.Damage)
		CalculateStunFrames.emit(area.Recovery_Frames)
		goku_neautral_havy = false


	# Constant force that is fixed velocity not affected by player defense
	if area.is_in_group("Constant Force"):
		CalculateConstantForce.emit(area.Constant_Force)
		apply_force()
		IsHurt.emit(area.Damage)
		CalculateStunFrames.emit(area.Recovery_Frames)
		goku_neautral_havy = false


	# Transition checks and relays to animator that attack connected.
	if area.is_in_group("Transition"):
		IsHurt.emit(area.Damage)

	# Only applies damage and stun to player.
	if area.is_in_group("Damager"):
		IsHurt.emit(area.Damage)
		CalculateStunFrames.emit(area.Recovery_Frames)

	# Grabs the player and follow the hitbox it is connected to
	if area.is_in_group("Goku Positioner"):
		IsHurt.emit(area.Damage)
		CalculateStunFrames.emit(area.Recovery_Frames)
		goku_neautral_havy = true

func apply_force() -> void:
	if knockback_vector != Vector2.ZERO:
		Character.velocity.x = move_toward(Character.velocity.x, knockback_vector.x, 100)
		Character.velocity.y = move_toward(Character.velocity.y, knockback_vector.y, 100)

		print("Knockback applied: ", knockback_vector)  # Debugging
	else:
		print("No knockback applied")

	if Character.is_on_wall():
			Character.velocity.x *= -1
			print("bounce")

func _on_is_hurt(Damage: int) -> void:
	Animator.state = Hurt

	Player_Stats.Health -= Damage
	if Player_Stats.Health < 100:
		knockback_multiplier = 1.0

	if Player_Stats.Health < 90:
		knockback_multiplier = 2.0

	if Player_Stats.Health < 80:
		knockback_multiplier = 3.0

	if Player_Stats.Health < 70:
		knockback_multiplier = 4.0

	if Player_Stats.Health < 60:
		knockback_multiplier = 5.0

	if Player_Stats.Health < 50:
		knockback_multiplier = 6.0

	if Player_Stats.Health < 40:
		knockback_multiplier = 7.0

	if Player_Stats.Health < 30:
		knockback_multiplier = 8.0

	if Player_Stats.Health < 20:
		knockback_multiplier = 9.0

	if Player_Stats.Health < 10:
		knockback_multiplier = 10.0

	if Player_Stats.Health < 0:
		knockback_multiplier = 11.0



func _on_stun_time_timeout() -> void:
	knockback_vector = Vector2.ZERO




func _on_controller_facing_left() -> void:
	scale.x = -1


func _on_controller_facing_right() -> void:
	scale.x = 1


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Knockout Area"):
		Animator.state = Respawn
		Player_Stats.Health = 1000


func _on_calculate_constant_force(Constant: Vector2) -> void:
	if direction == true:
		Constant.x *= -1

	else:
		Constant.x *= 1

	knockback_vector = Constant


func _on_calculate_variable_force(Variable: Vector2) -> void:
	if direction == true:
		Variable.x *= -1

	else:
		Variable.x *= 1
	var defense_rating: float = Player_Stats.Defense_Rating
	var knockback_x: float = Variable.x / defense_rating
	var knockback_y: float = Variable.y / defense_rating
	knockback_vector = Vector2(knockback_x * knockback_multiplier,knockback_y * knockback_multiplier)




func _on_calculate_stun_frames(Recovery: int) -> void:
	var stamina_rating: float = Player_Stats.Stamina_Rating
	var stun_frames: float = Recovery / stamina_rating
	var stuned_time: float = stun_frames / 60

	Stun_Timer.set_wait_time(stuned_time)
	Stun_Timer.start()
	print(stuned_time)


func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("Goku Positioner"):
		goku_neautral_havy = false
