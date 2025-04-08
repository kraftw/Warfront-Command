extends Area2D

@export var base_defense_tower_detection_radius: float = 112.0
@export var upgraded_defense_tower_detection_radius: float = 168.0
@export var unit_detection_radius: float = 56.0

@onready var detection_shape: CircleShape2D = $CollisionShape2D.shape

var parent: Node = null


func _ready() -> void:
	setup_detection_area()

#region SETUP FUNCTIONS
func setup_detection_area() -> void:
	parent = get_parent()
	await get_tree().process_frame
	set_detection_radius()
	setup_collisions()

func set_detection_radius() -> void:
	if parent.is_in_group("dt_00") or parent.is_in_group("dt_01"):
		detection_shape.radius = base_defense_tower_detection_radius
	elif parent.is_in_group("dt_10") or parent.is_in_group("dt_11"):
		detection_shape.radius = upgraded_defense_tower_detection_radius
	elif parent.is_in_group("player_units"):
		detection_shape.radius = unit_detection_radius
	else:
		print("DetectionArea: parent is in invalid groups")

func setup_collisions():
	if parent.is_green:
		set_player_collisions()
	elif not parent.is_green:
		set_enemy_collisions()

func set_player_collisions() -> void:
	collision_layer = GameData.get_collision_layer_index(GameData.CollisionLayers.PLAYER)
	collision_mask = GameData.get_collision_mask_index(GameData.CollisionMasks.ENEMY)

func set_enemy_collisions() -> void:
	collision_layer = GameData.get_collision_layer_index(GameData.CollisionLayers.ENEMY)
	collision_mask = GameData.get_collision_mask_index(GameData.CollisionMasks.PLAYER)

#endregion

func _on_area_entered(area: Area2D) -> void:
	print(area.name, " entered")
	print("		layer:", area.collision_layer)
	print("		mask:", area.collision_mask)
	pass

func _on_area_exited(area: Area2D) -> void:
	print(area.name, " exited")
	print("		layer:", area.collision_layer)
	print("		mask:", area.collision_mask)
	pass
