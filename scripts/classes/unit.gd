extends CharacterBody2D
class_name Unit


@onready var sprite: AnimatedSprite2D = $Sprite2D

@export var speed: float = 65.0
@export var attack_threshold: float = 64.0 # DISTANCE TO ENEMY COMMAND CENTER BEFORE STOPPING
@export var defend_threshold: float = 64.0 # DISTANCE TO PLAYER COMMAND CENTER BEFORE STOPPING
@export var retreat_threshold: float = 32.0 # DISTANCE TO PLAYER COMMAND CENTER BEFORE DESPAWNING

var parent: Node = null
var is_green: bool = false
var is_colonel: bool = false
var target_position: Vector2
var distance_threshold: float
var is_moving: bool = false
var is_retreating: bool = false


func _ready() -> void:
	parent = get_parent()

func attack():
	is_retreating = false
	move_to(GameData.ENEMY_COMMAND_CENTER_POSITION, attack_threshold)

func defend():
	is_retreating = false
	move_to(GameData.PLAYER_COMMAND_CENTER_POSITION, defend_threshold)

func retreat():
	is_retreating = true
	move_to(GameData.PLAYER_COMMAND_CENTER_POSITION, retreat_threshold)

func move_to(pos: Vector2, threshold: float):
	target_position = pos
	distance_threshold = threshold
	is_moving = true

func _physics_process(_delta: float) -> void:
	if is_moving:
		var direction = (target_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()
		
		if global_position.distance_to(target_position) < distance_threshold:
			is_moving = false
			if is_retreating:
				handle_despawn()

func handle_despawn():
	if is_colonel:
		parent.active_colonel -= 1
	if not is_colonel:
		parent.active_infantry -= 1
	queue_free()

func set_sprite() -> void:
	var color = "green" if is_green else "red"
	var unit_type = "colonel" if is_colonel else "infantry"
	sprite.play(color + "_" + unit_type)
