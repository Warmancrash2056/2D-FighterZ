extends Node2D
@onready var player_2_spawn = CharacterList.get_player_1.instantiate()
var player1_position: Vector2
enum { # Character animator states.
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

func _ready() -> void:
	player_2_package()

func queue_player():
	player_2_spawn.queue_free()
func player_2_package():
	var player_2_position:CharacterBody2D = player_2_spawn.get_node("Controller")
	var player_2_animator:AnimationPlayer = player_2_spawn.get_node("Controller/Animator")

	player_2_spawn.set_script(CharacterList.get_player_1_script)


	await get_tree().create_timer(2).timeout
	call_deferred("add_child", player_2_spawn)
	player_2_position.global_position = Vector2(-192, 0)

	await get_tree().create_timer(2.5).timeout
	player_2_animator.state = Idle
	player_2_position.can_move = true
	player_2_position.can_direct = true
	player_2_position.can_jump = true
	player_2_position.can_attack = true

func _process(delta: float) -> void:
	var player_2_position:CharacterBody2D = player_2_spawn.get_node("Controller")
	player1_position = player_2_position.global_position


func _on_galvin_road_player_2_knocked_out() -> void:
	queue_player()
	await get_tree().create_timer(1).timeout
	player_2_package()
