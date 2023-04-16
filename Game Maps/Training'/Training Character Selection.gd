extends Node2D

@onready var Player1 = $"Player 1 Cursor"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Player1.Player1Ready == true:
		
