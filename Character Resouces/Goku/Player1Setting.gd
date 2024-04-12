class_name Player1Setting extends Node2D

signal Player1Box # Set the hitbox and hurtbox of player.
# Get the player controller node
@onready var Input_Controller: Node2D = $Controller
@onready var Movement_Controller: CharacterBody2D = $Controller/Character
@onready var Player_Indicator = $'Controller/Character/Scale Player/Player Indicator'
@onready var display_player_icon: Node = $'Player Icon'

var Controler: Resource = preload("res://Character Resouces/Global/Controller Resource/Keyboard_WASD.tres")


func _ready() -> void:
	CharacterList.player_1_health = Movement_Controller.Health
	Player1Box.emit()



func _physics_process(delta: float) -> void:
	CharacterList.player_1_health = Movement_Controller.Health
	CharacterList.player_1_icon = display_player_icon.Icon
