extends Control

@onready var infantry_count_label = $SubContainer/HBoxContainer/Infantry/InfantryCountLabel
@onready var colonel_count_label = $SubContainer/HBoxContainer/Colonel/ColonelCountLabel
@onready var attack_button = $MainContainer/MarginContainer/HBoxContainer/AttackButton
@onready var defend_button = $MainContainer/MarginContainer/HBoxContainer/DefendButton
@onready var retreat_button = $MainContainer/MarginContainer/HBoxContainer/RetreatButton

signal command_button_pressed(command: String)

func _process(_delta: float) -> void:
	update_unit_counts()

func update_unit_counts() -> void:
	infantry_count_label.text = str(PlayerData.infantry_count)
	colonel_count_label.text = str(PlayerData.colonel_count)

func _on_attack_button_pressed() -> void:
	emit_signal("command_button_pressed", "ATTACK")

func _on_defend_button_pressed() -> void:
	emit_signal("command_button_pressed", "DEFEND")

func _on_retreat_button_pressed() -> void:
	emit_signal("command_button_pressed", "RETREAT")
