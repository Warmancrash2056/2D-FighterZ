extends AnimatedSprite2D

func _ready():
	play("Smoke")

func _on_animation_looped():
	queue_free()
