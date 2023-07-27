extends Sprite2D


func _ready():
	$AnimationPlayer.play("Shower")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Shower":
		queue_free()
		print("Attack Finished:  Hunter Down Attack")
		
