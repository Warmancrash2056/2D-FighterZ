extends Area2D

@export var Character:CharacterBody2D
@export var Player_Stats: Node
@export var Sprite: Sprite2D
@export var Animator: AnimationPlayer

@onready var Stun_Timer: Timer = $'Stun Time'
var knockback_multiplier: float
signal IsHurt(Damage: int)
var is_hurt: bool = false
var stun_time: float
var constant_force: Vector2
var variable_force: Vector2
var applied_variable_force: Vector2
var facing_left: bool
enum {Idle, Air, Hurt}

func _process(delta: float) -> void:
	if is_hurt == true:
		_apply_constant_force(constant_force)

func _on_area_entered(area: Area2D) -> void:
	is_hurt = true
	var Damage: int = area.Damage
	IsHurt.emit(Damage)
	stun_time = area.Stun_Time
	constant_force = area.Constant_Force
	variable_force = area.Variable_Force
	facing_left = area.direction
	Player_Stats.Health -= Damage
	_calculate_stun()
func _apply_constant_force(Constant: Vector2):
	if facing_left == true:
		Constant.x *= -1

	else:
		Constant.x *= 1

	Character.velocity = Constant * knockback_multiplier


func _calculate_stun():
	var stamina_rating: float = Player_Stats.Stamina_Rating
	var Stun_Length: float = stun_time
	var recovering = Stun_Length * stamina_rating

	Stun_Timer.set_wait_time(recovering)
	Stun_Timer.start()
	print(recovering)

func _on_is_hurt(Damage: int) -> void:
	if Player_Stats.Health < 1000:
		knockback_multiplier = 0.50

	if Player_Stats.Health < 800:
		knockback_multiplier = 0.65

	if Player_Stats.Health < 600:
		knockback_multiplier = 0.75

	if Player_Stats.Health < 550:
		knockback_multiplier = 1.0

	if Player_Stats.Health < 390:
		knockback_multiplier = 1.25

	if Player_Stats.Health < 200:
		knockback_multiplier = 1.45

	if Player_Stats.Health < 0:
		knockback_multiplier = 2.0



func _on_stun_time_timeout() -> void:
	is_hurt = false
	Stun_Timer.set_wait_time(0.0)
