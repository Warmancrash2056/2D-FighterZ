extends Marker2D
@onready var Player_Identifier: Node2D = $'../../..'
@export var Controller: CharacterBody2D
@export var Air_Projectle: Resource
@export var Ground_Projectile: Resource
@export var Sprite: Sprite2D
func _ground_projectile():
	var instance_ground_projectile = Ground_Projectile.instantiate()
	var instance_air_projectile = Air_Projectle.instantiate()

	var ground_projectile_layering: Area2D = instance_air_projectile.get_node("Hitbox")
	var air_projectile_layering: Area2D = instance_air_projectile.get_node("Hitbox")
	# Set the collider values before instancing projectile.
	ground_projectile_layering.set_collision_layer_value(Player_Identifier.Projectile_Layer, true)
	ground_projectile_layering.set_collision_mask_value(Player_Identifier.Projectile_Mask, true)
	air_projectile_layering.set_collision_layer_value(Player_Identifier.Projectile_Layer, true)
	air_projectile_layering.set_collision_mask_value(Player_Identifier.Projectile_Mask, true)
	instance_air_projectile.global_position = global_position

	# Change the root node scaling based on player sprite facing.

	if Sprite.flip_h == false:
		instance_ground_projectile.direction = 1
		instance_air_projectile.direction = 1
	else:
		instance_ground_projectile.direction = -1
		instance_air_projectile.irection = -1

	if Controller.is_on_floor():
		get_tree().get_root().add_child(instance_ground_projectile)

	else:
		if !Controller.is_on_floor():
			get_tree().get_root().add_child(instance_air_projectile)
