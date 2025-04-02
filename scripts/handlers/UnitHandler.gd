extends Node


@onready var UIHandler = $"../HUD"
@onready var StructureHandler = $"../Structures"

var active_infantry: int = 0
var active_colonel: int = 0
var current_state: GameData.UnitState = GameData.UnitState.RETREATING
var unit_scene: PackedScene = load("res://scenes/units/unit.tscn")
var spawn_cooldown: float = 0.5


func _ready() -> void:
	SignalHandler.connect_signal(UIHandler, self, "command_received")

func _process(_delta: float) -> void:
	match current_state:
		GameData.UnitState.ATTACKING:
			attack()
		GameData.UnitState.DEFENDING:
			defend()
		GameData.UnitState.RETREATING:
			retreat()

func attack():
	while active_colonel < PlayerData.colonel_count:
		spawn_units(true)
	while active_infantry < PlayerData.infantry_count:
		spawn_units(false)

func defend():
	while active_colonel < PlayerData.colonel_count:
		spawn_units(true)
	while active_infantry < PlayerData.infantry_count:
		spawn_units(false)

func retreat():
	pass

func spawn_units(is_colonel: bool):
	if fmod(GameData.time_elapsed, spawn_cooldown) == 0:
		var unit_instance: Unit = unit_scene.instantiate()
		self.add_child(unit_instance)
		unit_instance.position = GameData.PLAYER_COMMAND_CENTER_POSITION
		unit_instance.is_green = true
		if is_colonel:
			unit_instance.is_colonel = true
			active_colonel += 1
		if not is_colonel:
			active_infantry += 1
		unit_instance.set_sprite()

func _on_command_received(command: String) -> void:
	match command:
		"ATTACK":
			current_state = GameData.UnitState.ATTACKING
		"DEFEND":
			current_state = GameData.UnitState.DEFENDING
		"RETREAT":
			current_state = GameData.UnitState.RETREATING
