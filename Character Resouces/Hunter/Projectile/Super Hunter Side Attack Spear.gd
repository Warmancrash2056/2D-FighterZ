extends CharacterBody2D

func _ready():
	$AnimationPlayer.play("Shoot")
func _physics_process(delta):
	move_and_slide()
	
func _queue_object():
	queue_free()

func _on_area_2d_area_entered(area):
	velocity.x = 0
	$AnimationPlayer.play("Hit")
