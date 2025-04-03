extends Node


@onready var build_menu = $BuildMenu
@onready var upgrade_menu = $UpgradeMenu
@onready var command_menu = $CommandMenu
@onready var BuildHandler = $"../BuildHandler"

var selected_structure: Structure = null
var active_units: int = 0

signal command_received(command: String)
signal pause_button_pressed()


func _ready() -> void:
	SignalHandler.connect_signal(build_menu, self, "build_button_pressed")
	SignalHandler.connect_signal(upgrade_menu, self, "upgrade_button_pressed")
	SignalHandler.connect_signal(upgrade_menu, self, "sell_button_pressed")
	SignalHandler.connect_signal(command_menu, self, "command_button_pressed")

func _process(_delta) -> void:
	handle_deselect()

#region STRUCTURE SELECTION
func handle_deselect() -> void:
	if Input.is_action_pressed("cancel") and selected_structure:
		deselect_structure(selected_structure)
		selected_structure = null

func _on_structure_selected(structure: Structure) -> void:
	if structure.is_green:
		if selected_structure:
			deselect_structure(selected_structure)
		
		selected_structure = structure
		highlight_structure(selected_structure)
		build_menu.hide()
		if structure is UpgradeableStructure:
			upgrade_menu.show()
			upgrade_menu.initialize_buttons(structure)
		if structure.get_structure_type() == GameData.StructureType.COMMAND:
			command_menu.show()

func highlight_structure(structure: Structure) -> void:
	structure.find_child("Highlight").show()

func deselect_structure(structure: Structure) -> void:
	structure.find_child("Highlight").hide()
	if structure is UpgradeableStructure:
		upgrade_menu.hide()
	if structure.get_structure_type() == GameData.StructureType.COMMAND:
		command_menu.hide()
	build_menu.show()
#endregion

#region BUTTONS PRESSED
func _on_build_button_pressed(structure_type: GameData.StructureType) -> void:
	if not BuildHandler.structure_instance:
		BuildHandler.start_placement(structure_type)
	else:
		BuildHandler.cancel_placement()
		BuildHandler.start_placement(structure_type)

func _on_upgrade_button_pressed(upgrade_index: int) -> void:
	if selected_structure:
		if GameData.get_upgrade_cost(selected_structure.structure_type, upgrade_index) <= PlayerData.ammo_count:
			PlayerData.ammo_count -= GameData.get_upgrade_cost(selected_structure.structure_type, upgrade_index)
			selected_structure.set_upgrade(upgrade_index)

func _on_sell_button_pressed(structure: Structure) -> void:
	PlayerData.ammo_count += structure.get_sell_value()
	deselect_structure(structure)
	structure.queue_free()

func _on_command_button_pressed(command: String) -> void:
	match command:
		"ATTACK":
			emit_signal("command_received", command)
		"DEFEND":
			emit_signal("command_received", command)
		"RETREAT":
			emit_signal("command_received", command)
		_:
			print("UIHandler: invalid command: " + command)

func _on_pause_button_pressed() -> void:
	emit_signal("pause_button_pressed")

func _on_exit_button_pressed() -> void:
	get_tree().quit()
#endregion
