extends CharacterBody2D

func _ready():
	$AnimationPlayer.play("Shoot Spear")
	
func _process(delta):
	move_and_slide()

