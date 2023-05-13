extends Node2D

@onready var Player1Spawn = CharacterList.Player1.instantiate()
# Called when the node enters the scene treefor the first time.
func _ready():
	SpawnChosen()

func SpawnChosen():
	call_deferred("add_child", Player1Spawn)
	
	# if says "could not resolve script usaully means that 
	#script is error and needs to be fixed. before running again.
	Player1Spawn.set_script(CharacterList.Player1Script)
	
func _process(delta):
	print()
