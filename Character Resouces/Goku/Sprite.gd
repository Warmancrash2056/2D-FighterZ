extends Sprite2D

var direction = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if flip_h == false:
		direction = 1

	else:
		direction = -1


func _on_character_facing_left():
	flip_h = true


func _on_character_facing_right():
	flip_h = false


func _on_controller_facing_left():
	flip_h = true


func _on_controller_facing_right():
	flip_h = false
