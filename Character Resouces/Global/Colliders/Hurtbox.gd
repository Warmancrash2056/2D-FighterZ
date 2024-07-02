extends Area2D

@onready var Stun_Timer: Timer = $'Stun Time'
@export var Character:CharacterBody2D
@export var Player_Stats: Node
@export var Sprite: Sprite2D
@export var Animator: AnimationPlayer
var knockback_multiplier: float
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
func _physics_process(delta: float) -> void:
	if Animator.state == Hurt:
		apply_constant_force(constant_force)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Force"):
		print("detect")
		damage_taken = area.Damage
		IsHurt.emit(damage_taken)
		_calculate_stun(area.Stun_Time)
		constant_force = area.Constant_Force
		direction = area.direction
		goku_neautral_havy = false



	if area.is_in_group("Goku | Neautral Heavy Positioner"):
		goku_neautral_havy = true
		damage_taken = area.Damage
		IsHurt.emit(damage_taken)
		_calculate_stun(area.Stun_Time)
		direction = area.direction

func _calculate_stun(Recovery: float):
	print("Game data")
	var stamina_rating: float = Player_Stats.Stamina_Rating
	var stuned_time: float = Recovery * stamina_rating

	Stun_Timer.set_wait_time(stuned_time)
	Stun_Timer.start()
	print("Stun time " ,stuned_time)


func apply_constant_force(Constant: Vector2):
	if direction == true:
		Constant.x *= -1

	else:
		Constant.x *= 1
	var defense_rating: float = Player_Stats.Defense_Rating
	var knockback_x: float = Constant.x * defense_rating
	var knockback_y: float = Constant.y * defense_rating
	var knockback_vector: Vector2 = Vector2(knockback_x,knockback_y)


	Character.velocity = knockback_vector * knockback_multiplier

func _on_is_hurt(Damage: int) -> void:
	Animator.state = Hurt
	print(Player_Stats.Health)
	Player_Stats.Health -= Damage
	if Player_Stats.Health < 1000:
		knockback_multiplier = 1.0

	if Player_Stats.Health < 900:
		knockback_multiplier = 1.1

	if Player_Stats.Health < 800:
		knockback_multiplier = 1.2

	if Player_Stats.Health < 700:
		knockback_multiplier = 1.3

	if Player_Stats.Health < 600:
		knockback_multiplier = 1.4

	if Player_Stats.Health < 500:
		knockback_multiplier = 1.5

	if Player_Stats.Health < 400:
		knockback_multiplier = 1.6

	if Player_Stats.Health < 300:
		knockback_multiplier = 1.7

	if Player_Stats.Health < 200:
		knockback_multiplier = 1.8

	if Player_Stats.Health < 100:
		knockback_multiplier = 1.9

	if Player_Stats.Health < 0:
		knockback_multiplier = 2.0



func _on_stun_time_timeout() -> void:
	goku_neautral_havy = false
	#Character.velocity = Vector2.ZERO


func _on_area_exited(area: Area2D) -> void:
	pass # Replace with function body.


func _on_area_2d_attack_connected() -> void:
	pass # Replace with function body.


func _on_controller_facing_left() -> void:
	scale.x = -1


func _on_controller_facing_right() -> void:
	scale.x = 1
