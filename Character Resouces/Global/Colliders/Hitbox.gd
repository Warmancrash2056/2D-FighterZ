class_name Hitbox extends Area2D

signal AttackConnected

var transition_attack: bool = false

@export var Animator: AnimationPlayer
@export var Sprite: Sprite2D
@export var Recovery_Frames: int ## Send the amount of time player is stunned to hitbox
@export var Damage: float
@export var Variable_Force: Vector2 ## Force added onto current player velocity
@export var Constant_Force: Vector2 ## Constant Force applied to player velocity
# Get the attacker direction in interger to change the direction of x-axis knockback force
var direction: int

func _process(delta: float) -> void:
	direction = Sprite.flip_h


## Make Sure the name of signal is the same for every hitbox to register.
func _on_attack_connected() -> void:
	pass


func _on_area_entered(area: Area2D) -> void:
	AttackConnected.emit()
