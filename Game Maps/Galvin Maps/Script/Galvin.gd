extends Node2D

@onready var player_1_spawn = CharacterList.Player1.instantiate()
@onready var player_2_spawn = CharacterList.Player2.instantiate()
# Called when the node enters the scene treefor the first time.
	
func _process(delta):
	print()


# Play audio when scene entered.
func _ready():
	Audio._galvin_map_play()
	
	if CharacterList.player

func player_1_ready():
	call_deferred("add_child", player_1_spawn)
	
	# if says "could not resolve script usaully means that 
	#script is error and needs to be fixed. before running again.
	Player1Spawn.set_script(CharacterList.Player1)
	
func player_2_ready():
	call_deferred("add_child", player_2_spawn)
	
	# if says "could not resolve script usaully means that 
	#script is error and needs to be fixed. before running again.
	Player1Spawn.set_script(CharacterList.Player1Script)


	

	
