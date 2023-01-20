extends KinematicBody2D

onready var Animate = $AnimatedSprite

export (float) var Movement
export (float) var Jump
export (float) var Fall

enum States {
	Idle,
	Jump,
	Fall,
	Nlight,
	Slight,
	Dlight,
	Ulight,
	Nair,
	Defend,
	Death,
	Hurt
}

func _physics_process(delta):
	

func _on_AnimatedSprite_animation_finished():
	pass # Replace with function body.
