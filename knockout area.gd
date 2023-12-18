extends Area2D

var players_in_area = [] # List to keep track of players inside the area

func _ready():
	pass

func _process(delta):
	for player in players_in_area:
		# Here you can handle the logic for players inside the area
		print(player.name, " is at ", player.global_position)

func _on_body_entered(body):
	if body is Player1 or body is Player2:
		players_in_area.append(body) # Add the player to the list

func _on_body_exited(body):
	if body in players_in_area:
		players_in_area.erase(body) # Remove the player from the list
