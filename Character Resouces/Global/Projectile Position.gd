extends Marker2D
@export var Player_Identifier: Node2D
@export var Controller: CharacterBody2D
@export var Air_Projectle: Resource
@export var Ground_Projectile: Resource
@export var Sprite: Sprite2D

func _Ground_Projectile():
	var instance_ground_projectile = Ground_Projectile.instantiate()
	if Sprite.flip_h == false:
		instance_ground_projectile.direction = 1
	else:
		instance_ground_projectile.direction = -1
	instance_ground_projectile.global_position = global_position
	instance_ground_projectile.Projectile_Layer = Player_Identifier.Attack_Layer
	instance_ground_projectile.Projectile_Mask = Player_Identifier.Attack_Mask
	get_tree().get_root().add_child(instance_ground_projectile)

func _Air_Projectile():
	var instance_air_projectile = Air_Projectle.instantiate()
	if Sprite.flip_h == false:
		instance_air_projectile.direction = 1
	else:
		instance_air_projectile.direction = -1
	instance_air_projectile.global_position = global_position
	instance_air_projectile.Projectile_Layer = Player_Identifier.Attack_Layer
	instance_air_projectile.Projectile_Mask = Player_Identifier.Attack_Mask
	get_tree().get_root().add_child(instance_air_projectile)
