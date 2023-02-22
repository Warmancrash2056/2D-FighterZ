extends KinematicBody2D 
class_name FireKnight, "res://Character Resouces/Fire Knight/fire_knight.png"

onready var Animate = $AnimationPlayer


export (float) var Speed
export (float) var Gravity
export (float) var Acceleration
export (float) var Jump

 
enum state{
	idle,
	jump
}
var states = state.idle
var velocity = Vector2.ZERO

func _physics_process(delta) -> void:
	
	match states:
		
		
		state.idle:
			var input_vector = Vector2.ZERO
			
			# Get_Axis gets the controller axis of the player negative and positive. Get_Axis is an alternative for Get_Action_Strength 
			input_vector.x = Input.get_axis("ui_left", "ui_right")
			
			# Sets the action strength to zero when pressed changes the value based on how far the joy axis is pushed 
			# Get the action strength of left or right from between 0 and 1 at any given point based on direction of player. 
			input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
			if input_vector != Vector2.ZERO:
			# If the player presses an action add movement spoeed.
			
				velocity += input_vector * Acceleration * delta
				velocity = velocity.clamped(Speed)
				
				print(velocity.clamped(Speed))
				# Gets the value of the player speed based on coordinates. 
			
			else:
				velocity = velocity.linear_interpolate(Vector2.ZERO , 0.2)
				
			velocity = move_and_slide(velocity)
			
			if Input.is_action_just_pressed("ui_accept"):
				states = state.jump
		
		state.jump:
			print("good to jump")
	
# Get_Axis gets the controller axis of the player negative and positive. Get_Axis is an alternative for Get_Action_Strength 
