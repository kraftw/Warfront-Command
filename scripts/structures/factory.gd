extends Node2D

@onready var sprite = $Sprite2D
@onready var collision_polygon = $CollisionShape2D
const structure_type = GameData.StructureType.RESOURCE

signal structure_selected(structure, structure_type: GameData.StructureType)

func _process(_delta: float) -> void:
	handle_animation()

func _ready():
	connect("input_event", Callable(self, "_on_input_event"))

func handle_animation():
	if GameData.is_game_running:
		sprite.play()
	else:
		sprite.stop()

func get_structure_type():
	return structure_type

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		emit_signal("structure_selected", self, structure_type)
