extends CharacterBody2D

func _ready():
	$AnimationPlayer.play("Shoot Spear")
	
func _process(delta):
	move_and_slide()
	velocity.y = 0
	
func queue_onject():
	queue_free()
	
func _on_area_2d_area_entered(area):
	$AnimationPlayer.play("Hit")

func _on_area_2d_body_entered(body):
	$AnimationPlayer.play("Hit")
