extends Camera2D
@onready var player_1_spawn = CharacterList.get_player_1 .instantiate()
@onready var player_2_spawn = CharacterList.get_player_2.instantiate()


func _ready() -> void:
	Player_1()
	Player_2()
	
func _physics_process(delta: float) -> void:
		var midpoint = (player_1_spawn.global_transform.origin + player_2_spawn.global_transform.origin) / 2
		
		
		print(midpoint)
func Player_1():
	
	call_deferred("add_child", player_1_spawn)
	player_1_spawn.set_script(CharacterList.get_player_1_script)
	
	player_1_spawn.position = Vector2(192,-102)
	
func Player_2():
	
	call_deferred("add_child", player_2_spawn)
	player_2_spawn.set_script(CharacterList.get_player_2_script)
	
	player_2_spawn.position = Vector2(-192,-102)
