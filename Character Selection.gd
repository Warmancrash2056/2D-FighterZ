extends Node

var Player1Selected 
var Player2Selected 
var gamelevel

enum{ Getplayer1, GetPlayer2, GetLevel, Manager}
var Manage = Manager
func change_state():
	match Manage:
		Getplayer1:
			if Button.pressed
