extends Area2D

signal mouse_entered_player_side()
signal mouse_exited_player_side()

func _on_mouse_entered() -> void:
	emit_signal("mouse_entered_player_side")

func _on_mouse_exited() -> void:
	emit_signal("mouse_exited_player_side")
