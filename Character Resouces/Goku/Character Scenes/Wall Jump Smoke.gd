extends Marker2D

@export var Character: CharacterBody2D
@export var Sprite: Sprite2D
var wall_jump_smoke = preload("res://Autoloads/wall_jump_cloud.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	Character.connect("WallCloud", _activate_wall_jump_smoke)

func _activate_wall_jump_smoke():
	var instance_wall_jump = wall_jump_smoke.instantiate()
	instance_wall_jump.global_position = global_position
	get_tree().get_root().add_child(instance_wall_jump)

	if Sprite.flip_h == true:
		instance_wall_jump.scale.y = 3
	else:
		instance_wall_jump.scale.y = -3
