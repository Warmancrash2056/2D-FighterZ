class_name JumpCloud extends Marker2D

@onready var player = $".."
@onready var jump_audio = $"Character Jump Sound"
var jump_smoke = preload("res://Character Resouces/jump_cloud.tscn")
func _physics_process(delta):
	player.connect("JumpSmoke", _activate_jump_smoke)


func _activate_jump_smoke():
	jump_audio.play()
	var instance_smoke_jump = jump_smoke.instantiate()
	instance_smoke_jump.global_position = global_position
	get_tree().get_root().add_child(instance_smoke_jump)
