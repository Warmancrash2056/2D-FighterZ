class_name JumpCloud extends Marker2D

@export var Character: CharacterBody2D
@onready var jump_audio = $"Character Jump Sound"
var jump_smoke = preload("res://Character Resouces/jump_cloud.tscn")

func _process(delta):
	Character.connect("JumpSmoke", jump_cloud)
func jump_cloud():
	jump_audio.play()
	var instance_smoke_jump = jump_smoke.instantiate()
	instance_smoke_jump.global_position = global_position
	get_tree().get_root().add_child(instance_smoke_jump)

