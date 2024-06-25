extends Marker2D

@export var Sprite: Sprite2D
@export var Wall_Cloud: Resource

func _on_character_controller_wall_cloud() -> void:
	var instance_wall_cloud = Wall_Cloud.instantiate()
	instance_wall_cloud.global_position = global_position
	if Sprite.flip_h == true:
		instance_wall_cloud.flip_v = true

	else:
		instance_wall_cloud.flip_v = false

	get_tree().get_root().add_child(instance_wall_cloud)
