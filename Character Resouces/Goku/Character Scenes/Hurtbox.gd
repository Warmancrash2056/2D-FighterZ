extends Area2D
@onready var Stun_Timer: Timer = $'Stun Time'
@export var Character:CharacterBody2D
@export var Player_Stats: Node
@export var Sprite: Sprite2D
@export var Animator: AnimationPlayer
var knockback_multiplier: float
signal IsHurt(Damage: int)
var stun_time: float
var constant_force: Vector2
var variable_force: Vector2
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


func _process(delta: float) -> void:
	if Animator.state == Hurt:
		_apply_constant_force(constant_force)


func _on_area_entered(area: Area2D) -> void:
	print("detect")
	IsHurt.emit(area.Damage)
	calculate_stun(area.Stun_Time)
	constant_force = area.Constant_Force

func _apply_constant_force(Constant: Vector2):
	if Sprite.flip_h == true:
		Constant.x

	else:
		-Constant.x

	Character.velocity = Constant

func calculate_stun(Recovery: float):
	var stamina_rating: float = Player_Stats.Stamina_Rating
	var stuned_time: float = Recovery * stamina_rating

	Stun_Timer.set_wait_time(stuned_time)
	Stun_Timer.start()


func _on_is_hurt(Damage: int) -> void:
	print(Player_Stats.Health)
	Player_Stats.Health -= Damage
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
	pass # Replace with function body.
