extends Area2D
class_name Structure

# OVERIDDEN IN CHILDREN
var structure_type = null

var sell_value: int = 0
var repair_cost: int = 0

signal structure_selected(structure)

func _ready() -> void:
	connect("input_event", Callable(self, "_on_input_event"))
	sell_value = GameData.get_structure_cost(structure_type)

func get_structure_type() -> GameData.StructureType:
	return structure_type

func get_sell_value() -> int:
	return sell_value

func get_repair_cost() -> int:
	return repair_cost

func _on_input_event(_viewport, event, _shape_idx) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		emit_signal("structure_selected", self)
