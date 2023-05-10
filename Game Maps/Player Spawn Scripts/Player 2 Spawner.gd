extends Node2D

@onready var Player2Spawn = CharacterList.Player2.instantiate()
# Called when the node enters the scene treefor the first time.
func _ready():
	SpawnChosen()

func SpawnChosen():
	call_deferred("add_child", Player2Spawn)
	Player2Spawn.set_script(CharacterList.Player2Script)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
