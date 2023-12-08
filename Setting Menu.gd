extends MarginContainer

@onready var Music_Slider = %"Music Slider"
@onready var Master_Slider = %"Master Volume Slider"
@onready var SFX_Slider = %"SFX Slider"

var user_config: UserConfigurations


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	user_config = UserConfigurations.load_or_create()
	if Music_Slider:
		Music_Slider.value = user_config.Music_Audio_Level

	if Master_Slider:
		Master_Slider.value = user_config.Master_Audio_Level
	
	if SFX_Slider:
		SFX_Slider.value = user_config.Sfx_Audio_Level
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if user_config.Music_Audio_Level <= 0.0:
		AudioServer.set_bus_mute(2, true)
		
	else:
		AudioServer.set_bus_mute(2, false)
	
	if user_config.Sfx_Audio_Level <= 0.0:
		AudioServer.set_bus_mute(1, true)
		
	else:
		AudioServer.set_bus_mute(1, false)
		
	if user_config.Master_Audio_Level <= 0.0:
		AudioServer.set_bus_mute(0, true)
		
	else:
		AudioServer.set_bus_mute(0, false)
		
	if Input.is_action_just_pressed("exit"):
		self.visible = !self.visible



func _on_master_volume_slider_value_changed(value):
	AudioServer.set_bus_volume_db(0, linear_to_db(value))
	
	if user_config:
		user_config.Master_Audio_Level = value
		user_config.save()

func _on_sfx_slider_value_changed(value):
	AudioServer.set_bus_volume_db(1, linear_to_db(value))
	
	if user_config:
		user_config.Sfx_Audio_Level = value
		user_config.save()

func _on_music_slider_value_changed(value):
	AudioServer.set_bus_volume_db(2, linear_to_db(value))
	if user_config:
		user_config.Music_Audio_Level = value
		user_config.save()

func _on_v__sync_enabler_toggled(button_pressed):
	pass


func _on_option_button_item_selected(index):
	if index == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED)
	if index == 1:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
	if index == 2:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
		
	if index == 3:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	
	if index == 4:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		
		
