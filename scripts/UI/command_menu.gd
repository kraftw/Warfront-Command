extends Control

@onready var infantry_count_label = $SubContainer/HBoxContainer/Infantry/InfantryCountLabel
@onready var colonel_count_label = $SubContainer/HBoxContainer/Colonel/ColonelCountLabel

func _process(_delta: float) -> void:
	update_unit_counts()

func update_unit_counts() -> void:
	infantry_count_label.text = str(PlayerData.infantry_count)
	colonel_count_label.text = str(PlayerData.colonel_count)
