extends Node2D

@onready var player_1_spawn = CharacterList.get_main_player.instantiate()
# Called when the node enters the scene treefor the first time.
func _ready():
	if CharacterList.get_main_player != null:
		SpawnChosen()
	else:
		return

func SpawnChosen():
	call_deferred("add_child", player_1_spawn)
	
	# if says "could not resolve script usaully means that 
	#script is error and needs to be fixed. before running again.
	player_1_spawn.set_script(CharacterList.get_main_player_script)
	
