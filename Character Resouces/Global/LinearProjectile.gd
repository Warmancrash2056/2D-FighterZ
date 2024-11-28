class_name LinearProjectile extends CharacterBody2D
@export var Projectile_Hitbox: Area2D
@export var Max_Speed: int
@export var Acceleration: float
var direction = 1
var Projectile_Layer: int
var Projectile_Mask: int
var collider_mask: int
@export var Animator: AnimationPlayer
@export var Sprite: Sprite2D

enum {Shoot, Hit}
var state = Shoot
func _ready():
	if direction == 1:
		Sprite.flip_h = false

	else:
		if direction == -1:
			Sprite.flip_h = true
	state = Shoot



func _delete():
	queue_free()

func _process(delta):
	Projectile_Hitbox.set_collision_layer_value(Projectile_Layer,true)
	Projectile_Hitbox.set_collision_mask_value(Projectile_Mask, true)
	move_and_slide()
	match state:
		Shoot:
			Animator.play("Shoot")
			velocity.x = move_toward(velocity.x, direction * Max_Speed, Acceleration)
		Hit:
			Animator.play("Hit")
			velocity = Vector2.ZERO

func _on_area_2d_body_entered(body):
	state = Hit

func _on_area_2d_area_entered(area):
	state = Hit