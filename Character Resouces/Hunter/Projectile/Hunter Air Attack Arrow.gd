extends CharacterBody2D

func _ready():
	$AnimationPlayer.play("Shoot")

func queue_object():
	queue_free()
	
func _process(delta):
	move_and_slide()
	
	if is_on_wall():
		rotation = 300
func _on_hunter_diagonal_arrow_area_entered(area):
	pass # Replace with function body.


func _on_hunter_diagonal_arrow_body_entered(body):
	velocity = Vector2.ZERO
	$AnimationPlayer.play("Hit")
	await get_tree().create_timer(1).timeout
	$Timer.start()

func _on_timer_timeout():
	$AnimationPlayer.play("Bloom")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Bloom":
		$AnimationPlayer.play("Queue")
