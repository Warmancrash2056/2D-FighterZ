extends Marker2D

@export var Air_Projectle: Resource
@export var Ground_Projectile: Resource
@export var Sprite: Sprite2D
func _ground_projectile():
	var instance_molten_sand = Ground_Projectile.instantiate()
	instance_molten_sand.global_position = global_position
	get_tree().get_root().add_child(instance_molten_sand)

	if Sprite.flip_h == false:
		instance_molten_sand.direction = 1
	else:
		instance_molten_sand.direction = -1

func air_prrojectile():
	var instance_molten_sand = Air_Projectle.instantiate()
	instance_molten_sand.global_position = global_position
	get_tree().get_root().add_child(instance_molten_sand)

	if Sprite.flip_h == false:
		instance_molten_sand.direction = 1
	else:
		instance_molten_sand.direction = -1
