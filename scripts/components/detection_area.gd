extends Area2D

@export var base_defense_tower_detection_radius: float = 64.0
@export var upgraded_defense_tower_detection_radius: float = 96.0
@export var unit_detection_radius: float = 32.0

@onready var detection_shape: CircleShape2D = $CollisionShape2D.shape

var parent: Node = null

signal enemy_entered(enemy)
signal enemy_exited(enemy)

func _ready() -> void:
	parent = get_parent()

func set_detection_radius() -> void:
	if parent.is_in_group("dt_00") or parent.is_in_group("dt_01"):
		detection_shape.radius = base_defense_tower_detection_radius
		set_player_collisions()
	elif parent.is_in_group("dt_10") or parent.is_in_group("dt_11"):
		detection_shape.radius = upgraded_defense_tower_detection_radius
		set_player_collisions()
	elif parent.is_in_group("player_units"):
		detection_shape.radius = unit_detection_radius
		set_player_collisions()
	else:
		print("DetectionArea: parent is in invalid groups")

func set_player_collisions() -> void:
	self.collision_layer = GameData.get_collision_layer_index(GameData.CollisionLayers.PLAYER)
	self.collision_mask = GameData.get_collision_mask_index(GameData.CollisionMasks.ENEMY)

func _on_area_entered(area: Area2D) -> void:
	emit_signal("enemy_entered", area)

func _on_area_exited(area: Area2D) -> void:
	emit_signal("enemy_exited", area)
