extends Area2D

@export var Animator: AnimationPlayer
@export var Sprite: Sprite2D
@onready var Player_Stats = $'../../Player Stats'
@export var Character: RigidBody2D
## Send the amount of time player is stunned to hitbox.
## Attack by default are 15 - 30 frames and Heavy are 30 - 60 frames
@export_range(1, 1000, 1) var Recovery_Frames: int
@export_range(1, 1000, 1) var Damage: float
@export var Variable_Force: Vector2 ## Force added onto current player velocity
@export var Constant_Force: Vector2 ## Constant Force applied to player velocity

# Get the attacker direction in interger to change the direction of x-axis knockback force
var direction: bool

func _on_area_entered(area:Area2D):
	Character.linear_velocity.x = 0


func _on_body_entered(body:Node2D):
	#Character.linear_velocity.x = 0
	pass
