extends Control

@onready var main_container = $MainContainer
@onready var hide_button = $HideButton
const HIDE_ICON = preload("res://assets/icons/icons8-chevron-down-64.png")
const SHOW_ICON = preload("res://assets/icons/icons8-chevron-up-64.png")

signal build_button_pressed(structure_type: GameData.StructureType)

func _ready():
	initialize_costs()

func _process(_delta) -> void:
	update_labels()

func initialize_costs():
	$MainContainer/MarginContainer/HBoxContainer/BuildAttackButton/HBoxContainer/Cost.text = "Cost: " + str(GameData.get_structure_cost(GameData.StructureType.ATTACK))
	$MainContainer/MarginContainer/HBoxContainer/BuildDefenseButton/HBoxContainer2/Cost.text = "Cost: " + str(GameData.get_structure_cost(GameData.StructureType.DEFENSE))
	$MainContainer/MarginContainer/HBoxContainer/BuildResourceButton/HBoxContainer/Cost.text = "Cost: " + str(GameData.get_structure_cost(GameData.StructureType.RESOURCE))

func update_labels():
	$SubContainer/HBoxContainer/AmmoCountLabel.text = str(PlayerData.ammo_count)

# BUTTON FUNCTIONS
func _on_hide_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		self.position.y += main_container.size.y
		hide_button.icon = SHOW_ICON
	else:
		self.position.y -= main_container.size.y
		hide_button.icon = HIDE_ICON

func _on_build_attack_button_pressed() -> void:
	emit_signal("build_button_pressed", GameData.StructureType.ATTACK)

func _on_build_defense_button_pressed() -> void:
	emit_signal("build_button_pressed", GameData.StructureType.DEFENSE)

func _on_build_resource_button_pressed() -> void:
	emit_signal("build_button_pressed", GameData.StructureType.RESOURCE)
