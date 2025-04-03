extends Area2D
class_name Structure

@onready var sprite: AnimatedSprite2D = $Sprite2D

# OVERIDDEN IN CHILDREN
var structure_type = null
var is_green: bool = false

signal structure_selected(structure)

func _ready() -> void:
	connect("input_event", Callable(self, "_on_input_event"))

func set_sprite(is_sprite_green: bool):
	is_green = is_sprite_green
	if structure_type == GameData.StructureType.COMMAND:
		var color = "green" if is_green else "red"
		sprite.play(color)

func get_structure_type() -> GameData.StructureType:
	return structure_type

func _on_input_event(_viewport, event, _shape_idx) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		emit_signal("structure_selected", self)
