extends Node2D

@onready var Player2Spawn = CharacterList.Player2.instantiate()
# Called when the node enters the scene treefor the first time.
func _ready():
	SpawnChosen()
	print(CharacterList.Player2)

func SpawnChosen():
	call_deferred("add_child", Player2Spawn)
	Player2Spawn.set_script(CharacterList.main_player_script)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
