class_name Player2Setting extends Node2D

signal Player1Box
# Get the player controller node
@onready var Input_Controller: Node2D = $Controller
@onready var Movement_Controller: CharacterBody2D = $Controller/Character

func _ready() -> void:
	CharacterList.player_2_health = Movement_Controller.Health
	char

func _physics_process(delta: float) -> void:
	pass
