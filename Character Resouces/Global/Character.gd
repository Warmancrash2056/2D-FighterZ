class_name Player extends CharacterBody2D

@export var Controller: Node
@export var Animator: AnimationPlayer

@export var Speed:int = 400
@export var Acceleration:int = 20
@export var Decceleration: int = 10
@export var Speed_Rating: float 

@export var Health: int = 1000
@export var Defense_Rating: float
@export var Attack_Rating: float

@export var Gravity:int = 15
@export var Jump_Height: int = 600
@export var Fast_Fall: int = 150
@export var Jump_Count: int = 3


signal JumpCloud
signal DashCloud
signal WallCloud
signal CounterCloud


func _ready():
	Speed *= Speed_Rating
func _physics_process(delta):
	move_and_slide()
	
	if !is_on_floor():
		velocity.y += Gravity

func _on_hurtbox_area_entered(area):
	pass # Replace with function body.


func _on_character_on_ground():
	Jump_Count = 3


func _on_character_is_stopping():
	velocity.x = move_toward(velocity.x , 0, Decceleration)


func _on_character_is_moving():
	var dir: int = Controller.direction.x
	velocity.x = move_toward(velocity.x , dir * Speed, Acceleration) 





func _on_character_is_dashing():
	pass # Replace with function body.


func _on_character_is_jumping():
	if Jump_Count > 0:
		if Controller.jump == true:
			emit_signal("JumpCloud")
			Jump_Count -= 1
			velocity.y = -Jump_Height
			Controller.jump = false


func _on_character_is_throwing():
	pass # Replace with function body.

