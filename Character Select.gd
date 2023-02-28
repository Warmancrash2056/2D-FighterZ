extends Control

export var GetController_Player1 :Resource = preload("res://Global/Player_1.tres")
export var GetController_Player2 :Resource = preload("res://Global/Player_2.tres")

onready var Player1Cursor = $"Player 1 Cursor"
onready var Player2Cursor = $"Player 2 Cursor"

# Player 1 dictionationary to store the character placements #
var PlayerCharacter1 = []

# Get the current row and columm suing w + d move 1 spot back or forth from the current player spot. #
var Player1CurrentSelected = 0
var Player1CurrentRowSpot = 0 #  Move on the X-Axis
var Player1CurrentCollummSpot = 0 

var Player2CurrentSelected = 0
var Player2CurrentRowSpot = 0 #  Move on the X-Axis
var Player2CurrentCollummSpot = 0 
