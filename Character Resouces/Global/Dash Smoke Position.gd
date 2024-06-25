extends Marker2D

@export var Sprite: Sprite2D
@export var Dash_Cloud: Resource


func _on_character_controller_dash_cloud() -> void:
	var instance_dash_cloud = Dash_Cloud.instantiate()
	instance_dash_cloud.global_position = global_position
	if Sprite.flip_h == true:
		instance_dash_cloud.flip_h = false

	else:
		instance_dash_cloud.flip_h = true

	get_tree().get_root().add_child(instance_dash_cloud)
