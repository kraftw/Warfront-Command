extends Node

var is_game_running: bool = true
var time_elapsed: float = 0.0

enum StructureType { ATTACK, DEFENSE, RESOURCE, COMMAND }

@export var structures = {
	StructureType.ATTACK: {
			"name": "Barracks",
			"cost": 500,
			"upgrades": {
				0: {
					"name": "Faster Training",
					"cost": 350,
					"icon": null,
				},
				1: {
					"name": "Train Colonels",
					"cost": 600,
					"icon": null,
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
					"cost": 100,
					"icon": null,
				},
				1: {
					"name": "Faster Firing",
					"cost": 250,
					"icon": null,
				},
			},
			"scene": preload("res://scenes/structures/defense_tower.tscn"),
	},
	StructureType.RESOURCE: {
			"name": "Factory",
			"cost": 300,
			"upgrades": {
				0: {
					"name": "Faster Production",
					"cost": 250,
					"icon": null,
				},
				1: {
					"name": "Double Output",
					"cost": 400,
					"icon": null,
				},
			},
			"scene": preload("res://scenes/structures/factory.tscn"),
	},
	StructureType.COMMAND: {
			"name": "Command Center",
			"cost": null,
			"scene": null,
	},
}

#region GETTER FUNCTIONS
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
