extends Area2D

@onready var collision_polygon = $CollisionPolygon2D
const structure_type = GameData.StructureType.DEFENSE

signal structure_selected(structure, structure_type: GameData.StructureType)

func _ready():
	connect("input_event", Callable(self, "_on_input_event"))

func get_structure_type():
	return structure_type

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		emit_signal("structure_selected", self, structure_type)
