extends Node

#region GAME DATA
var is_game_running: bool = true
var time_elapsed: float = 0.0
#endregion

#region COLLISION DATA
# NAMED BASED ON WHAT IT IS / WHAT IT IS CHECKING FOR
enum CollisionLayers { PLAYER, ENEMY }
enum CollisionMasks { ENEMY, PLAYER }

const COLLISION_LAYERS = {
	CollisionLayers.PLAYER: 7,
	CollisionLayers.ENEMY: 8,
}

const COLLISION_MASKS = {
	CollisionMasks.PLAYER: 7,
	CollisionMasks.ENEMY: 8,
}
#endregion

#region POSITION DATA
const PLAYER_COMMAND_CENTER_POSITION: Vector2 = Vector2(224, 544)
const ENEMY_COMMAND_CENTER_POSITION: Vector2 = Vector2(1056, 176)
#endregion

#region STRUCTURE DATA
enum StructureType { ATTACK, DEFENSE, RESOURCE, COMMAND }

@export var structures = {
	StructureType.ATTACK: {
		"name": "Barracks",
		"cost": 500,
		"upgrades": {
			0: {
				"name": "Faster Training",
				"cost": 350,
				"icon": preload("res://assets/sprites/green/upgrades/barracks_10-GRN_720.png"),
			},
			1: {
				"name": "Train Colonels",
				"cost": 600,
				"icon": preload("res://assets/sprites/green/upgrades/barracks_01-GRN_720.png"),
			},
		},
		"scene": preload("res://scenes/structures/barracks.tscn"),
	},
	StructureType.DEFENSE: {
		"name": "Defense Tower",
		"cost": 200,
		"upgrades": {
			0: {
				"name": "Bigger Radius",
				"cost": 150,
				"icon": preload("res://assets/sprites/green/upgrades/defense_tower_10-GRN_720.png"),
			},
			1: {
				"name": "Machine Guns",
				"cost": 350,
				"icon": preload("res://assets/sprites/green/upgrades/defense_tower_01-GRN_720.png"),
			},
		},
		"scene": preload("res://scenes/structures/defense_tower.tscn"),
	},
	StructureType.RESOURCE: {
		"name": "Factory",
		"cost": 500,
		"upgrades": {
			0: {
				"name": "Faster Production",
				"cost": 350,
				"icon": preload("res://assets/sprites/green/upgrades/factory_10_static-GRN_720.png"),
			},
			1: {
				"name": "Nuclear Power",
				"cost": 750,
				"icon": preload("res://assets/sprites/green/upgrades/factory_01_static-GRN_720.png"),
			},
		},
		"scene": preload("res://scenes/structures/factory.tscn"),
	},
	StructureType.COMMAND: {
		"name": "Command Center",
		"scene": preload("res://scenes/structures/command_center.tscn"),
	},
}
#endregion

#region UNIT DATA
enum UnitState { ATTACKING, DEFENDING, RETREATING }
#endregion

#region STATS DATA
const UnitStats = {
	"infantry": { "damage": 5.0, "attack_speed": 1.0, "health": 20.0 },
	"colonel": { "damage": 15.0, "attack_speed": 2.5, "health": 65.0 },
}

const StructureStats = {
	"base_dt": { "damage": 10.0, "attack_speed": 1.5, "health": 80.0 },
	"upgraded_dt": { "damage": 10.0, "attack_speed": 0.5 },
	"command_center": { "health": 100.0 }
}
#endregion

#region GETTER FUNCTIONS
func get_collision_layer_index(collision_layer: CollisionLayers):
	if collision_layer in COLLISION_LAYERS:
		if COLLISION_LAYERS[collision_layer]:
			return COLLISION_LAYERS[collision_layer]
	print("GameData: collision layer not found")
	return null

func get_collision_mask_index(collision_mask: CollisionMasks):
	if collision_mask in COLLISION_MASKS:
		if COLLISION_MASKS[collision_mask]:
			return COLLISION_MASKS[collision_mask]
	print("GameData: collision mask not found")
	return null

func get_structure_name(structure_type: StructureType) -> String:
	if structure_type in structures:
		if structures[structure_type]["name"]:
			return structures[structure_type]["name"]
	print("GameData: structure name not found")
	return "error"

func get_structure_cost(structure_type: StructureType) -> int:
	if structure_type in structures:
		if structures[structure_type]["cost"]:
			return structures[structure_type]["cost"]
	print("GameData: structure cost not found")
	return -1

func get_upgrade_name(structure_type: StructureType, index: int) -> String:
	if structure_type in structures:
		if structures[structure_type]["upgrades"][index]["name"]:
			return structures[structure_type]["upgrades"][index]["name"]
	print("GameData: upgrade name not found")
	return "error"

func get_upgrade_cost(structure_type: StructureType, index: int) -> int:
	if structure_type in structures:
		if structures[structure_type]["upgrades"][index]["cost"]:
			return structures[structure_type]["upgrades"][index]["cost"]
	print("GameData: upgrade cost not found")
	return -1

func get_upgrade_icon(structure_type: StructureType, index: int):
	if structure_type in structures:
		if structures[structure_type]["upgrades"][index]["icon"]:
			return structures[structure_type]["upgrades"][index]["icon"]
	print("GameData: upgrade icon not found")
	return null

func get_structure_scene(structure_type: StructureType) -> PackedScene:
	if structure_type in structures:
		if structures[structure_type]["scene"]:
			return structures[structure_type]["scene"]
	print("GameData: structure scene not found")
	return null
#endregion
