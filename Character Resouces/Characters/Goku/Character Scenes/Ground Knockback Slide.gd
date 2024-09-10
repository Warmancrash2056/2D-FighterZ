extends Marker2D
@export var Sprite: Sprite2D
@export var Slow_Knockback_Cloud: Resource
@export var Fast_Knockback_Cloud: Resource


func _on_animator_ground_knockback_cloud() -> void:
	var inst = Slow_Knockback_Cloud.instantiate()

	inst.global_position = global_position
	if Sprite.flip_h == true:
		inst.scale.x == 1

	else:
		inst.scale.x = -1

	get_tree().get_root().add_child(inst)
