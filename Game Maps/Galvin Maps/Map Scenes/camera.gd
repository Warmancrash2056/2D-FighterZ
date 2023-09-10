extends Camera2D

@onready var player_1_spawn = CharacterList.get_player_1 .instantiate()
@onready var player_2_spawn = CharacterList.get_player_2.instantiate()

# Called when the node enters the scene tree for the first time.
func _ready():
	Player_1()
	Player_2()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var distance = player_1_spawn.global_position.distance_to(player_2_spawn.global_position)
	
	var center = player_1_spawn.position + player_2_spawn.position / 2
	
	$Timer.start()
	
	if $Timer.timeout:
		position = center
	
func Player_1():
	
	call_deferred("add_child", player_1_spawn)
	player_1_spawn.set_script(CharacterList.get_player_1_script)
	
	player_1_spawn.position = Vector2(192,-192)
func Player_2():
	
	call_deferred("add_child", player_2_spawn)
	player_2_spawn.set_script(CharacterList.get_player_2_script)
	
	player_2_spawn.position = Vector2(-192,-192)
