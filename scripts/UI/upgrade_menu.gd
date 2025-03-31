extends Control

@onready var upgrade_button_1 = $MainContainer/MarginContainer/HBoxContainer/UpgradeButton1
@onready var upgrade_button_2 = $MainContainer/MarginContainer/HBoxContainer/UpgradeButton2
@onready var repair_button = $MainContainer/MarginContainer/HBoxContainer/VBoxContainer/RepairButton
@onready var sell_button = $MainContainer/MarginContainer/HBoxContainer/VBoxContainer/SellButton

var local_structure_type = null
var selected_structure = null

signal upgrade_button_pressed(upgrade_index: int)
signal sell_button_pressed(selected_structure)

func _process(_delta: float) -> void:
	update_ammo_count()
	update_buttons()

func update_ammo_count():
	$SubContainer/HBoxContainer/AmmoCountLabel.text = str(PlayerData.ammo_count)

func update_buttons():
	if selected_structure:
		find_child("SellButton").text = "Sell Value: " + str(selected_structure.get_sell_value())
		find_child("RepairButton").text = "Repair Cost: " + str(selected_structure.get_repair_cost()) # replace 0 with building health eventually
		if selected_structure.has_upgrade_1:
			upgrade_button_1.disabled = true
		else:
			upgrade_button_1.disabled = false
		if selected_structure.has_upgrade_2:
			upgrade_button_2.disabled = true
		else:
			upgrade_button_2.disabled = false

func initialize_buttons(structure):
	local_structure_type = structure.get_structure_type()
	selected_structure = structure
	initialize_button(local_structure_type, 0)
	initialize_button(local_structure_type, 1)

func initialize_button(structure_type: GameData.StructureType, index: int):
	match index:
		0:
			upgrade_button_1.find_child("UpgradeIcon").texture = GameData.get_upgrade_icon(structure_type, index)
			upgrade_button_1.find_child("UpgradeName").text = GameData.get_upgrade_name(structure_type, index)
			upgrade_button_1.find_child("UpgradeCost").text = "Cost: " + str(GameData.get_upgrade_cost(structure_type, index))
		1:
			upgrade_button_2.find_child("UpgradeIcon").texture = GameData.get_upgrade_icon(structure_type, index)
			upgrade_button_2.find_child("UpgradeName").text = GameData.get_upgrade_name(structure_type, index)
			upgrade_button_2.find_child("UpgradeCost").text = "Cost: " + str(GameData.get_upgrade_cost(structure_type, index))

#region SIGNAL FUNCTIONS
func _on_upgrade_button_1_pressed() -> void:
	emit_signal("upgrade_button_pressed", 0)

func _on_upgrade_button_2_pressed() -> void:
	emit_signal("upgrade_button_pressed", 1)

func _on_sell_button_pressed() -> void:
	emit_signal("sell_button_pressed", selected_structure)
#endregion
