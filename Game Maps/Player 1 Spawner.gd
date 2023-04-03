extends Node2D

@onready var Player1Spawn = Player1CharacterSelection.Player1.instantiate()
# Called when the node enters the scene treefor the first time.
func _ready():
	SpawnChosen()

func SpawnChosen():
	call_deferred("add_child", Player1Spawn)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
