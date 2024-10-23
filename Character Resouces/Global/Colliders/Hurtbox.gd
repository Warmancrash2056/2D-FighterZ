extends Area2D
signal CalculateConstantForce(Constant: Vector2)
signal CalculateVariableForce(Variable: Vector2)
signal CalculateStunFrames(Recovery: int)
@onready var Stun_Timer: Timer = $'Stun Time'
@export var Character:CharacterBody2D
@export var Player_Stats: Node
@export var Sprite: Sprite2D
@export var Animator: AnimationPlayer
@export var Colider: CollisionShape2D

var knockback_multiplier: float
var knockback_vector = Vector2.ZERO
var x_Knockback_result = 0
var y_knockback_result = 0
signal IsHurt(Damage: int)
var stun_time: float
var damage_taken: int
var constant_force = Vector2.ZERO
var variable_force = Vector2.ZERO
var is_hurt = false

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

func _physics_process(delta: float) -> void:
	if Animator.state == Hurt:
		is_hurt = true
		print(Character.velocity)
		if knockback_vector == Vector2.ZERO:
			print("Knockback Not Applicable")
			Character.velocity.x = move_toward(Character.velocity.x, x_Knockback_result, 500)
			Character.velocity.y = move_toward(Character.velocity.y, y_knockback_result, 500)

		else:
			print("Knockback Applicable")
			Character.velocity.x = move_toward(Character.velocity.x, knockback_vector.x, 500)
			Character.velocity.y = move_toward(Character.velocity.y, knockback_vector.y, 500)
	else:
		is_hurt = false

func _on_area_entered(area: Area2D) -> void:
	constant_force = area.Constant_Force
	variable_force = area.Variable_Force
	Animator.state = Hurt
	if area.is_in_group("Air To Ground"):
		if Character.is_on_floor():
			constant_force.y *= -1
			variable_force.y *= -1
	# Variable force that is affected by the player defense.
	if area.is_in_group("Variable Force"):
		direction = area.direction
		CalculateVariableForce.emit(variable_force)
		x_Knockback_result = variable_force.x
		y_knockback_result = variable_force.y
		IsHurt.emit(area.Damage)
		CalculateStunFrames.emit(area.Recovery_Frames)
		goku_neautral_havy = false

	# Constant force that is fixed velocity not affected by player defense
	elif area.is_in_group("Constant Force"):
		direction = area.direction
		CalculateConstantForce.emit(constant_force)
		x_Knockback_result = constant_force.x
		y_knockback_result = constant_force.y
		IsHurt.emit(area.Damage)
		CalculateStunFrames.emit(area.Recovery_Frames)
		goku_neautral_havy = false

	# Transition checks and relays to animator that attack connected.
	elif area.is_in_group("Transition"):
		IsHurt.emit(area.Damage)

	# Only applies damage and stun to player.
	elif area.is_in_group("Damager"):
		IsHurt.emit(area.Damage)
		CalculateStunFrames.emit(area.Recovery_Frames)

	# Grabs the player and follow the hitbox it is connected to
	elif area.is_in_group("Goku Positioner"):
		IsHurt.emit(area.Damage)
		CalculateStunFrames.emit(area.Recovery_Frames)
		goku_neautral_havy = true


func _on_is_hurt(Damage: int) -> void:


	Player_Stats.Health -= Damage
	if Player_Stats.Health < 1000:
		knockback_multiplier = 1.0

	if Player_Stats.Health < 900:
		knockback_multiplier = 2.0

	if Player_Stats.Health < 800:
		knockback_multiplier = 3.0

	if Player_Stats.Health < 700:
		knockback_multiplier = 4.0

	if Player_Stats.Health < 600:
		knockback_multiplier = 5.0

	if Player_Stats.Health < 5000:
		knockback_multiplier = 6.0

	if Player_Stats.Health < 400:
		knockback_multiplier = 7.0

	if Player_Stats.Health < 300:
		knockback_multiplier = 8.0

	if Player_Stats.Health < 200:
		knockback_multiplier = 9.0

	if Player_Stats.Health < 100:
		knockback_multiplier = 10.0

	if Player_Stats.Health < 0:
		knockback_multiplier = 11.0



func _on_stun_time_timeout() -> void:
	knockback_vector = Vector2.ZERO
	x_Knockback_result = 0
	y_knockback_result = 0




func _on_controller_facing_left() -> void:
	scale.x = -1


func _on_controller_facing_right() -> void:
	scale.x = 1


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Knockout Area"):
		Animator.state = Respawn
		Player_Stats.Health = 1000

	if body.is_in_group("Bouncable Floor"):
		Character.velocity.y *= -1
		print("bounced on floor")


func _on_calculate_constant_force(Constant: Vector2) -> void:
	if direction == true:
		Constant.x *= -1

	else:
		Constant.x *= 1

	knockback_vector = Constant
	x_Knockback_result = knockback_vector.x
	y_knockback_result = knockback_vector.y


func _on_calculate_variable_force(Variable: Vector2) -> void:
	if direction == true:
		Variable.x *= -1

	else:
		Variable.x *= 1
	var defense_rating: float = Player_Stats.Defense_Rating
	var knockback_x: float = Variable.x / defense_rating
	var knockback_y: float = Variable.y / defense_rating
	knockback_vector = Vector2(knockback_x * knockback_multiplier,knockback_y * knockback_multiplier)
	x_Knockback_result = knockback_vector.x
	y_knockback_result = knockback_vector.y




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
