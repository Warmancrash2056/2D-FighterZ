extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("exit"):
		self.visible = !self.visible



func _on_master_volume_slider_value_changed(value):
	pass # Replace with function body.


func _on_sfx_slider_value_changed(value):
	pass # Replace with function body.


func _on_music_slider_value_changed(value):
	pass # Replace with function body.


func _on_v__sync_enabler_toggled(button_pressed):
	pass # Replace with function body.


func _on_option_button_item_selected(index):
	if index == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		print("windowed")
	if index == 1:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
		
	if index == 2:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		
	if index == 3:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		
		
