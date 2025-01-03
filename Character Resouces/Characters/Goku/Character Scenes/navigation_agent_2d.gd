extends NavigationAgent2D


@export var Hurtbox: Area2D
@export var Character: RigidBody2D
var target = null
func _physics_process(delta: float) -> void:
	if target!= null:
		target_position = target.global_position
		print(target_position)
        var next_pa