extends Marker2D
@export var Character: CharacterBody2D
var counter_smoke = preload("res://Character Resouces/Global/counter.tscn")

# Called when the node enters the scene tree for the first time.
func _process(delta):
	owner.connect("CounterCloud", _activate_counter_cloud)


func _activate_counter_cloud():
	var instance_smoke_counter = counter_smoke.instantiate()
	get_tree().get_root().add_child(instance_smoke_counter)
