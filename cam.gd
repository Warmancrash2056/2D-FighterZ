extends Camera2D

@onready var status_bar = $MarginContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if zoom <= Vector2(1.7,1.7):
		status_bar.position = Vector2(216,-192)
		
	if zoom <= Vector2(1.65,1.65):
		status_bar.position = Vector2(229,-196)
		
	if zoom <= Vector2(1.5,1.5):
		status_bar.position = Vector2(256,-216)
		
	if zoom <= Vector2(1.45,1.45):
		status_bar.position = Vector2(280,-224)
	
	if zoom <= Vector2(1.36,1.36):
		status_bar.position = Vector2(304,-240)
	
	if zoom <= Vector2(1.25,1.25):
		status_bar.position = Vector2(360,-272)
	
	if zoom <= Vector2(1.24,1.24):
		status_bar.position = Vector2(344,-264)
		
	if zoom <= Vector2(1.15,1.15):
		status_bar.position = Vector2(400,-296)
		
	if zoom <= Vector2(1.07,1.07):
		status_bar.position = Vector2(432,-312)
		
	if zoom <= Vector2(1.0,1.0):
		status_bar.position = Vector2(456,-320)
