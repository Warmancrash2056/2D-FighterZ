extends Marker2D

@export var Jump_Cloud: Resource
@export var Character: CharacterBody2D
@export var Jump_Sound: AudioStreamPlayer2D


func _on_controller_jump_cloud():
	var instance_jump_cloud = Jump_Cloud.instantiate()
	instance_jump_cloud.global_position = global_position
	get_tree().get_root().add_child(instance_jump_cloud)
	Jump_Sound.play()

