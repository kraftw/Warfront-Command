extends Area2D

@onready var sprite = $Sprite2D

const structure_type = GameData.StructureType.ATTACK

var has_upgrade_1: bool = false
var has_upgrade_2: bool = false
var sell_value: int = GameData.get_structure_cost(structure_type)
var repair_cost: int = 0

signal structure_selected(structure)

func _ready():
	connect("input_event", Callable(self, "_on_input_event"))
	sprite.play("00")
	add_to_group("b_00")

func _process(_delta: float) -> void:
	handle_animation()

func handle_animation():
	if has_upgrade_1 and has_upgrade_2:
		sprite.play("11")
	elif has_upgrade_1:
		sprite.play("10")
	elif has_upgrade_2:
		sprite.play("01")

func get_structure_type():
	return structure_type

func get_sell_value():
	return sell_value

func get_repair_cost():
	return repair_cost

func set_upgrade(upgrade_index):
	match upgrade_index:
		0:
			has_upgrade_1 = true
			sell_value += GameData.get_upgrade_cost(structure_type, upgrade_index)
		1:
			has_upgrade_2 = true
			sell_value += GameData.get_upgrade_cost(structure_type, upgrade_index)
	
	# GROUPS:
	# b_00, b_01, b_10, b_11
	if has_upgrade_1 and has_upgrade_2:
		add_to_group("b_11")
		remove_from_group("b_01")
		remove_from_group("b_10")
		remove_from_group("b_00")
	elif has_upgrade_1:
		add_to_group("b_10")
		remove_from_group("b_01")
		remove_from_group("b_11")
		remove_from_group("b_00")
	elif has_upgrade_2:
		add_to_group("b_01")
		remove_from_group("b_11")
		remove_from_group("b_10")
		remove_from_group("b_00")

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		emit_signal("structure_selected", self)
