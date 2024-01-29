extends Marker2D
@export var Character: CharacterBody2D
@export var Sprite: Sprite2D
var dash_smoke = preload("res://Character Resouces/Global/dash_smoke.tscn")

func _process(delta):
	Character.connect("DashCloud", activate_dash_cloud) #Signal: DashCloud
func activate_dash_cloud():
	var instance_dash_smoke = dash_smoke.instantiate()
	instance_dash_smoke.global_position = global_position
	get_tree().get_root().add_child(instance_dash_smoke)

	if Sprite.flip_h == true:
		instance_dash_smoke.scale.x = -1
	else:
		instance_dash_smoke.scale.x = 1

