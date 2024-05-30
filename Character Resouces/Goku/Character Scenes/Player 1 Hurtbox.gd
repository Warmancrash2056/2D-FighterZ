class_name Player1 extends Area2D

@onready var Player = $'..'
signal Player1Setting

func _process(delta: float) -> void:
	Player1Setting.emit()

func _on_area_entered(area: Area2D) -> void:
	print("Attack is force")
	if area.is_in_group("Force"):
		print("Attack is force")
		area.Damage
		area.Recovery_Time
		print("Player 1 hit by player 2.")

	if area.is_in_group("Positioner"):
		print("Player is being moved to the hitbox")
		area.position = Player.global_position



func _on_player_1_setting() -> void:
	pass
