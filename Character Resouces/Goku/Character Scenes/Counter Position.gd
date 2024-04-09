extends Marker2D


@export var Counter_Cloud: Resource
@export var Character: CharacterBody2D

func _process(delta: float) -> void:
	var instance_counter_cloud = Counter_Cloud.instantiate()
	if Character.can_counter == true:
		instance_counter_cloud.global_position = global_position
		get_tree().get_root().add_child(instance_counter_cloud)

