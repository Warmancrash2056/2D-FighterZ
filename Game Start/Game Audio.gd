extends AudioStreamPlayer2D


# Called when the node enters the scene tree for the first time.
func _ready():
	play()
	volume_db = 10


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $CheckButton.button_pressed == true:
		stream_paused = true
		
	else:
		stream_paused = false


func _on_finished():
	play()



func _on_volume_down_pressed():
	volume_db -= 2

	if volume_db >= 20:
		volume_db = 20
func _on_volume_up_pressed():
	volume_db += 2
	
	if volume_db == 0:
		volume_db = 0
