extends Marker2D

@export var Air_Knockback_Cloud: Resource
@export var Character: CharacterBody2D
func _instance_air_cloud():
	var inst = Air_Knockback_Cloud.instantiate()
	inst.global_position = global_position
	if Character.velocity.y != 0 and Character.velocity.x == 0:
		inst.rotation = 90

	else:
		inst.rotation = 0
	if Character.velocity.y >= 300:
		get_tree().get_root().add_child(inst)
	elif Character.velocity.y <= -300:
		get_tree().get_root().add_child(inst)
