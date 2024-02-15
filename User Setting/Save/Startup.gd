extends Node
# Set the user setting at the beggining of game. #
var user_config: UserConfigurations
func _ready():
	user_config = UserConfigurations.load_or_create()
	
	if user_config:
		if user_config.window_mode == 0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		if user_config.window_mode == 1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
			
		if user_config.window_mode == 2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			
		if user_config.window_mode == 3:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		
		if user_config.v_Sync_enable == true:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
			
		if user_config.v_Sync_enable == false:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
