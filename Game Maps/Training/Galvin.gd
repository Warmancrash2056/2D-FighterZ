extends Node2D

var test_preload = preload("res://Character Resouces/Goku/Goku.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	var i = test_preload.instantiate()
	i.set_script("res://Character Resouces/Global/Controller Resource/Player 1 Controller.gd")
	i.position = Vector2(0, -148)
	
	call_deferred("add_child", i)

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
