class_name Player1Setting extends Node2D

signal Player1Box
# Get the player controller node
@onready var Input_Controller: Node2D = $Controller
@onready var Movement_Controller: CharacterBody2D = $Controller/Character

func _ready() -> void:
	CharacterList.player_1_health = Movement_Controller.Health


func _physics_process(delta: float) -> void:
	pass
