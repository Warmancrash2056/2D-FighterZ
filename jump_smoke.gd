extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	play("Smoke")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_animation_looped():
	queue_free()
