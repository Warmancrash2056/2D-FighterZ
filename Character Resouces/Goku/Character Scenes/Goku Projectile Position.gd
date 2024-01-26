extends Marker2D
@export var air_projectile: Resource
@export var ground_projectile: Resource
@export var sprite = Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if sprite.flip_h == false:
		print("IS fACING rIGHT")
		
	else:
		print("Is Facing Left")
func _activate_projectile():
	
	if owner.is_on_floor():
		print("Projectile on ground")
	else:
		print("Projectile on air")

func _air_projectile():
	var i = air_projectile
