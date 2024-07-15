extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureProgressBar.value = CharacterList.player_2_health
	$Sprite2D.texture = CharacterList.player_2_icon


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	#print(CharacterList.player_2_health)
	$TextureProgressBar.value = CharacterList.player_2_health
	$Sprite2D.texture = CharacterList.player_1_icon

