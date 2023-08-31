extends Node2D

@onready var player_1_spawn = CharacterList.get_player_1.instantiate()

func _ready():
	SpawnChosen()

func SpawnChosen():
	call_deferred("add_child", player_1_spawn)
	player_1_spawn.set_script(CharacterList.get_player_1_script)
