extends Node2D

@onready var player_1_spawn = CharacterList.get_player_1.instantiate()
@onready var player_2_spawn = CharacterList.get_player_2.instantiate()
# Called when the node enters the scene treefor the first time.
	
func _process(delta):
	print()


# Play audio when scene entered.
func _ready():
	Audio._galvin_map_play()
	
	if CharacterList.check_player_1_is_called == true:
		player_1_ready()
		
	if CharacterList.check_player_2_is_called == true:
		player_2_ready()
func player_1_ready():
	call_deferred("add_child", player_1_spawn)
	
	# if says "could not resolve script usaully means that 
	#script is error and needs to be fixed. before running again.
	player_1_spawn.set_script(CharacterList.get_player_1_script)
	
func player_2_ready():
	call_deferred("add_child", player_2_spawn)
	
	# if says "could not resolve script usaully means that 
	#script is error and needs to be fixed. before running again.
	player_2_spawn.set_script(CharacterList.get_player_2_script)


	

	
