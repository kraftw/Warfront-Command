extends Control

@onready var main_container = $MainContainer
@onready var button_container = $ButtonContainer
@onready var hide_icon = preload("res://assets/icons/icons8-chevron-down-64.png")
@onready var show_icon = preload("res://assets/icons/icons8-chevron-up-64.png")

func _on_hide_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		self.position.y += main_container.size.y
		button_container.get_child(0).icon = show_icon
	else:
		self.position.y -= main_container.size.y
		button_container.get_child(0).icon = hide_icon
