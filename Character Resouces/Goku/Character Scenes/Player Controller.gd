extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PROCESS_MODE_INHERIT


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	process_mode = 0
