extends Node2D

var dummy = preload("res://Dummy.tscn")
var player = preload("res://Character Resouces/Goku/Character Scenes/Goku.tscn")
func _respawn_dummy():
	var i = dummy.instantiate()
	await get_tree().create_timer(1).timeout
	i.global_position = Vector2(488,232)
	get_tree().get_root().add_child(i)
	
func player_respawn():
	var i = player.instantiate()
	get_tree().get_root().queue_free()
func _on_area_2d_area_entered(area):
	pass





func _on_area_2d_body_entered(body):
	if body.is_in_group("Goku"):
		player_respawn()
