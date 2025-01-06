extends Area2D

@export var Collider: CollisionShape2D

func  _physics_process(delta: float) -> void:
	if has_overlapping_bodies():
		Collider.debug_color = Color.RED
		Collider.debug_color = Color.YELLOW
		Collider.debug_color = Color.GREEN

	else:
		Collider.debug_color = Color.BLUE
