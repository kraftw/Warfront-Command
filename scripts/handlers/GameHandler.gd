extends Node2D


@export var tick_interval: float = 0.5
@onready var game_timer = $GameTimer
@onready var game_label = $GameLabel
@onready var BuildHandler = $BuildHandler
@onready var StructureHandler = $Structures
@onready var UIHandler = $HUD

var game_running: bool = false

func _ready() -> void:
	start_game()

func _process(_delta) -> void:
	BuildHandler.handle_placement(get_global_mouse_position())

func start_game():
	game_running = true
	start_game_tick()
	game_label.hide()
	StructureHandler.generate_command_centers()
	StructureHandler.generate_defense_towers()

func start_game_tick() -> void:
	game_timer.wait_time = tick_interval
	game_timer.start()
	game_timer.timeout.connect(_process_game_tick)

func _process_game_tick() -> void:
	GameData.time_elapsed += tick_interval
	
	StructureHandler._process_game_tick()
	
	@warning_ignore("standalone_expression")
	game_timer.wait_time
	game_timer.start()

func _on_game_won():
	game_label.show()
	game_label.text = "YOU WON :)"

func _on_game_lost():
	game_label.show()
	game_label.text = "YOU LOST :("
