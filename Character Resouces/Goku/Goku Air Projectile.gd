class_name LinearProjectile extends CharacterBody2D

@export var Max_Speed: int
@export var Acceleration: float
var direction = 1
@export var Animator: AnimationPlayer
@export var Sprite: Sprite2D

func _ready():
	if direction == 1:
		Sprite.flip_h = false

	else:
		Sprite.flip_h = true
	Animator.play("Shoot")


func _delete():
	queue_free()

func _process(delta):
	move_and_slide()
	if direction == 1:
		Sprite.flip_h = false

	else:
		Sprite.flip_h = true
	velocity.x = move_toward(velocity.x, direction * Max_Speed, Acceleration)


func _on_area_2d_body_entered(body):
	Animator.play("Hit")
	velocity = Vector2.ZERO


func _on_area_2d_area_entered(area):
	Animator.play("Hit")
	velocity = Vector2.ZERO
