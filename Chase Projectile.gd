extends CharacterBody2D

@onready var ExplosionTimer = $Timer

func _physics_process(delta):
	print(ExplosionTimer.time_left)
func _process(delta):
	ExplosionTimer.start()
	print(ExplosionTimer.time_left)
func _on_timer_timeout():
	print("good")
