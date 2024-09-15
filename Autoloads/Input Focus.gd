extends Node

var game_focused: bool = true

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			game_focused = false

		NOTIFICATION_APPLICATION_FOCUS_IN:
			game_focused = true

func input_is_action_pressed(action: StringName) -> bool:
	if game_focused:
		return input_is_action_pressed(action)

	return false


func event_is_action_pressed(event:InputEvent, action:StringName) -> bool:
	if game_focused:
		return event.is_action_pressed(action)

	return false
