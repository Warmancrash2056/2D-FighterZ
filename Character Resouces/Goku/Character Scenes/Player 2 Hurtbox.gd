class_name Player2 extends Area2D

signal Player2Setting
signal Player2Hurt

func _ready() -> void:
	Player2Setting.emit()

func _on_area_entered(area: Area2D) -> void:
	pass # Replace with function body.


func _on_player_2_setting() -> void:
	set_collision_layer_value(9, true)
	set_collision_mask_value(6, true)
