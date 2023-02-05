extends Control

onready var Player1Monk = $"Player 1/The Monk"

var Player1Selected = load("res://Character Resouces/The Monk/Player.tscn")
var Player2Selected 
var gamelevel

enum{ Getplayer1, GetPlayer2, GetLevel, Manager}
var Manage = Manager
func _process(delta):
	match Manage:
		Getplayer1:
			if Player1Monk.pressed == true:
				Player1Selected = load("res://Character Resouces/The Monk/Player.tscn")

		GetPlayer2:
			if $"Player 2/The Monk".pressed == true:
				Player2Selected = load("res://Character Resouces/Princess/Player 2.tscn")
				
