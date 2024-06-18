class_name Hitbox extends Area2D

signal AttackConnected ## Signal to recovery timer to reduce the recovery timer.

@export var Sprite: Sprite2D

@export var Stun_Time: float ## Send the amount of time player is stunned to hitbox
@export var Damage: int
@export var Variable_Force: Vector2 ## Force added onto current player velocity
@export var Constant_Force: Vector2 ## Constant Force applied to player velocity
# Get the attacker direction in interger to change the direction of x-axis knockback force
var direction: bool


func _process(delta: float) -> void:
	direction = Sprite.flip_h


func _on_area_entered(area: Area2D) -> void:
	AttackConnected.emit()
