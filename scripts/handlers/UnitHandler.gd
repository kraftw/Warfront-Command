extends Node


@onready var spawn_timer = $"../SpawnTimer"
@onready var queue_timer = $"../QueueTimer" # CHECKS UNIT COUNT PERIODICALLY
@onready var UIHandler = $"../HUD"
@onready var StructureHandler = $"../Structures"

@export var spawn_cooldown: float = 1.5
@export var attack_position: Vector2

var active_infantry: int = 0
var active_colonel: int = 0
var spawn_queue := [] # HOLDS STRINGS EQUAL TO "infantry" AND "colonel
var current_state: GameData.UnitState = GameData.UnitState.RETREATING
var unit_scene: PackedScene = load("res://scenes/units/unit.tscn")


func _ready() -> void:
	SignalHandler.connect_signal(UIHandler, self, "command_received")

func _on_command_received(command: String) -> void:
	match command:
		"ATTACK":
			current_state = GameData.UnitState.ATTACKING
			queue_timer.start()
			attack()
		"DEFEND":
			current_state = GameData.UnitState.DEFENDING
			queue_timer.start()
			defend()
		"RETREAT":
			current_state = GameData.UnitState.RETREATING
			queue_timer.stop()
			retreat()

func attack():
	queue_units()
	for unit in get_tree().get_nodes_in_group("units"):
		unit.attack()

func defend():
	queue_units()
	for unit in get_tree().get_nodes_in_group("units"):
		unit.defend()

func retreat():
	spawn_queue.clear()
	spawn_timer.stop()
	for unit in get_tree().get_nodes_in_group("units"):
		unit.retreat()

func queue_units():
	if not spawn_queue.is_empty() or not spawn_timer.is_stopped():
		return
	
	var colonels_to_spawn = PlayerData.colonel_count - active_colonel
	for c in colonels_to_spawn:
		spawn_queue.append("colonel")
	
	var infantry_to_spawn = PlayerData.infantry_count - active_infantry
	for i in infantry_to_spawn:
		spawn_queue.append("infantry")
	
	if spawn_queue.size() > 1000:
		push_warning("UnitHandler: oversized spawn queue size")
	
	if spawn_queue.size() > 0:
		var first_type = spawn_queue.pop_front()
		var is_colonel = first_type == "colonel"
		spawn_units(is_colonel)
		
		if spawn_timer.is_stopped():
			spawn_timer.start(spawn_cooldown)

func spawn_units(is_colonel: bool) -> Unit:
	var unit_instance: Unit = unit_scene.instantiate()
	self.add_child(unit_instance)
	
	unit_instance.add_to_group("units")
	unit_instance.position = GameData.PLAYER_COMMAND_CENTER_POSITION
	unit_instance.is_green = true
	
	if is_colonel:
		unit_instance.is_colonel = true
		unit_instance.add_to_group("colonels")
		active_colonel += 1
	if not is_colonel:
		unit_instance.add_to_group("infantry")
		active_infantry += 1
		
	unit_instance.set_sprite()
	
	match current_state:
		GameData.UnitState.ATTACKING:
			unit_instance.attack()
		GameData.UnitState.DEFENDING:
			unit_instance.defend()
		GameData.UnitState.RETREATING:
			unit_instance.retreat()
	
	return unit_instance

func _on_spawn_timer_timeout() -> void:
	if spawn_queue.is_empty():
		spawn_timer.stop()
		return
	
	var type = spawn_queue.pop_front()
	var is_colonel = type == "colonel"
	spawn_units(is_colonel)
	
	if not spawn_queue.is_empty():
		spawn_timer.start(spawn_cooldown)

func _on_queue_timer_timeout() -> void:
	queue_units()
