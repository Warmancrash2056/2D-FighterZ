extends MarginContainer

@onready var Music_Slider = %"Music Slider"
@onready var Master_Slider = %"Master Volume Slider"
@onready var SFX_Slider = %"SFX Slider"
@onready var Window_Mode = %"Window Options"
@onready var Enable_Fps = $"TabContainer/Game/Fps Enabler"
@onready var V_Sync_Toggle = $"TabContainer/Game/V - Sync Enabler"
@onready var fps_visible = %"Fps Display"

var user_config: UserConfigurations


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	user_config = UserConfigurations.load_or_create()
	if Window_Mode:
		Window_Mode.select(user_config.window_mode)
	if Music_Slider:
		Music_Slider.value = user_config.Music_Audio_Level

	if Master_Slider:
		Master_Slider.value = user_config.Master_Audio_Level

	if SFX_Slider:
		SFX_Slider.value = user_config.Sfx_Audio_Level

	if Enable_Fps:
		Enable_Fps.button_pressed = user_config.Dislay_Fps
		fps_visible.visible = user_config.Dislay_Fps

	if V_Sync_Toggle:
		V_Sync_Toggle.button_pressed = user_config.v_Sync_enable
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fps_visible.text = str("Fps: ",Engine.get_frames_per_second())
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

	if user_config:
		user_config.v_Sync_enable = button_pressed
		user_config.save()
	print(button_pressed)
	if button_pressed == true:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)

	else:
		if button_pressed == false:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)



func _on_option_button_item_selected(index):
	if user_config:
		user_config.window_mode = index
		user_config.save()
	if index == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	if index == 1:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)

	if index == 2:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

	if index == 3:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)




func _on_check_box_button_pressed(button_pressed):
	if button_pressed == true:
		fps_visible.visible = true

	else:
		if button_pressed == false:
			fps_visible.visible = false

	if user_config:
		user_config.Dislay_Fps = button_pressed
		user_config.save()
