extends Node


@export var base_factory_interval: float = 2.5
@export var upgraded_factory_interval: float = 1.5
@export var base_factory_generation_amount: int = 25
@export var upgraded_factory_generation_amount: int = 50

@export var base_barracks_interval: float = 3.5
@export var upgraded_barracks_interval: float = 2

@onready var hud = $"../HUD"


func generate_command_center():
	# ADD GREEN (PLAYER) COMMAND CENTER
	var local_command_center_instance: Structure = GameData.get_structure_scene(GameData.StructureType.COMMAND).instantiate()
	local_command_center_instance.position = GameData.PLAYER_COMMAND_CENTER_POSITION
	add_child(local_command_center_instance)
	local_command_center_instance.set_sprite(true)
	SignalHandler.connect_signal(local_command_center_instance, hud, "structure_selected")
	
	# ADD RED (ENEMY) COMMAND CENTER
	local_command_center_instance = GameData.get_structure_scene(GameData.StructureType.COMMAND).instantiate()
	local_command_center_instance.position = GameData.ENEMY_COMMAND_CENTER_POSITION
	add_child(local_command_center_instance)
	local_command_center_instance.set_sprite(false)

func _process_game_tick() -> void:
	gather_resources()
	train_troops()

func gather_resources() -> void:
	if fmod(GameData.time_elapsed, base_factory_interval) == 0.0:
		PlayerData.ammo_count += base_factory_generation_amount * get_tree().get_nodes_in_group("f_00").size()
		PlayerData.ammo_count += upgraded_factory_generation_amount * get_tree().get_nodes_in_group("f_01").size()
	if fmod(GameData.time_elapsed, upgraded_factory_interval) == 0.0:
		PlayerData.ammo_count += base_factory_generation_amount * get_tree().get_nodes_in_group("f_10").size()
		PlayerData.ammo_count += upgraded_factory_generation_amount * get_tree().get_nodes_in_group("f_11").size()

func train_troops() -> void:
	if fmod(GameData.time_elapsed, base_barracks_interval) == 0.0:
		PlayerData.infantry_count += get_tree().get_nodes_in_group("b_00").size()
		PlayerData.colonel_count += get_tree().get_nodes_in_group("b_01").size()
	if fmod(GameData.time_elapsed, upgraded_barracks_interval) == 0.0:
		PlayerData.infantry_count += get_tree().get_nodes_in_group("b_10").size()
		PlayerData.colonel_count += get_tree().get_nodes_in_group("b_11").size()
