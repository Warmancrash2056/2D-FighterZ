extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_action_break_animation_finished(anim_name):
	if anim_name == "Actions Exceeded":
		$"Action Break".play("Normal")
