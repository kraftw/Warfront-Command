extends Node

#region VARIABLES
@onready var hud = $"../HUD"
@onready var build_menu = $"../HUD/BuildMenu"
@onready var background = $"../Background"
@onready var opponent_side = $"../Background/OpponentSide"

var structure_instance: UpgradeableStructure = null
var local_structure_type = null
var placement_position = null
var is_placing: bool = false
var is_placeable: bool = false
#endregion

func _ready() -> void:
	SignalHandler.connect_signal(background, self, "mouse_entered_player_side")
	SignalHandler.connect_signal(background, self, "mouse_exited_player_side")

func start_placement(structure_type: GameData.StructureType) -> void:
	if GameData.get_structure_scene(structure_type):
		structure_instance = GameData.get_structure_scene(structure_type).instantiate()
		$Structures.add_child(structure_instance)
		local_structure_type = structure_type
		is_placing = true
		build_menu._on_hide_button_toggled(true)
	else:
		print("Main.start_placement: structure scene is not found")

func handle_placement(mouse_position) -> void:
	if is_placing:
		if Input.is_action_pressed("cancel"):
			cancel_placement()
	
		if Input.is_action_pressed("confirm"):
			placement_position = mouse_position
			confirm_placement()
		
		if structure_instance:
			structure_instance.global_position = mouse_position

func confirm_placement() -> void:
	if is_placeable and PlayerData.ammo_count >= GameData.get_structure_cost(local_structure_type):
		is_placing = false
		
		structure_instance.position = placement_position
		structure_instance.find_child("Preview").queue_free()
		structure_instance.find_child("Sprite2D").show()
		structure_instance.place()
		
		SignalHandler.connect_signal(structure_instance, hud, "structure_selected")
		
		PlayerData.ammo_count -= GameData.get_structure_cost(local_structure_type)
		
		structure_instance = null
		local_structure_type = null
		placement_position = null
		
		build_menu._on_hide_button_toggled(false)
	else:
		cancel_placement()

func cancel_placement() -> void:
	is_placing = false
	structure_instance = null
	local_structure_type = null
	placement_position = null
	
	$Structures.get_child(-1).queue_free()
	build_menu._on_hide_button_toggled(false)
	opponent_side.hide()

func _on_mouse_entered_player_side() -> void:
	is_placeable = true
	if is_placing:
		opponent_side.hide()

func _on_mouse_exited_player_side() -> void:
	is_placeable = false
	if is_placing:
		opponent_side.show()
