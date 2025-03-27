extends Node

enum StructureType { ATTACK, DEFENSE, RESOURCE, COMMAND, NODE }

@export var structures = {
	StructureType.ATTACK: {
			"name": "Barracks",
			"cost": 500,
			"icon": preload("res://assets/sprites/green/barracks-GRN_720.png"),
			"scene": preload("res://scenes/structures/barracks.tscn"),
	},
	StructureType.DEFENSE: {
			"name": "Defense Tower",
			"cost": 200,
			"icon": preload("res://assets/sprites/green/defense_tower-GRN_720.png"),
			"scene": preload("res://scenes/structures/defense_tower.tscn"),
	},
	StructureType.RESOURCE: {
			"name": "Factory",
			"cost": 300,
			"icon": preload("res://assets/sprites/green/factory_static-GRN_720.png"),
			"scene": preload("res://scenes/structures/factory.tscn"),
	},
	StructureType.COMMAND: {
			"name": "Command Center",
			"cost": null,
			"icon": preload("res://assets/sprites/green/command_center_static-GRN_720.png"),
			"scene": null,
	},
	StructureType.NODE: {
			"name": "Abandoned Factory",
			"cost": null,
			"icon": preload("res://assets/sprites/neutral/abandoned_factory-720.png"),
			"scene": null,
	},
}

# GETTER FUNCTIONS
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

func get_structure_icon(structure_type: StructureType):
	if structure_type in structures:
		if structures[structure_type]["icon"]:
			return structures[structure_type]["icon"]
	print("GameData: structure icon not found")

func get_structure_scene(structure_type: StructureType) -> PackedScene:
	if structure_type in structures:
		if structures[structure_type]["scene"]:
			return structures[structure_type]["scene"]
	print("GameData: structure scene not found")
	return null
