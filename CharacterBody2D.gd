extends CharacterBody2D

@onready var Animate = $AnimationPlayer

func delete_projectile():
	queue_free()
func _process(delta):
	move_and_slide()
	
	match state:
		Shoot:
			Animate.play("Shoot")
			
		Explode:
			Animate.play("Explode")
			velocity.x = 0
		
enum {
	Shoot,
	Explode
}

var state = Shoot

func _on_fireball_area_entered(area):
	state = Explode
	
