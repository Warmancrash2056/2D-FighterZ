extends CharacterBody2D

@onready var animate = $AnimationPlayer

func _ready():
	animate.play("Shoot")
	

func _delete():
	queue_free()
	
func _process(delta):
	move_and_slide()


func _on_area_2d_body_entered(body):
	animate.play("Hit")
	velocity = Vector2.ZERO


func _on_area_2d_area_entered(area):
	animate.play("Hit")
	velocity = Vector2.ZERO
