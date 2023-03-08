extends CharacterBody2D

@onready var NaiCharacter = get_node("res://Character Resouces/Nai/Player 1 Nai.tscn")

@export var ShootProjectile =  Vector2(300,300)

@onready var AnimateProjectile = $AnimatedSprite2D
@onready var ExplodeTimer = $Timer
var Select = States.Shoot

enum States {
	Shoot,
	Land,
	Idle,
	Explode
}
var Motion = Vector2.ZERO
func _process(delta):
	print(ExplodeTimer.time_left)
	move_and_slide()
	set_velocity(Motion)
	match Select:
		States.Shoot:
			AnimateProjectile.play("Trap Cast")
			if NaiCharacter.Motion != 0:
				print("Good")
			Motion = ShootProjectile
			
			if is_on_floor():
				Select = States.Land
		States.Land:
			Motion = Vector2.ZERO
			AnimateProjectile.play("Land")
			
			
		States.Idle:
			AnimateProjectile.play("On Floor")
			
		States.Explode:
			AnimateProjectile.play("Explode")
			


func _on_timer_timeout():
	Select = States.Explode
	print("explode")


func Explodetime():
	ExplodeTimer.start()

func _on_animated_sprite_2d_animation_looped():
	if AnimateProjectile.animation == "Land":
		Select = States.Idle
		
	if AnimateProjectile.animation == "Explode":
		queue_free()





func _on_area_2d_area_entered(area):
	if area:
		ExplodeTimer.start()
		print("good")


func _on_area_2d_body_entered(body):
	if body:
		ExplodeTimer.start()
		print("good")
		

