extends Marker2D

@export var Character: CharacterBody2D
@export var Sprite: Sprite2D
@export var Wall_Cloud = Resource

func _process(delta):
	Character.connect("WallCloud", _instance)
	
func _instance():
	var i = Wall_Cloud.instantiate()
	i.global_position = global_position
	get_tree().get_root().add_child(i)
