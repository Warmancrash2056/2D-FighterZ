class_name UserConfigurations extends Resource

@export_range(0.0, 1.0, .01) var Music_Audio_Level: float = 1.0
@export_range(0.0, 1.0, .01) var Sfx_Audio_Level: float = 1.0
@export_range(0.0, 1.0, .01) var Master_Audio_Level: float = 1.0
@export var window_mode: int = 1
@export var v_Sync_enable: bool = false
@export var Dislay_Fps: bool = false
func save() -> void:
	ResourceSaver.save(self, "user://user_prefs.tres")


static func load_or_create() -> UserConfigurations:
	var res: UserConfigurations = load("user://user_prefs.tres") as UserConfigurations
	if !res:
		res = UserConfigurations.new()
	return res
