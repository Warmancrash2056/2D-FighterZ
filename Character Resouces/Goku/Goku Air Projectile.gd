class_name LinearProjectile extends CharacterBody2D

@export var Max_Speed: int
@export var Acceleration: float
var direction = 1
@export var Animator: AnimationPlayer

func _ready():
	Animator.play("Shoot")


func _delete():
	queue_free()

func _process(delta):
	move_and_slide()
	velocity.x = move_toward(velocity.x, direction * Max_Speed, Acceleration)


func _on_area_2d_body_entered(body):
	Animator.play("Hit")
	velocity = Vector2.ZERO


func _on_area_2d_area_entered(area):
	Animator.play("Hit")
	velocity = Vector2.ZERO
