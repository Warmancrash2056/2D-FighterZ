extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureProgressBar.value = CharacterList.player_2_health
	$Sprite2D.texture = CharacterList.icon


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$TextureProgressBar.value = CharacterList.player_2_health
	
	
	if CharacterList.goku_selected == true:
		$Sprite2D.texture = load("res://Character Resouces/Goku/Icon/Goku.png")
	
	if CharacterList.sakura_selected == true:
		$Sprite2D.texture = load("res://Character Resouces/Sakura/Icon/Assasin Character Icon.png")
