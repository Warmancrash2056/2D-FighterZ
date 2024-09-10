extends Node2D

@onready var player_1_spawn = CharacterList.get_player_1.instantiate()
var player1_position: Vector2

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

func _ready() -> void:
	player_1_package()

func queue_player() -> void:
	if is_instance_valid(player_1_spawn):
		player_1_spawn.queue_free()

func player_1_package() -> void:
	# Instantiate a new player node
	player_1_spawn = CharacterList.get_player_1.instantiate()
	player_1_spawn.set_script(CharacterList.get_player_1_script)

	# Add the new player to the scene tree first
	call_deferred("add_child", player_1_spawn)

	await get_tree().create_timer(0.1).timeout  # Short delay to ensure it's added

	# Now access the player's nodes and set properties
	var player_1_position:CharacterBody2D = player_1_spawn.get_node("Controller")
	var player_1_animator:AnimationPlayer = player_1_spawn.get_node("Controller/Animator")


	# Set the initial position and properties

	# Wait a bit before changing the animator state
	await get_tree().create_timer(2.5).timeout
	player_1_animator.state = Idle
	player_1_position.can_move = true
	player_1_position.can_direct = true
	player_1_position.can_jump = true
	player_1_position.can_attack = true

func _process(delta: float) -> void:
	pass




func _on_galvin_road_player_1_knockout() -> void:
	queue_player()
	await get_tree().create_timer(3).timeout
	player_1_package()
