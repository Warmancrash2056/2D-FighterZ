extends CharacterBody2D

@onready var Sprite = $"Arrow Head"

var arrow_speed = 100
	

func _process(delta):
	
	move_and_slide()
	
	


func _on_timer_timeout():
	queue_free()
	


func _on_arrow_hitbox_body_entered(body):
	$Timer.start()
	velocity.x = 0
