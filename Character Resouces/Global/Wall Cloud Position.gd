extends Marker2D

@export var Wall_Cloud: Resource
@export var Sprite: Sprite2D
@export var Wall_Sound: AudioStreamPlayer2D
@onready var Wall_Detector: Area2D = $'Wall Detector'

func _on_area_2d_body_entered(body: Node2D) -> void:
	var instance_wall_cloud = Wall_Cloud.instantiate()
	instance_wall_cloud.global_position = global_position
	get_tree().get_root().add_child(instance_wall_cloud)

	if Sprite.flip_h == true:
		instance_wall_cloud.scale.y = 2
	else:
		instance_wall_cloud.scale.y = -2
