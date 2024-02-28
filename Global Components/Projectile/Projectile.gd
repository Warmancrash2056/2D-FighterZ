extends Marker2D
@export var air_projectile: Resource
@export var ground_projectile: Resource
@export var sprite = Sprite2D
@export var Character: CharacterBody2D

func _activate_ground_projectile():
	var i = ground_projectile

func activate_air_projectile():
	var i = air_projectile


func _on_character_is_throwing():
	if Character.is_on_floor():
		_activate_ground_projectile()

	else:
		if !Character.is_on_floor():
			activate_air_projectile()
