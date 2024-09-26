extends Marker2D
@export var Player_Identifier: Node2D
@export var Controller: CharacterBody2D
@export var Air_Projectle: Resource
@export var Ground_Projectile: Resource
@export var Sprite: Sprite2D
func _create_projectile():
	print(Player_Identifier.Attack_Layer)
	print(Player_Identifier.Attack_Mask)
	var instance_ground_projectile = Ground_Projectile.instantiate()
	var instance_air_projectile = Air_Projectle.instantiate()

	# Set the collider values before instancing projectile.
	instance_air_projectile.global_position = global_position
	instance_ground_projectile.global_position = global_position
	# Change the root node scaling based on player sprite facing.
	instance_air_projectile.Projectile_Layer = Player_Identifier.Attack_Layer
	instance_air_projectile.Projectile_Mask = Player_Identifier.Attack_Mask
	instance_ground_projectile.Projectile_Layer = Player_Identifier.Attack_Layer
	instance_ground_projectile.Projectile_Mask = Player_Identifier.Attack_Mask

	if Sprite.flip_h == false:
		instance_ground_projectile.direction = 1
		instance_air_projectile.direction = 1
	else:
		instance_ground_projectile.direction = -1
		instance_air_projectile.direction = -1

	if Controller.is_on_floor():
		get_tree().get_root().add_child(instance_ground_projectile)

	else:
		if !Controller.is_on_floor():
			get_tree().get_root().add_child(instance_air_projectile)
