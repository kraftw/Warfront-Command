extends Structure
class_name UpgradeableStructure

@onready var sprite = $Sprite2D

# OVERIDDEN IN CHILDREN
var type_abbreviation: String = ""

var has_upgrade_1: bool = false
var has_upgrade_2: bool = false
var sell_value: int = 0
var repair_cost: int = 0

func _ready() -> void:
	super._ready()
	sprite.play("00")
	sell_value = GameData.get_structure_cost(structure_type)

func _process(_delta: float) -> void:
	handle_animation()

func place():
	add_to_group(type_abbreviation + "_00")

func handle_animation() -> void:
	if has_upgrade_1 and has_upgrade_2:
		sprite.play("11")
	elif has_upgrade_1:
		sprite.play("10")
	elif has_upgrade_2:
		sprite.play("01")

#region GETTER FUNCTIONS
func get_sell_value() -> int:
	return sell_value

func get_repair_cost() -> int:
	return repair_cost
#endregion

#region UPGRADE FUNCTIONS
func set_upgrade(upgrade_index) -> void:
	match upgrade_index:
		0:
			has_upgrade_1 = true
			sell_value += GameData.get_upgrade_cost(structure_type, upgrade_index)
		1:
			has_upgrade_2 = true
			sell_value += GameData.get_upgrade_cost(structure_type, upgrade_index)
	
	update_groups()

func update_groups() -> void:
	remove_from_group(type_abbreviation + "_00")
	remove_from_group(type_abbreviation + "_01")
	remove_from_group(type_abbreviation + "_10")
	remove_from_group(type_abbreviation + "_11")

	if has_upgrade_1 and has_upgrade_2:
		add_to_group(type_abbreviation + "_11")
	elif has_upgrade_1:
		add_to_group(type_abbreviation + "_10")
	elif has_upgrade_2:
		add_to_group(type_abbreviation + "_01")
	else:
		add_to_group(type_abbreviation + "_00")
#endregion
