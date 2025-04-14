extends Node


@export var base_factory_interval: float = 2.0
@export var upgraded_factory_interval: float = 1.5
@export var base_factory_generation_amount: int = 25
@export var upgraded_factory_generation_amount: int = 50

@export var base_barracks_interval: float = 10.0
@export var upgraded_barracks_interval: float = 8.0

@onready var hud = $"../HUD"
@onready var game_handler = $".."


#region STRUCTURE GENERATION FUNCTIONS
func generate_command_centers():
	generate_command_center(true)
	generate_command_center(false)

func generate_defense_towers():
	generate_defense_tower(Vector2(896, 160))
	generate_defense_tower(Vector2(896, 306))

func generate_command_center(is_green: bool) -> void:
	var position = GameData.PLAYER_COMMAND_CENTER_POSITION if is_green else GameData.ENEMY_COMMAND_CENTER_POSITION
	var owner_string: String = "player" if is_green else "enemy"
	var collision_layer = GameData.CollisionLayers.PLAYER if is_green else GameData.CollisionLayers.ENEMY
	var collision_mask = GameData.CollisionLayers.ENEMY if is_green else GameData.CollisionLayers.PLAYER
	
	var command_center_instance: Structure = GameData.get_structure_scene(GameData.StructureType.COMMAND).instantiate()
	command_center_instance.position = position
	add_child(command_center_instance)
	
	command_center_instance.add_to_group(owner_string + "_destructibles")
	command_center_instance.add_to_group(owner_string + "_command_center")
	command_center_instance.collision_layer = GameData.get_collision_layer_index(collision_layer)
	command_center_instance.collision_mask = GameData.get_collision_mask_index(collision_mask)
	command_center_instance.get_node("HealthComponent").configure(GameData.StructureStats["command_center"].health)
	command_center_instance.set_sprite(is_green)
	SignalHandler.connect_signal(command_center_instance.find_child("HealthComponent"), game_handler, "game_won")
	SignalHandler.connect_signal(command_center_instance.find_child("HealthComponent"), game_handler, "game_lost")
	
	if is_green:
		SignalHandler.connect_signal(command_center_instance, hud, "structure_selected")

func generate_defense_tower(position: Vector2):
	var defense_tower_instance: UpgradeableStructure = GameData.get_structure_scene(GameData.StructureType.DEFENSE).instantiate()
	defense_tower_instance.position = position
	add_child(defense_tower_instance)
	
	defense_tower_instance.find_child("Preview").queue_free()
	defense_tower_instance.find_child("Sprite2D").show()
	defense_tower_instance.add_to_group("dt_00")
	defense_tower_instance.add_to_group("enemy_destructibles")
	defense_tower_instance.collision_layer = GameData.get_collision_layer_index(GameData.CollisionLayers.ENEMY)
	defense_tower_instance.collision_mask = GameData.get_collision_mask_index(GameData.CollisionMasks.PLAYER)
	defense_tower_instance.set_sprite(false)
#endregion

#region GAME TICK FUNCTIONS
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
#endregion
