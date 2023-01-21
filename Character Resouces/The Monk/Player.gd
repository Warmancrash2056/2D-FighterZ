extends KinematicBody2D

onready var Animate = $AnimatedSprite

export var controls: Resource = null

export (float) var Movement
export (float) var Jump
export (float) var Fall
export (int) var Device_Index
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
var Select = States.Idle
func _physics_process(delta):
	match Select:
		States.Idle:
			if Input.is_action_pressed(controls.input_left):
				print("Go")
			
			
		States.Jump:
			pass
			
		States.Fall:
			pass
			
		States.Nlight:
			pass
			
		States.Slight:
			pass
			
		States.Dlight:
			pass
			
		States.Ulight:
			pass
			
		States.Nair:
			pass
			
		States.Defend:
			pass
			
		States.Death:
			pass
			
		States.Hurt:
			pass

func _on_AnimatedSprite_animation_finished():
	pass # Replace with function body.
