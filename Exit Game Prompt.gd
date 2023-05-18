extends Control

@onready var leave_game = $"Leave Game"
@onready var return_game = $"Return to menu"



func _on_leave_game_pressed():
	get_tree().quit()
