class_name Player extends CharacterBody2D

signal JumpSmoke

func _physics_process(delta):
	jump()

func jump():
	emit_signal("JumpSmoke")
