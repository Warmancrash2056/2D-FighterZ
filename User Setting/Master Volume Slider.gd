extends HSlider

@export var bus_id: String

var bus_index: int 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	bus_index = AudioServer.get_bus_index(bus_id)
	
	AudioServer.get_bus_volume_db(db_to_linear(value))
