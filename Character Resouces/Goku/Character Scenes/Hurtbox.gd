extends Area2D

@export var Character:CharacterBody2D
@export var Player_Stats: Node

var knockback_multiplier: float
signal IsHurt(Damage: int)

func _on_area_entered(area: Area2D) -> void:
	var stun_time: float = area.Stun_Time
	var Damage: int = area.Damage
	var knockback_x: int = area.Knockback_X
	var knockback_y: int = area.Knockback_Y
	IsHurt.emit(Damage)


func _on_is_hurt(Damage: int) -> void:
	print(Player_Stats.Health)
	Player_Stats.Health -= Damage
	if Player_Stats.Health < 1000:
		knockback_multiplier = 0.50

	if Player_Stats.Health < 800:
		knockback_multiplier = 0.65

	if Player_Stats.Health < 600:
		knockback_multiplier = 0.75

	if Player_Stats.Health < 550:
		knockback_multiplier = 1.0

	if Player_Stats.Health < 390:
		knockback_multiplier = 1.25

	if Player_Stats.Health < 200:
		knockback_multiplier = 1.45

	if Player_Stats.Health < 0:
		knockback_multiplier = 2.0

