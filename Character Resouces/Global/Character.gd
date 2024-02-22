class_name Player extends CharacterBody2D

@export var Controller: Node
@export var Animator: AnimationPlayer

@export var Speed:int = 150
@export var Acceleration:int = 10
@export var Decceleration:int = 25
@export var Speed_Rating: float 

@export var Health:int
@export var Defense_Rating:float
@export var Attack_Rating:float

@export var Gravity:int = 10
@export var Jump_Height:int = 350
@export var Fast_Fall:int
@export var Jump_Count:int = 3

var is_attacking = false
signal JumpCloud
signal DashCloud
signal WallCloud
signal CounterCloud


func _ready():
	Speed *= Speed_Rating
func _physics_process(delta):
	move_and_slide()
	if is_attacking == false:
		if !is_on_floor():
			velocity.y += Gravity

func _on_hurtbox_area_entered(area):
	pass # Replace with function body.


func _on_character_on_ground():
	print(Jump_Count)
	Jump_Count = 3


func _on_character_is_stopping():
	velocity.x = move_toward(velocity.x , 0, Decceleration)



func _on_character_is_dashing():
	pass # Replace with function body.


func _on_character_is_jumping():
	Jump_Count -= 1
	if Jump_Count > 0:
		emit_signal("JumpCloud")
		velocity.y = -Jump_Height


func _on_character_is_throwing():
	pass # Replace with function body.


func _on_character_attack_moving(Vector):
	velocity.x += Vector.x
	velocity.y = Vector.y




func _on_character_is_attacking():
	pass

func _on_character_is_resetting():
	pass


func _on_character_is_moving(vector):
	var dir: int = vector.x
	
	if Engine.get_physics_frames() % 5 == 0:
		if dir == 1:
			velocity.x = move_toward(velocity.x , Speed, Acceleration) 
			
		else:
			velocity.x = move_toward(velocity.x , -Speed, Acceleration) 

