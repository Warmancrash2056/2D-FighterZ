extends Control

@onready var volume_change = Audio.volume_db

@onready var volume_down = $"Volume Down"
@onready var volume_up = $"Volume Up"

# Called when the node enters the scene tree for the first time.
func _ready():
	Audio._character_select_play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(Audio.volume_db)
	# Default Audio volume is 5/ 50%
	$ProgressBar.value = Audio.volume_db
	
	if Input.is_action_just_pressed("Player1_Left"):
		Audio.volume_db -= 1
		
		
	if Input.is_action_just_pressed("Player1_Right"):
		Audio.volume_db += 1
		
		
	
	


func _on_volume_down_pressed():
	Audio.volume_db -= 1


func _on_volume_up_pressed():
	Audio.volume_db += 1
