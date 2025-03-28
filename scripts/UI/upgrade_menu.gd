extends Control

@onready var upgrade_button_1 = $MainContainer/MarginContainer/HBoxContainer/UpgradeButton1
@onready var upgrade_button_2 = $MainContainer/MarginContainer/HBoxContainer/UpgradeButton2
@onready var repair_button = $MainContainer/MarginContainer/HBoxContainer/VBoxContainer/RepairButton
@onready var sell_button = $MainContainer/MarginContainer/HBoxContainer/VBoxContainer/SellButton

func _process(_delta: float) -> void:
	update_ammo_count()

func update_ammo_count():
	$SubContainer/HBoxContainer/AmmoCountLabel.text = str(PlayerData.ammo_count)

func update_buttons(structure_type: GameData.StructureType):
	update_button(structure_type, 0)
	update_button(structure_type, 1)
	find_child("RepairButton").text = "Repair Cost: " + str(0 / GameData.get_structure_cost(structure_type)) # replace 0 with building health eventually
	find_child("SellButton").text = "Sell Value: " + str(GameData.get_structure_cost(structure_type))

func update_button(structure_type: GameData.StructureType, index: int):
	match index:
		0:
			upgrade_button_1.find_child("UpgradeIcon").texture = GameData.get_upgrade_icon(structure_type, index)
			upgrade_button_1.find_child("UpgradeName").text = GameData.get_upgrade_name(structure_type, index)
			upgrade_button_1.find_child("UpgradeCost").text = "Cost: " + str(GameData.get_upgrade_cost(structure_type, index))
		1:
			upgrade_button_2.find_child("UpgradeIcon").texture = GameData.get_upgrade_icon(structure_type, index)
			upgrade_button_2.find_child("UpgradeName").text = GameData.get_upgrade_name(structure_type, index)
			upgrade_button_2.find_child("UpgradeCost").text = "Cost: " + str(GameData.get_upgrade_cost(structure_type, index))
