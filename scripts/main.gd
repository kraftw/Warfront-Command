extends Node2D

#region EXPORT VARIABLES
@export var tick_interval: float = 0.5
@export var base_factory_interval: float = 2.5
@export var base_factory_generation_amount: int = 25
@export var upgraded_factory_interval: float = 1.5
@export var upgraded_factory_generation_amount: int = 50
@export var barracks_interval: float = 3.5
#endregion

#region ONREADY VARIABLES
@onready var build_menu = $HUD/BuildMenu
@onready var upgrade_menu = $HUD/UpgradeMenu
@onready var player_side = $Background/PlayerSide
@onready var opponent_side = $Background/OpponentSide
@onready var game_timer = $GameTimer
#endregion

#region REGULAR VARIABLES
var structure_instance = null
var local_structure_type = null
var placement_position = null
var is_placing: bool = false
var is_placeable: bool = false
# var is_overlapping: bool = false # TODO
var selected_structure = null
#endregion

#region GAME FUNCTIONS
func _ready():
#region SIGNAL CONNECTIONS
	connect_signal(build_menu, "build_button_pressed")
	connect_signal(player_side, "mouse_entered_player_side")
	connect_signal(player_side, "mouse_exited_player_side")
	connect_signal(upgrade_menu, "upgrade_button_pressed")
	connect_signal(upgrade_menu, "sell_button_pressed")
#endregion
	start_game_tick()

func _process(_delta) -> void:
	handle_placement(get_global_mouse_position())
	handle_deselect()

func start_game_tick():
	game_timer.wait_time = tick_interval
	game_timer.start()
	game_timer.timeout.connect(_process_game_tick)
#endregion

#region BUILD FUNCTIONS
func start_placement(structure_type: GameData.StructureType):
	if GameData.get_structure_scene(structure_type):
		structure_instance = GameData.get_structure_scene(structure_type).instantiate()
		$Structures.add_child(structure_instance)
		local_structure_type = structure_type
		is_placing = true
		build_menu._on_hide_button_toggled(true)
	else:
		print("Main.start_placement: structure scene is not found")

func handle_placement(mouse_position):
	if is_placing:
		if Input.is_action_pressed("cancel"):
			cancel_placement()
	
		if Input.is_action_pressed("confirm"):
			placement_position = get_global_mouse_position()
			confirm_placement()
		
		if structure_instance:
			structure_instance.global_position = mouse_position

func confirm_placement():
	if is_placeable and PlayerData.ammo_count >= GameData.get_structure_cost(local_structure_type):
		is_placing = false
		
		structure_instance.position = placement_position
		structure_instance.find_child("Preview").queue_free()
		structure_instance.find_child("Sprite2D").show()
		
		match local_structure_type:
			GameData.StructureType.ATTACK:
				structure_instance.add_to_group("barracks")
			GameData.StructureType.RESOURCE:
				structure_instance.add_to_group("factories")
		connect_signal(structure_instance, "structure_selected")
		
		PlayerData.ammo_count -= GameData.get_structure_cost(local_structure_type)
		
		structure_instance = null
		local_structure_type = null
		placement_position = null
		
		build_menu._on_hide_button_toggled(false)
	else:
		cancel_placement()

func cancel_placement():
	is_placing = false
	structure_instance = null
	local_structure_type = null
	placement_position = null
	
	$Structures.get_child(-1).queue_free()
	build_menu._on_hide_button_toggled(false)
	opponent_side.hide()
#endregion

#region STRUCTURE FUNCTIONS
func gather_resources():
	if fmod(GameData.time_elapsed, base_factory_interval) == 0.0:
		PlayerData.ammo_count += base_factory_generation_amount * get_tree().get_nodes_in_group("f_00").size()
		PlayerData.ammo_count += upgraded_factory_generation_amount * get_tree().get_nodes_in_group("f_01").size()
	if fmod(GameData.time_elapsed, upgraded_factory_interval) == 0.0:
		PlayerData.ammo_count += base_factory_generation_amount * get_tree().get_nodes_in_group("f_10").size()
		PlayerData.ammo_count += upgraded_factory_generation_amount * get_tree().get_nodes_in_group("f_11").size()

func train_troops():
	if fmod(GameData.time_elapsed, barracks_interval) == 0.0:
		PlayerData.infantry_count += get_tree().get_nodes_in_group("barracks").size()

func highlight_structure(structure):
	structure.find_child("Highlight").show()

func deselect_structure(structure):
	structure.find_child("Highlight").hide()
	upgrade_menu.hide()
	build_menu.show()

func handle_deselect():
	if Input.is_action_pressed("cancel") and selected_structure:
		deselect_structure(selected_structure)
		selected_structure = null
#endregion

#region SIGNAL FUNCTIONS
func _on_build_button_pressed_received(structure_type: GameData.StructureType):
	if not structure_instance:
		start_placement(structure_type)
	else:
		cancel_placement()
		start_placement(structure_type)

func _on_upgrade_button_pressed_received(upgrade_index: int):
	if selected_structure:
		if GameData.get_upgrade_cost(selected_structure.structure_type, upgrade_index) <= PlayerData.ammo_count:
			PlayerData.ammo_count -= GameData.get_upgrade_cost(selected_structure.structure_type, upgrade_index)
			selected_structure.set_upgrade(upgrade_index)

func _on_sell_button_pressed_received(structure):
	PlayerData.ammo_count += structure.get_sell_value()
	deselect_structure(structure)
	structure.queue_free()

func _on_mouse_entered_player_side_received():
	is_placeable = true
	if is_placing:
		opponent_side.hide()

func _on_mouse_exited_player_side_received():
	is_placeable = false
	if is_placing:
		opponent_side.show()

func _process_game_tick():
	GameData.time_elapsed += tick_interval
	
	gather_resources()
	train_troops()
	
	@warning_ignore("standalone_expression")
	game_timer.wait_time
	game_timer.start()

func _on_structure_selected_received(structure):
	if selected_structure:
		deselect_structure(selected_structure)
	
	selected_structure = structure
	highlight_structure(selected_structure)
	build_menu.hide()
	upgrade_menu.show()
	upgrade_menu.initialize_buttons(structure)
#endregion

#region HELPER FUNCTIONS
func connect_signal(sender: Node, signal_name: String):
	if sender:
		sender.connect(signal_name, Callable(self, "_on_" + signal_name + "_received"))
	else:
		print("Main.connect_signal: sender is false")
#endregion
