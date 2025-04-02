extends CharacterBody2D
class_name Unit


@onready var sprite: AnimatedSprite2D = $Sprite2D

var is_green: bool = false
var is_colonel: bool = false
var parent: Node = null


func _ready() -> void:
	parent = get_parent()

func _process(_delta: float) -> void:
	if parent.current_state == GameData.UnitState.RETREATING:
		if position == GameData.PLAYER_COMMAND_CENTER_POSITION:
			if is_colonel:
				parent.active_colonel -= 1
			if not is_colonel:
				parent.active_infantry -= 1
			queue_free()

func set_sprite() -> void:
	var color = "green" if is_green else "red"
	var unit_type = "colonel" if is_colonel else "infantry"
	sprite.play(color + "_" + unit_type)
