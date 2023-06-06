extends Node2D

@onready var player_2_spawn = CharacterList.get_player_2.instantiate()

func _ready():
	SpawnChosen()

func SpawnChosen():
	call_deferred("add_child", player_2_spawn)
	player_2_spawn.set_script(CharacterList.get_player_2_script)
