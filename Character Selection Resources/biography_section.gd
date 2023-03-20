extends Control

#Biography Section 
@onready var AboutMe = $"About Me"
@onready var Biography = $Biography

# Chaeracter Animation
@onready var GeneralArchfieldAnimation = $"General Archfield"
@onready var NiaAnimation = $"Nia Animation"
@onready var GokuAnimation = $"Goku Animation"
@onready var HunterAnimation = $"Hunter Animation"
@onready var NomadAnimation = $"Nomad Animation"
@onready var AtlantisAnimation = $"Princess Atlantis Animation"




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	AboutMe.set_text(str("Text Set"))


func _on_button_pressed():
	get_tree().change_scene_to_file("res://Character Selection Resources/Character Selection Menu.tscn")
