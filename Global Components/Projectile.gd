extends Marker2D
@export var air_projectile: Resource
@export var ground_projectile: Resource
@export var sprite = Sprite2D
@export var Character: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Character.connect("ShootProjectile", _projectile)
func _projectile():
	if Character.is_on_floor():
		_activate_ground_projectile()
		
	else:
		if !Character.is_on_floor():
			activate_air_projectile()
func _activate_ground_projectile():
	var i = ground_projectile
	
func activate_air_projectile():
	var i = air_projectile
