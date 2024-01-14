extends Node

@onready var controller = $"../Controller"
# Called when the node enters the scene tree for the first time.
func _ready():
	add_


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(controller.Player_Controller)
