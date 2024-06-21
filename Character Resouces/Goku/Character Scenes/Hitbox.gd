class_name Hitbox extends Area2D

signal AttackConnected

var transition_attack: bool = false
@export var Sprite: Sprite2D
@export var Stun_Time: float ## Send the amount of time player is stunned to hitbox
@export var Damage: int
@export var Variable_Force: Vector2 ## Force added onto current player velocity
@export var Constant_Force: Vector2 ## Constant Force applied to player velocity
# Get the attacker direction in interger to change the direction of x-axis knockback force
var direction: int

func _process(delta: float) -> void:
	direction = Sprite.flip_h
	AttackConnected.emit()


func _on_attack_connected() -> void:
	transition_attack = true



func _on_area_entered(area: Area2D) -> void:
	AttackConnected.emit()

