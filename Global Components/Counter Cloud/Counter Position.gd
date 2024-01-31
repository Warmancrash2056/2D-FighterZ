extends Marker2D
@export var Character: CharacterBody2D
@export var Counter_Cloud: Resource

# Called when the node enters the scene tree for the first time.
func _process(delta):
	Character.connect("CounterCloud", _activate_counter_cloud)


func _activate_counter_cloud():
	var instance_smoke_counter = Counter_Cloud.instantiate()
	get_tree().get_root().add_child(instance_smoke_counter)
