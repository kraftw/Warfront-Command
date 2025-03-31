extends Area2D
class_name Structure

@onready var sprite = $Sprite2D

# OVERIDDEN IN CHILDREN
var structure_type: GameData.StructureType = GameData.StructureType.GENERIC
var type_abbreviation: String = ""

var has_upgrade_1: bool = false
var has_upgrade_2: bool = false
var sell_value: int = GameData.get_structure_cost(structure_type)
var repair_cost: int = 0

signal structure_selected(structure)

func _ready() -> void:
	connect("input_event", Callable(self, "_on_input_event"))
	sprite.play("00")
	add_to_group(type_abbreviation + "_00")

func _process(_delta: float) -> void:
	handle_animation()

func handle_animation() -> void:
	if has_upgrade_1 and has_upgrade_2:
		sprite.play("11")
	elif has_upgrade_1:
		sprite.play("10")
	elif has_upgrade_2:
		sprite.play("01")

func get_structure_type() -> GameData.StructureType:
	return structure_type

func get_sell_value() -> int:
	return sell_value

func get_repair_cost() -> int:
	return repair_cost

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

func _on_input_event(_viewport, event, _shape_idx) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		emit_signal("structure_selected", self)
