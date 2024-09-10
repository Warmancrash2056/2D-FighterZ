extends Area2D

@onready var Stun_Timer: Timer = $'Stun Time'
@export var Character:CharacterBody2D
@export var Player_Stats: Node
@export var Sprite: Sprite2D
@export var Animator: AnimationPlayer
@export var Colider: CollisionShape2D

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
		apply_constant_force(constant_force)
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Force"):
		constant_force = area.Constant_Force
		damage_taken = area.Damage
		IsHurt.emit(damage_taken)
		_calculate_stun(area.Recovery_Frames)
		direction = area.direction
		goku_neautral_havy = false

	elif area.is_in_group("Damager"):
		IsHurt.emit(damage_taken)
		_calculate_stun(area.Recovery_Frames)

	elif area.is_in_group("Knockout Area"):
		pass

	elif area.is_in_group("Goku | Positioner"):
		goku_neautral_havy = true
		damage_taken = area.Damage
		IsHurt.emit(damage_taken)
		_calculate_stun(area.Recovery_Frames)
		direction = area.direction

func _calculate_stun(Recovery: float):
	var stamina_rating: float = Player_Stats.Stamina_Rating
	var stun_frames: float = Recovery / stamina_rating
	var stuned_time: float = stun_frames / 60

	Stun_Timer.set_wait_time(stuned_time)
	Stun_Timer.start()
	print("Stun time " ,stuned_time)


func apply_constant_force(Constant: Vector2):
	if direction == true:
		Constant.x *= -1

	else:
		Constant.x *= 1
	var defense_rating: float = Player_Stats.Defense_Rating
	var knockback_x: float = Constant.x / defense_rating
	var knockback_y: float = Constant.y / defense_rating
	var knockback_vector: Vector2 = Vector2(knockback_x,knockback_y)
	#print(Character.velocity)

	Character.velocity.x = move_toward(Character.velocity.x, knockback_vector.x * knockback_multiplier, 100)
	Character.velocity.y = move_toward(Character.velocity.y, knockback_vector.y * knockback_multiplier, 100)

func _on_is_hurt(Damage: int) -> void:
	Animator.state = Hurt

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

	if Player_Stats.Health < 500:
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


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Knockout Area"):
		Animator.state = Respawn
		Player_Stats.Health = 1000
