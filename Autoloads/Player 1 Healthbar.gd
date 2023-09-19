extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$ProgressBar.value = CharacterList.player_1_health
	$Sprite2D.texture = CharacterList.icon


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$ProgressBar.value = CharacterList.player_1_health
	
	
	if CharacterList.goku_selected == true:
		$Sprite2D.texture = load("res://Character Resouces/Goku/Icon/Goku.png")
	
	if CharacterList.sakura_selected == true:
		$prite.texture = load("res://Character Resouces/Sakura/Icon/Assasin Character Icon.png")
