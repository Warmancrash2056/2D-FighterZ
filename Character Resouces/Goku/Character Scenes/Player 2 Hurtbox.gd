class_name Player2 extends Area2D
@onready var Player = $'..'
signal Player2Setting
signal Player2Hurt

func _ready() -> void:
	Player2Setting.emit()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Force"):
		print("Attack is force")
		area.Damage
		area.Recovery_Time
		print("Player 2 hit by player 1.")

	if area.is_in_group("Positioner"):
		print("Player is being moved to the hitbox")
		area.position = Player.global_position
		print("Player 2 hit by player 1.")


func _on_player_2_setting() -> void:
	set_collision_layer_value(9, true)
	set_collision_mask_value(6, true)
