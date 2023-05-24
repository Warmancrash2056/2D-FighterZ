extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _process(delta):
	set_text(str(Engine.get_frames_per_second()," Fps"))
