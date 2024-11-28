extends Area2D
signal CalculateConstantForce(Constant: Vector2, Direction: bool)
signal CalculateVariableForce(Variable: Vector2, Direction:bool)
signal CalculateStunFrames(Recovery: int)
@onready var Stun_Timer: Timer = $'Stun Time'
@export var Character: RigidBody2D
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
var is_hurt = false


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
	pass
func _on_area_entered(area: Area2D) -> void:
	Animator.state = Hurt
	var damage_done:int = area.Damage
	var direction:bool = area.direction
	var stun_frames:int = area.Recovery_Frames
	IsHurt.emit(damage_done)
	CalculateStunFrames.emit(stun_frames)
	if area.is_in_group("Variable Force"):
		var variable_force = area.Variable_Force
		CalculateVariableForce.emit(variable_force,direction)
		print(variable_force)

	# Constant force that is fixed velocity not affected by player defense
	elif area.is_in_group("Constant Force"):
		var constant_force = area.Constant_Force
		CalculateConstantForce.emit(constant_force,direction)
		print(constant_force)

	# Transition checks and relays to animator that attack connected.
	elif area.is_in_group("Transition"):
		IsHurt.emit(damage_done)

	# Only applies damage and stun to player.
	elif area.is_in_group("Damager"):
		IsHurt.emit(damage_done)
		CalculateStunFrames.emit(stun_frames)

	elif area.is_in_group("Goku Grab"):
		goku_neautral_havy = true
		Animator.state = Hurt





func _on_is_hurt(Damage: int) -> void:
	Player_Stats.Health -= Damage
	print(Player_Stats.Health)
	if Player_Stats.Health < 1000:
		knockback_multiplier = 1.0
		Character.physics_material_override.bounce = 0.1
		Character.physics_material_override.friction = 0.92

	if Player_Stats.Health < 900:
		knockback_multiplier = 2.0
		Character.physics_material_override.bounce = 0.2
		Character.physics_material_override.friction = 0.9

	if Player_Stats.Health < 800:
		knockback_multiplier = 3.0
		Character.physics_material_override.bounce = 0.3
		Character.physics_material_override.friction = 0.8

	if Player_Stats.Health < 700:
		knockback_multiplier = 4.0
		Character.physics_material_override.bounce = 0.4
		Character.physics_material_override.friction = 0.7

	if Player_Stats.Health < 600:
		knockback_multiplier = 5.0
		Character.physics_material_override.bounce = 0.5
		Character.physics_material_override.friction = 0.6

	if Player_Stats.Health < 500:
		knockback_multiplier = 6.0
		Character.physics_material_override.bounce = 0.6
		Character.physics_material_override.friction = 0.5

	if Player_Stats.Health < 400:
		knockback_multiplier = 7.0
		Character.physics_material_override.bounce = 0.7
		Character.physics_material_override.friction = 0.4

	if Player_Stats.Health < 300:
		knockback_multiplier = 8.0
		Character.physics_material_override.bounce = 0.8
		Character.physics_material_override.friction = 0.3

	if Player_Stats.Health < 200:
		knockback_multiplier = 9.0
		Character.physics_material_override.bounce = 0.9
		Character.physics_material_override.friction = 0.2

	if Player_Stats.Health < 100:
		knockback_multiplier = 10.0
		Character.physics_material_override.bounce = 1.0
		Character.physics_material_override.friction = 0.1

	if Player_Stats.Health < 0:
		knockback_multiplier = 11.0
		Character.physics_material_override.bounce = 1.0
		Character.physics_material_override.friction = 0.1



func _on_stun_time_timeout() -> void:
	knockback_vector = Vector2.ZERO
	Character.physics_material_override.bounce = 0
	Character.physics_material_override.friction = 1.0
	Character.linear_velocity.x = move_toward(Character.linear_velocity.x, 0, 50)
	Character.linear_velocity.y = move_toward(Character.linear_velocity.y, 0, 20)




func _on_controller_facing_left() -> void:
	scale.x = -1


func _on_controller_facing_right() -> void:
	scale.x = 1


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Knockout Area"):
		Animator.state = Respawn
		Player_Stats.Health = 1000

	if body.is_in_group("Bouncable Floor"):
		pass






func _on_calculate_stun_frames(Recovery: int) -> void:
	var stamina_rating: float = Player_Stats.Stamina_Rating
	var stun_frames: float = Recovery / stamina_rating
	var stuned_time: float = stun_frames / 60

	Stun_Timer.set_wait_time(stuned_time)
	Stun_Timer.start()
	print(stuned_time)


func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("Goku Grab"):
		goku_neautral_havy = false
		CalculateStunFrames.emit(10)


func _on_calculate_constant_force(Constant: Vector2, Direction: bool) -> void:
	if Direction == true:
		Constant.x = -Constant.x

	else:
		Constant.x

	Character.linear_velocity = Constant


func _on_calculate_variable_force(Variable: Vector2, Direction: bool) -> void:
	if Direction == true:
		Variable.x = -Variable.x

	else:
		Variable.x
	var defense_rating: float = Player_Stats.Defense_Rating
	var knockback_x: float = Variable.x / defense_rating
	var knockback_y: float = Variable.y / defense_rating
	var _vector = Vector2(knockback_x * knockback_multiplier,knockback_y * knockback_multiplier)
	Character.linear_velocity = _vector
