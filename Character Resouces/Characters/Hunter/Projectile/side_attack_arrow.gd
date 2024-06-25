extends CharacterBody2D

func queue_object():
	queue_free()

func _ready():
	$AnimationPlayer.play("Shoot")
	

func _process(delta):
	move_and_slide()
	
	


func _on_timer_timeout():
	queue_free()
	


func _on_arrow_hitbox_body_entered(body):
	velocity.x = 0
	if body.is_in_group("Wall"):
		$AnimationPlayer.play("Hit On Wall")
		
	if body.is_in_group("Small Platform"):
		$AnimationPlayer.play("Hit")
		print("On small platform")
		CharacterList.disable_mini_platform = true
		
func _on_arrow_hitbox_area_entered(area):
	pass # Replace with function body.
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Hit":
		$AnimationPlayer.play("Bloom")

	if anim_name == "Bloom":
		$AnimationPlayer.play("Queue")
		
	if anim_name == "Queue":
		queue_free()
		CharacterList.disable_mini_platform = false
