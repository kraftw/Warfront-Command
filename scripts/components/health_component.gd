extends Node2D
class_name HealthComponent


@onready var parent: Node = get_parent()
@onready var health_bar: Control = find_child("HealthBar")
@onready var present_health: Panel = health_bar.find_child("PresentHealth")
@onready var missing_health: Panel = health_bar.find_child("MissingHealth")
@onready var sprite: AnimatedSprite2D = parent.find_child("Sprite2D")

var max_health: float = 100.0
var current_health: float = 100.0


func configure(new_max_health: float) -> void:
	max_health = new_max_health
	current_health = new_max_health

func take_damage(amount: float) -> void:
	current_health -= amount
	handle_health_bar()
	if current_health <= 0:
		die()

func die() -> void:
	parent.queue_free()

func handle_health_bar() -> void:
	var ratio = current_health / max_health
	present_health.size_flags_stretch_ratio = ratio
	missing_health.size_flags_stretch_ratio = 1.0 - ratio
	
	if current_health == max_health:
		hide()
	else:
		show()
	
	handle_theme_overrides(ratio)

func handle_theme_overrides(ratio: float) -> void:
	var style := present_health.get_theme_stylebox("panel") as StyleBoxFlat
	
	if ratio == 1.0:
		style.corner_radius_bottom_right = 18
		style.corner_radius_top_right = 18
	elif 1.0 - ratio > -2.0:
		style.corner_radius_bottom_right = 0
		style.corner_radius_top_right = 0
