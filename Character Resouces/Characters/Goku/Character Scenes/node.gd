extends Node2D

@onready var Floor_1 = $RayCast2D
@onready var Floor_2 = $RayCast2D2
@onready var Floor_3 = $RayCast2D3

func _process(delta: float) -> void:
	var onground = false

	if Floor_1.is_colliding():
		onground = true

	else:
		onground = false


	print(onground)
