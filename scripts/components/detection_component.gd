extends Area2D


@export var base_defense_tower_detection_radius: float = 112.0
@export var upgraded_defense_tower_detection_radius: float = 168.0
@export var unit_detection_radius: float = 56.0

@onready var detection_shape: CircleShape2D = $CollisionShape2D.shape

var parent: Node = null
var attack_component: AttackComponent = null


func _ready() -> void:
	setup_detection_area()

#region SETUP FUNCTIONS
func setup_detection_area() -> void:
	parent = get_parent()
	await get_tree().process_frame
	attack_component = parent.get_node_or_null("AttackComponent")
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

func _on_enemy_detected(area: Area2D) -> void:
	if not attack_component:
		return
	
	if parent.is_green:
		if area.get_parent().is_in_group("enemy_units") or area.is_in_group("enemy_destructibles"):
			if parent is Unit:
				parent.is_moving = false
			
			if area.get_parent().is_in_group("enemy_units"):
				attack_component.set_target(area.get_parent())
			else:
				attack_component.set_target(area)
	elif not parent.is_green:
		if area.get_parent().is_in_group("player_units") or area.is_in_group("player_destructibles"):
			if parent is Unit:
				parent.is_moving = false
			
			if area.get_parent().is_in_group("player_units"):
				attack_component.set_target(area.get_parent())
			else:
				attack_component.set_target(area)


func _on_enemy_lost(area: Area2D) -> void:
	if not attack_component:
		return
	
	if parent.is_green:
		if area.is_in_group("enemy_units") or area.is_in_group("enemy_destructibles"):
			if attack_component.target == area or attack_component.target == area.get_parent():
				attack_component.clear_target()
	elif not parent.is_green:
		if area.get_parent().is_in_group("player_units") or area.is_in_group("player_destructibles"):
			if attack_component.target == area or attack_component.target == area.get_parent():
				attack_component.clear_target()
		pass
