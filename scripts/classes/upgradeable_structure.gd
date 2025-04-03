extends Structure
class_name UpgradeableStructure

# OVERIDDEN IN CHILDREN
var type_abbreviation: String = ""

var color: String = ""
var has_upgrade_1: bool = false
var has_upgrade_2: bool = false
var sell_value: int = 0
var repair_cost: int = 0

func _ready() -> void:
	super._ready()
	sell_value = GameData.get_structure_cost(structure_type)

func place():
	set_sprite(true)
	sprite.play(color + "_00")
	add_to_group(type_abbreviation + "_00")
	if type_abbreviation == "dt":
		find_child("DetectionArea").set_detection_radius()

func set_sprite(is_sprite_green: bool):
	is_green = is_sprite_green
	color = "g" if is_green else "r"

func handle_animation() -> void:
	if has_upgrade_1 and has_upgrade_2:
		sprite.play(color + "_11")
	elif has_upgrade_1:
		sprite.play(color + "_10")
	elif has_upgrade_2:
		sprite.play(color + "_01")

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
			handle_animation()
			sell_value += GameData.get_upgrade_cost(structure_type, upgrade_index)
		1:
			has_upgrade_2 = true
			handle_animation()
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
