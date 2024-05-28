class_name Player1 extends Area2D

@onready var Player = $'..'
signal Player1Setting

func _ready() -> void:
	Player1Setting.emit()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Force"):
		print("Attack is force")
		area.Damage
		area.Recovery_Time

	if area.is_in_group("Positioner"):
		print("Player is being moved to the hitbox")
		area.position = Player.global_position



func _on_player_1_setting() -> void:
	set_collision_layer_value(5, true)
	set_collision_mask_value(10, true)
