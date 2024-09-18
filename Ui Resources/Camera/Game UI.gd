extends CanvasLayer

@onready var Match_Time: Timer = $Timer
@onready var Match_Text: RichTextLabel = $RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Match_Time.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Match_Time.time_left > 0:
		if Match_Time.time_left < 100:
			Match_Text.text = str("0",int(Match_Time.time_left))

		if Match_Time.time_left <= 10:
			Match_Text.text = str("00",int(Match_Time.time_left))

		else:
			if Match_Time.time_left > 100:
				Match_Text.text = str(int(Match_Time.time_left))
	else:
		if Match_Time.time_left <= 0:
			Match_Text.text = str("000")


func _on_timer_timeout() -> void:
	pass # Replace with function body.
