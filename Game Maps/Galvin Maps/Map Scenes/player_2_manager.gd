extends Node2D

@onready var player_2_spawn = CharacterList.get_player_2.instantiate()
var player2_position: Vector2

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
	player_2_package()

func queue_player() -> void:
	if is_instance_valid(player_2_spawn):
		player_2_spawn.queue_free()

func player_2_package() -> void:
	# Instantiate a new player node
	player_2_spawn = CharacterList.get_player_2.instantiate()
	player_2_spawn.set_script(CharacterList.get_player_2_script)

	# Add the new player to the scene tree first

	await get_tree().create_timer(1).timeout  # Short delay to ensure it's added
	call_deferred("add_child", player_2_spawn)

	# Now access the player's nodes and set properties
	var player_2_position:RigidBody2D = player_2_spawn.get_node("Controller")
	var player_2_animator:AnimationPlayer = player_2_spawn.get_node("Controller/Animator")


	# Set the initial position and properties

	# Wait a bit before changing the animator state
	await get_tree().create_timer(3).timeout
	player_2_animator.state = Idle
	player_2_position.can_move = true
	player_2_position.can_direct = true
	player_2_position.can_jump = true
	player_2_position.can_attack = true

func _process(delta: float) -> void:
	pass




func _on_galvin_road_player_2_knockout() -> void:
	queue_player()
	await get_tree().create_timer(3).timeout
	player_2_package()
