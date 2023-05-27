extends Node2D


# Play audio when scene entered.
func _ready():
	Audio._galvin_map_play()

func _process(delta):
	print(get_tree())

func player_1_ready():
	pass
	
func player_2_ready():
	pass
	
	
