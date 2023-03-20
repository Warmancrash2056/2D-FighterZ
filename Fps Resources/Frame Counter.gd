extends Control

@onready var ShowFps = $RichTextLabel

func _physics_process(delta):
	ShowFps.set_text("Max Frames: " + str(Engine.get_frames_per_second()))
