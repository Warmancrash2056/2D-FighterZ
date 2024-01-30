class_name Jump extends Marker2D

@export var Character: CharacterBody2D
@export var Jump_Cloud = Resource

@onready var jump_audio = $"Character Jump Sound"
func _process(delta):
	Character.connect("JumpSmoke", _instance)
func _instance():
	jump_audio.play()
	var instance_smoke_jump = Jump_Cloud.instantiate()
	instance_smoke_jump.global_position = global_position
	get_tree().get_root().add_child(instance_smoke_jump)

