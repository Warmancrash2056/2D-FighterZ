extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(0.1).timeout
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_entered(area):
	CharacterList.goku_side_start_transition = true
	print("Goku side attack hit")
