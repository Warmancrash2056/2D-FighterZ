extends Marker2D

@export var Dash_Cloud: Resource
@export var Sprite: Sprite2D
@export var Dash_Sound: AudioStreamPlayer2D


func _on_controller_is_dashing() -> void:
	var instance_dash_cloud = Dash_Cloud.instantiate()
	instance_dash_cloud.global_position = global_position
	get_tree().get_root().add_child(instance_dash_cloud)

	if Sprite.flip_h == true:
		instance_dash_cloud.scale.x = -1
	else:
		instance_dash_cloud.scale.x = 1
