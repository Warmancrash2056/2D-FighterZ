class_name Player extends CharacterBody2D

@export var Controller: Node
@export var Animator: AnimationPlayer
@export var Sprite: Sprite2D
@export var Scaler: Node2D

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
	print(velocity.x)
	Speed *= Speed_Rating

func _physics_process(delta):
	print(velocity.x)
	move_and_slide()
	if is_attacking == false:
		if !is_on_floor():
			velocity.y += Gravity

func _on_hurtbox_area_entered(area):
	pass # Replace with function body.


func _on_character_on_ground():
	Jump_Count = 3


func _on_character_is_stopping():
	velocity.x = move_toward(velocity.x , 0, Decceleration)

func _on_character_is_dashing():
	pass # Replace with function body.


func _on_character_is_jumping():
	if Jump_Count > 0:
		Jump_Count -= 1
		JumpCloud.emit()
		velocity.y = -Jump_Height


func _on_character_is_throwing():
	pass # Replace with function body.


func _on_character_attack_friction(Friction):
	velocity.x = lerp(velocity.x , 0.0, Friction)


func _on_controller_is_jumping():
	if Jump_Count > 0:
		Jump_Count -= 1
		JumpCloud.emit()
		velocity.y = -Jump_Height


func _on_controller_is_stopping():
	velocity.x = move_toward(velocity.x , 0, Decceleration)




func _on_controller_is_moving(Vector):
	if Vector == 1:
			velocity.x = move_toward(velocity.x , Speed, Acceleration)

	else:
			velocity.x = move_toward(velocity.x , -Speed, Acceleration)

func _check_ground():
	var air_scaling


func _on_character_attack_moving_x(Vector: Variant) -> void:
	velocity.x = move_toward(velocity.x, Sprite.direction * Vector.x, 50)
