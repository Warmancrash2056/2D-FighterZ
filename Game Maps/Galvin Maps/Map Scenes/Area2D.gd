extends Area2D
var player1 = Player1
var player2 = Player2
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass






func _on_body_entered(body):
	if body is Player1:
		print(body.global_position)
		
	if body is Player2:
		print(body.global_position)
	
	


		
