extends Area2D

var players_in_area = [] # List to keep track of players inside the area

func _ready():
	pass

func _process(delta):
	for player in players_in_area:
		# Here you can handle the logic for players inside the area
		print(player.name, " is at ", player.global_position)
