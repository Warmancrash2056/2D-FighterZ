extends Marker2D
@export var Character: CharacterBody2D
@export var Counter_Cloud: Resource

func _on_character_counter_cloud():
	var instance_smoke_counter = Counter_Cloud.instantiate()
	get_tree().get_root().add_child(instance_smoke_counter)
