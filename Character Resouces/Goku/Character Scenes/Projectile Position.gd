extends Marker2D

@export var Air_Projectle: Resource
@export var Ground_Projectile: Resource

func _ground_projectile():
	var instance_molten_sand = Ground_Projectile.instantiate()
	instance_molten_sand.global_position = global_position
	get_tree().get_root().add_child(instance_molten_sand)

	if CharacterList.player_1_facing_left == true:
		instance_molten_sand.velocity.x = -700
		instance_molten_sand.scale.x = -1
	else:
		instance_molten_sand.velocity.x = 700
		instance_molten_sand.scale.x = 1

func air_prrojectile():
	var instance_molten_sand = Air_Projectle.instantiate()
	instance_molten_sand.global_position = global_position
	get_tree().get_root().add_child(instance_molten_sand)

	if CharacterList.player_1_facing_left == true:
		instance_molten_sand.velocity.x = -700
		instance_molten_sand.scale.x = -1
	else:
		instance_molten_sand.velocity.x = 700
		instance_molten_sand.scale.x = 1
