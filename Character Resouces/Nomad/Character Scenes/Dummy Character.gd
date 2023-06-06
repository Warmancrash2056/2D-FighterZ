extends CharacterBody2D



func _process(delta):
	$Character.play("Idle")
	velocity.y += 1000
	move_and_slide()
	
