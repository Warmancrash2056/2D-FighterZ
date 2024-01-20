extends Marker2D

var dash_smoke = preload("res://Character Resouces/Global/dash_smoke.tscn")

@onready var player = $".."
func _physics_process(delta):
	pass
	
func _activate_dash_smoke():
	print("Dash")
	var instance_dash_smoke = dash_smoke.instantiate()
	instance_dash_smoke.global_position = global_position
	get_tree().get_root().add_child(instance_dash_smoke)

	if CharacterList.player_1_facing_left == true:
		instance_dash_smoke.scale.x = -1
	else:
		instance_dash_smoke.scale.x = 1


func _on_goku_dash_cloud():
	print("Dash")
	var instance_dash_smoke = dash_smoke.instantiate()
	instance_dash_smoke.global_position = global_position
	get_tree().get_root().add_child(instance_dash_smoke)

	if CharacterList.player_1_facing_left == true:
		instance_dash_smoke.scale.x = -1
	else:
		instance_dash_smoke.scale.x = 1

