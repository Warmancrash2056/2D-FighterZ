extends Node

var controller_connected = []
func _ready():
	pass
	
func _process(delta):
	controller_connected = Input.get_connected_joypads()
	if controller_connected.is_empty():
		print("No Controller Detected")
		
	else:
		print("Controller Detected", controller_connected)

# Function to detect whic controller has been removed
func _disconnected():
	pass
