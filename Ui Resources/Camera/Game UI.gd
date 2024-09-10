extends CanvasLayer

@onready var Match_Time: Timer = $Timer
@onready var Match_Text: RichTextLabel = $RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Match_Time.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Match_Time.time_left <= 0:
		Match_Text.set_text("000")

	else:
		Match_Text.set_text(str(int(Match_Time.time_left)))
