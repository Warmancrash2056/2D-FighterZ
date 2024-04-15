extends Marker2D


@export var Counter_Cloud: Resource
@export var Character: CharacterBody2D

func _process(delta: float) -> void:
	var instance_counter_cloud = Counter_Cloud.instantiate()
