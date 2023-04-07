extends Node2D

@export var Controller: Resource

@onready var MapName = $RichTextLabel
@onready var Galvin = $Galvin
@onready var Artic = $Artic

enum Map{
	Galvin,
	Artic
}
var MapCall = Map.Galvin
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match MapCall:
		Map.Galvin:
			MapName.set_text(str("Galvin"))
			Galvin.visible = true
			Artic.visible = false
			if Input.is_action_just_pressed(Controller.input_right):
				MapCall = Map.Artic
				Galvin.visible = false
				Artic.visible = true
				
			elif Input.is_action_just_pressed(Controller.input_left):
				MapCall = Map.Artic
				Galvin.visible = false
				Artic.visible = true
				
			#if Input.is_action_just_pressed(Controller.Input_jump):
				#get_tree().change_scene_to_file("res://Game Maps/Galvin.tscn")
				
		Map.Artic:
			MapName.set_text(str("Artic"))
			Artic.visible = true
			Galvin.visible = false
			if Input.is_action_just_pressed(Controller.input_right):
				MapCall = Map.Galvin
				Artic.visible = false
				Galvin.visible = true
				
			elif Input.is_action_just_pressed(Controller.input_left):
				MapCall = Map.Galvin
				Artic.visible = false
				Galvin.visible = true
			
			if Input.is_action_just_pressed(Controller.input_jump):
				get_tree().change_scene_to_file("res://The Artic.tscn")
